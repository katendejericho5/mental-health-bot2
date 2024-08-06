import pickle
from contextlib import AbstractContextManager
from types import TracebackType
from typing import Any, Dict, Iterator, Optional

from langchain_core.runnables import RunnableConfig
from typing_extensions import Self

from langgraph.checkpoint.base import (
    BaseCheckpointSaver,
    Checkpoint,
    CheckpointMetadata,
    CheckpointTuple,
    SerializerProtocol,
)
from langgraph.serde.jsonplus import JsonPlusSerializer
from pymongo import MongoClient


class JsonPlusSerializerCompat(JsonPlusSerializer):
    """A serializer that supports loading pickled checkpoints for backwards compatibility.

    This serializer extends the JsonPlusSerializer and adds support for loading pickled
    checkpoints. If the input data starts with b"\x80" and ends with b".", it is treated
    as a pickled checkpoint and loaded using pickle.loads(). Otherwise, the default
    JsonPlusSerializer behavior is used.

    Examples:
        >>> import pickle
        >>> from langgraph.checkpoint.sqlite import JsonPlusSerializerCompat
        >>>
        >>> serializer = JsonPlusSerializerCompat()
        >>> pickled_data = pickle.dumps({"key": "value"})
        >>> loaded_data = serializer.loads(pickled_data)
        >>> print(loaded_data)  # Output: {"key": "value"}
        >>>
        >>> json_data = '{"key": "value"}'.encode("utf-8")
        >>> loaded_data = serializer.loads(json_data)
        >>> print(loaded_data)  # Output: {"key": "value"}
    """

    def loads(self, data: bytes) -> Any:
        if data.startswith(b"\x80") and data.endswith(b"."):
            return pickle.loads(data)
        return super().loads(data)


