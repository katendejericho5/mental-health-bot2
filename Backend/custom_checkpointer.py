"""Implementation of a langgraph checkpoint saver using Redis."""
import logging
from contextlib import asynccontextmanager, contextmanager
from typing import Any, AsyncGenerator, Generator, List, Optional, Tuple, Union
import redis
from redis.asyncio import ConnectionPool as AsyncConnectionPool
from redis.asyncio import Redis as AsyncRedis
from datetime import datetime, timezone

from langchain_core.runnables import RunnableConfig
from langgraph.checkpoint.base import BaseCheckpointSaver, Checkpoint, CheckpointMetadata, CheckpointTuple
"""Implementation of a langgraph checkpoint saver using Redis."""
from typing import Any, AsyncGenerator, Generator, Union, Tuple, Optional

from redis.asyncio import Redis as AsyncRedis, ConnectionPool as AsyncConnectionPool
from langchain_core.runnables import RunnableConfig
from langgraph.checkpoint.base import BaseCheckpointSaver
from langgraph.serde.jsonplus import JsonPlusSerializer
from langgraph.checkpoint.base import Checkpoint, CheckpointMetadata, CheckpointTuple
# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Serializer class
class JsonAndBinarySerializer(JsonPlusSerializer):
    """Serializer to handle both JSON and binary data."""
    def _default(self, obj: Any) -> Any:
        if isinstance(obj, (bytes, bytearray)):
            return self._encode_constructor_args(
                obj.__class__, method="fromhex", args=[obj.hex()]
            )
        return super()._default(obj)

    def dumps(self, obj: Any) -> str:
        """Serialize object to a JSON string."""
        try:
            if isinstance(obj, (bytes, bytearray)):
                return obj.hex()
            return super().dumps(obj)
        except Exception as e:
            logger.error(f"Serialization error: {e}")
            raise

    def loads(self, s: str, is_binary: bool = False) -> Any:
        """Deserialize object from a JSON string."""
        try:
            if is_binary:
                return bytes.fromhex(s)
            return super().loads(s)
        except Exception as e:
            logger.error(f"Deserialization error: {e}")
            raise

# Connection initialization
def initialize_sync_pool(host: str = "localhost", port: int = 6379, db: int = 0, **kwargs) -> redis.ConnectionPool:
    """Initialize a synchronous Redis connection pool."""
    try:
        pool = redis.ConnectionPool(host=host, port=port, db=db, **kwargs)
        logger.info(f"Synchronous Redis pool initialized with host={host}, port={port}, db={db}")
        return pool
    except Exception as e:
        logger.error(f"Error initializing sync pool: {e}")
        raise

def initialize_async_pool(url: str = "redis://localhost", **kwargs) -> AsyncConnectionPool:
    """Initialize an asynchronous Redis connection pool."""
    try:
        pool = AsyncConnectionPool.from_url(url, **kwargs)
        logger.info(f"Asynchronous Redis pool initialized with url={url}")
        return pool
    except Exception as e:
        logger.error(f"Error initializing async pool: {e}")
        raise

# Connection handling context managers
@contextmanager
def _get_sync_connection(connection: Union[redis.Redis, redis.ConnectionPool, None]) -> Generator[redis.Redis, None, None]:
    """Context manager for managing synchronous Redis connections."""
    conn = None
    try:
        if isinstance(connection, redis.Redis):
            yield connection
        elif isinstance(connection, redis.ConnectionPool):
            conn = redis.Redis(connection_pool=connection)
            yield conn
        else:
            raise ValueError("Invalid sync connection object.")
    except redis.ConnectionError as e:
        logger.error(f"Sync connection error: {e}")
        raise
    finally:
        if conn:
            conn.close()

@asynccontextmanager
async def _get_async_connection(connection: Union[AsyncRedis, AsyncConnectionPool, None]) -> AsyncGenerator[AsyncRedis, None]:
    """Context manager for managing asynchronous Redis connections."""
    conn = None
    try:
        if isinstance(connection, AsyncRedis):
            yield connection
        elif isinstance(connection, AsyncConnectionPool):
            conn = AsyncRedis(connection_pool=connection)
            yield conn
        else:
            raise ValueError("Invalid async connection object.")
    except redis.ConnectionError as e:
        logger.error(f"Async connection error: {e}")
        raise
    finally:
        if conn:
            await conn.aclose()

# Redis operations
def _save_to_redis(conn, key: str, data: dict):
    """Save data to Redis."""
    try:
        conn.hset(key, mapping=data)
        logger.info(f"Data stored successfully under key: {key}")
    except Exception as e:
        logger.error(f"Failed to save data to Redis: {e}")
        raise

async def _save_to_redis_async(conn, key: str, data: dict):
    """Asynchronously save data to Redis."""
    try:
        await conn.hset(key, mapping=data)
        logger.info(f"Data stored successfully under key: {key}")
    except Exception as e:
        logger.error(f"Failed to save data to Redis: {e}")
        raise

def _get_redis_data(conn, key: str) -> Optional[dict]:
    """Retrieve data from Redis."""
    try:
        data = conn.hgetall(key)
        if data:
            logger.info(f"Data retrieved successfully for key: {key}")
            return data
        else:
            logger.info(f"No valid data found for key: {key}")
            return None
    except Exception as e:
        logger.error(f"Failed to retrieve data from Redis: {e}")
        raise

async def _get_redis_data_async(conn, key: str) -> Optional[dict]:
    """Asynchronously retrieve data from Redis."""
    try:
        data = await conn.hgetall(key)
        if data:
            logger.info(f"Data retrieved successfully for key: {key}")
            return data
        else:
            logger.info(f"No valid data found for key: {key}")
            return None
    except Exception as e:
        logger.error(f"Failed to retrieve data from Redis: {e}")
        raise