class MongoDBSaver(AbstractContextManager, BaseCheckpointSaver):
    """A checkpoint saver that stores checkpoints in a MongoDB database.

    Args:
        client (pymongo.MongoClient): The MongoDB client.
        db_name (str): The name of the database to use.
        collection_name (str): The name of the collection to use.
        serde (Optional[SerializerProtocol]): The serializer to use for serializing and deserializing checkpoints. Defaults to JsonPlusSerializerCompat.

    Examples:

        >>> from pymongo import MongoClient
        >>> from langgraph.checkpoint.mongodb import MongoDBSaver
        >>> from langgraph.graph import StateGraph
        >>>
        >>> builder = StateGraph(int)
        >>> builder.add_node("add_one", lambda x: x + 1)
        >>> builder.set_entry_point("add_one")
        >>> builder.set_finish_point("add_one")
        >>> client = MongoClient("mongodb://localhost:27017/")
        >>> memory = MongoDBSaver(client, "checkpoints", "checkpoints")
        >>> graph = builder.compile(checkpointer=memory)
        >>> config = {"configurable": {"thread_id": "1"}}
        >>> graph.get_state(config)
        >>> result = graph.invoke(3, config)
        >>> graph.get_state(config)
        StateSnapshot(values=4, next=(), config={'configurable': {'thread_id': '1', 'thread_ts': '2024-05-04T06:32:42.235444+00:00'}}, parent_config=None)
    """

    serde = JsonPlusSerializerCompat()

    client: MongoClient
    db_name: str
    collection_name: str

    def __init__(
        self,
        client: MongoClient,
        db_name: str,
        collection_name: str,
        *,
        serde: Optional[SerializerProtocol] = None,
    ) -> None:
        super().__init__(serde=serde)
        self.client = client
        self.db_name = db_name
        self.collection_name = collection_name
        self.collection = client[db_name][collection_name]

    def __enter__(self) -> Self:
        return self

    def __exit__(
        self,
        __exc_type: Optional[type[BaseException]],
        __exc_value: Optional[BaseException],
        __traceback: Optional[TracebackType],
    ) -> Optional[bool]:
        return True

    def get_tuple(self, config: RunnableConfig) -> Optional[CheckpointTuple]:
        """Get a checkpoint tuple from the database.

        This method retrieves a checkpoint tuple from the MongoDB database based on the
        provided config. If the config contains a "thread_ts" key, the checkpoint with
        the matching thread ID and timestamp is retrieved. Otherwise, the latest checkpoint
        for the given thread ID is retrieved.

        Args:
            config (RunnableConfig): The config to use for retrieving the checkpoint.

        Returns:
            Optional[CheckpointTuple]: The retrieved checkpoint tuple, or None if no matching checkpoint was found.
        """
        if config["configurable"].get("thread_ts"):
            query = {
                "thread_id": config["configurable"]["thread_id"],
                "thread_ts": config["configurable"]["thread_ts"],
            }
        else:
            query = {"thread_id": config["configurable"]["thread_id"]}
        result = self.collection.find(query).sort("thread_ts", -1).limit(1)
        for doc in result:
            return CheckpointTuple(
                config,
                self.serde.loads(doc["checkpoint"]),
                self.serde.loads(doc["metadata"]),
                (
                    {
                        "configurable": {
                            "thread_id": doc["thread_id"],
                            "thread_ts": doc["parent_ts"],
                        }
                    }
                    if doc.get("parent_ts")
                    else None
                ),
            )

    def list(
        self,
        config: Optional[RunnableConfig],
        *,
        filter: Optional[Dict[str, Any]] = None,
        before: Optional[RunnableConfig] = None,
        limit: Optional[int] = None,
    ) -> Iterator[CheckpointTuple]:
        """List checkpoints from the database.

        This method retrieves a list of checkpoint tuples from the MongoDB database based
        on the provided config. The checkpoints are ordered by timestamp in descending order.

        Args:
            config (RunnableConfig): The config to use for listing the checkpoints.
            before (Optional[RunnableConfig]): If provided, only checkpoints before the specified timestamp are returned. Defaults to None.
            limit (Optional[int]): The maximum number of checkpoints to return. Defaults to None.

        Yields:
            Iterator[CheckpointTuple]: An iterator of checkpoint tuples.
        """
        query = {}
        if config is not None:
            query["thread_id"] = config["configurable"]["thread_id"]
        if filter:
            for key, value in filter.items():
                query[f"metadata.{key}"] = value
        if before is not None:
            query["thread_ts"] = {"$lt": before["configurable"]["thread_ts"]}
        result = self.collection.find(query).sort("thread_ts", -1).limit(limit)
        for doc in result:
            yield CheckpointTuple(
                {
                    "configurable": {
                        "thread_id": doc["thread_id"],
                        "thread_ts": doc["thread_ts"],
                    }
                },
                self.serde.loads(doc["checkpoint"]),
                self.serde.loads(doc["metadata"]),
                (
                    {
                        "configurable": {
                            "thread_id": doc["thread_id"],
                            "thread_ts": doc["parent_ts"],
                        }
                    }
                    if doc.get("parent_ts")
                    else None
                ),
            )

    def put(
        self,
        config: RunnableConfig,
        checkpoint: Checkpoint,
        metadata: CheckpointMetadata,
    ) -> RunnableConfig:
        """Save a checkpoint to the database.

        This method saves a checkpoint to the MongoDB database. The checkpoint is associated
        with the provided config and its parent config (if any).

        Args:
            config (RunnableConfig): The config to associate with the checkpoint.
            checkpoint (Checkpoint): The checkpoint to save.
            metadata (Optional[dict[str, Any]]): Additional metadata to save with the checkpoint. Defaults to None.

        Returns:
            RunnableConfig: The updated config containing the saved checkpoint's timestamp.
        """
        doc = {
            "thread_id": config["configurable"]["thread_id"],
            "thread_ts": checkpoint["id"],
            "checkpoint": self.serde.dumps(checkpoint),
            "metadata": self.serde.dumps(metadata),
        }
        if config["configurable"].get("thread_ts"):
            doc["parent_ts"] = config["configurable"]["thread_ts"]
        self.collection.insert_one(doc)
        return {
            "configurable": {
                "thread_id": config["configurable"]["thread_id"],
                "thread_ts": checkpoint["id"],
            }
        }