# Main class
class RedisSaver(BaseCheckpointSaver):
    """Redis-based checkpoint saver implementation."""
    sync_connection: Optional[Union[redis.Redis, redis.ConnectionPool]] = None
    async_connection: Optional[Union[AsyncRedis, AsyncConnectionPool]] = None

    def __init__(
        self,
        sync_connection: Optional[Union[redis.Redis, redis.ConnectionPool]] = None,
        async_connection: Optional[Union[AsyncRedis, AsyncConnectionPool]] = None,
    ):
        super().__init__(serde=JsonAndBinarySerializer())
        self.sync_connection = sync_connection
        self.async_connection = async_connection

    def put(
        self,
        config: RunnableConfig,
        checkpoint: Checkpoint,
        metadata: CheckpointMetadata,
    ) -> RunnableConfig:
        """Synchronously store a checkpoint in Redis."""
        thread_id = config["configurable"]["thread_id"]
        parent_ts = config["configurable"].get("thread_ts")
        key = f"checkpoint:{thread_id}:{checkpoint['ts']}"
        data = {
            "checkpoint": self.serde.dumps(checkpoint),
            "metadata": self.serde.dumps(metadata),
            "parent_ts": parent_ts if parent_ts else "",
        }
        with _get_sync_connection(self.sync_connection) as conn:
            _save_to_redis(conn, key, data)
        return {"configurable": {"thread_id": thread_id, "thread_ts": checkpoint["ts"]}}

    async def aput(
        self,
        config: RunnableConfig,
        checkpoint: Checkpoint,
        metadata: CheckpointMetadata,
    ) -> RunnableConfig:
        """Asynchronously store a checkpoint in Redis."""
        thread_id = config["configurable"]["thread_id"]
        parent_ts = config["configurable"].get("thread_ts")
        key = f"checkpoint:{thread_id}:{checkpoint['ts']}"
        data = {
            "checkpoint": self.serde.dumps(checkpoint),
            "metadata": self.serde.dumps(metadata),
            "parent_ts": parent_ts if parent_ts else "",
        }
        async with _get_async_connection(self.async_connection) as conn:
            await _save_to_redis_async(conn, key, data)
        return {"configurable": {"thread_id": thread_id, "thread_ts": checkpoint["ts"]}}

    def put_writes(
        self,
        config: RunnableConfig,
        writes: List[Tuple[str, Any]],
        task_id: str,
    ) -> RunnableConfig:
        """Synchronously save a list of writes to Redis storage."""
        thread_id = config["configurable"]["thread_id"]
        thread_ts = config["configurable"].get("thread_ts") or self._default_ts()
        key = f"writes:{thread_id}:{thread_ts}"
        serialized_writes = [(channel, self.serde.dumps(value)) for channel, value in writes]
        with _get_sync_connection(self.sync_connection) as conn:
            for channel, value in serialized_writes:
                conn.rpush(key, f"{task_id}:{channel}:{value}")
        logger.info(f"Writes stored successfully for thread_id: {thread_id}, ts: {thread_ts}")
        return config

    async def aput_writes(
        self,
        config: RunnableConfig,
        writes: List[Tuple[str, Any]],
        task_id: str,
    ) -> RunnableConfig:
        """Asynchronously save a list of writes to Redis storage."""
        thread_id = config["configurable"]["thread_id"]
        thread_ts = config["configurable"].get("thread_ts") or self._default_ts()
        key = f"writes:{thread_id}:{thread_ts}"
        serialized_writes = [(channel, self.serde.dumps(value)) for channel, value in writes]
        async with _get_async_connection(self.async_connection) as conn:
            for channel, value in serialized_writes:
                await conn.rpush(key, f"{task_id}:{channel}:{value}")
        logger.info(f"Writes stored successfully for thread_id: {thread_id}, ts: {thread_ts}")
        return config

    def get_tuple(self, config: RunnableConfig) -> Optional[CheckpointTuple]:
        """Retrieve a checkpoint tuple from Redis."""
        thread_id = config["configurable"]["thread_id"]
        thread_ts = config["configurable"].get("thread_ts")
        with _get_sync_connection(self.sync_connection) as conn:
            key = self._get_checkpoint_key(conn, thread_id, thread_ts)
            if not key:
                return None
            checkpoint_data = _get_redis_data(conn, key)
            return self._parse_checkpoint_data(checkpoint_data, config, thread_id)

    async def aget_tuple(self, config: RunnableConfig) -> Optional[CheckpointTuple]:
        """Asynchronously retrieve a checkpoint tuple from Redis."""
        thread_id = config["configurable"]["thread_id"]
        thread_ts = config["configurable"].get("thread_ts")
        async with _get_async_connection(self.async_connection) as conn:
            key = await self._aget_checkpoint_key(conn, thread_id, thread_ts)
            if not key:
                return None
            checkpoint_data = await _get_redis_data_async(conn, key)
            return self._parse_checkpoint_data(checkpoint_data, config, thread_id)

    def list(
        self,
        config: Optional[RunnableConfig],
        *,
        filter: Optional[dict[str, Any]] = None,
        before: Optional[RunnableConfig] = None,
        limit: Optional[int] = None,
    ) -> Generator[CheckpointTuple, None, None]:
        """List checkpoints from Redis."""
        thread_id = config["configurable"]["thread_id"] if config else "*"
        pattern = f"checkpoint:{thread_id}:*"
        with _get_sync_connection(self.sync_connection) as conn:
            keys = self._filter_keys(conn, pattern, before, limit)
            for key in keys:
                data = _get_redis_data(conn, key)
                if data and b"checkpoint" in data and b"metadata" in data:
                    yield self._parse_checkpoint_data(data, config, thread_id)

    async def alist(
        self,
        config: Optional[RunnableConfig],
        *,
        filter: Optional[dict[str, Any]] = None,
        before: Optional[RunnableConfig] = None,
        limit: Optional[int] = None,
    ) -> AsyncGenerator[CheckpointTuple, None]:
        """Asynchronously list checkpoints from Redis."""
        thread_id = config["configurable"]["thread_id"] if config else "*"
        pattern = f"checkpoint:{thread_id}:*"
        async with _get_async_connection(self.async_connection) as conn:
            keys = await self._afilter_keys(conn, pattern, before, limit)
            for key in keys:
                data = await _get_redis_data_async(conn, key)
                if data and b"checkpoint" in data and b"metadata" in data:
                    yield self._parse_checkpoint_data(data, config, thread_id)

    # Utility methods
    def _default_ts(self) -> str:
        """Generate a default timezone-aware timestamp."""
        return datetime.now(timezone.utc).isoformat()

    def _get_checkpoint_key(self, conn, thread_id: str, thread_ts: Optional[str]) -> Optional[str]:
        """Determine the Redis key for a checkpoint."""
        if thread_ts:
            return f"checkpoint:{thread_id}:{thread_ts}"
        all_keys = conn.keys(f"checkpoint:{thread_id}:*")
        if not all_keys:
            logger.info(f"No checkpoints found for thread_id: {thread_id}")
            return None
        latest_key = max(all_keys, key=lambda k: ":".join(k.decode().split(":")[2:]))
        return latest_key.decode()

    async def _aget_checkpoint_key(self, conn, thread_id: str, thread_ts: Optional[str]) -> Optional[str]:
        """Asynchronously determine the Redis key for a checkpoint."""
        if thread_ts:
            return f"checkpoint:{thread_id}:{thread_ts}"
        all_keys = await conn.keys(f"checkpoint:{thread_id}:*")
        if not all_keys:
            logger.info(f"No checkpoints found for thread_id: {thread_id}")
            return None
        latest_key = max(all_keys, key=lambda k: ":".join(k.decode().split(":")[2:]))
        return latest_key.decode()

    def _filter_keys(self, conn, pattern: str, before: Optional[RunnableConfig], limit: Optional[int]) -> list:
        """Filter and sort Redis keys based on optional criteria."""
        keys = conn.keys(pattern)
        if before:
            keys = [
                k
                for k in keys
                if ":".join(k.decode().split(":")[2:])
                < before["configurable"]["thread_ts"]
            ]
        keys = sorted(keys, key=lambda k: ":".join(k.decode().split(":")[2:]), reverse=True)
        if limit:
            keys = keys[:limit]
        return keys

    async def _afilter_keys(self, conn, pattern: str, before: Optional[RunnableConfig], limit: Optional[int]) -> list:
        """Asynchronously filter and sort Redis keys based on optional criteria."""
        keys = await conn.keys(pattern)
        if before:
            keys = [
                k
                for k in keys
                if ":".join(k.decode().split(":")[2:])
                < before["configurable"]["thread_ts"]
            ]
        keys = sorted(keys, key=lambda k: ":".join(k.decode().split(":")[2:]), reverse=True)
        if limit:
            keys = keys[:limit]
        return keys

    def _parse_checkpoint_data(self, data: dict, config: RunnableConfig, thread_id: str) -> Optional[CheckpointTuple]:
        """Parse checkpoint data retrieved from Redis."""
        if not data:
            logger.info(f"No valid checkpoint data found.")
            return None
        checkpoint = self.serde.loads(data[b"checkpoint"].decode())
        metadata = self.serde.loads(data[b"metadata"].decode())
        parent_ts = data.get(b"parent_ts", b"").decode()
        parent_config = (
            {"configurable": {"thread_id": thread_id, "thread_ts": parent_ts}}
            if parent_ts
            else None
        )
        logger.info(f"Checkpoint parsed successfully for thread_id: {thread_id}")
        return CheckpointTuple(
            config=config,
            checkpoint=checkpoint,
            metadata=metadata,
            parent_config=parent_config,
        )