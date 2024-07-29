from typing import Annotated, Union
from typing_extensions import TypedDict
from langchain_core.messages import AnyMessage
from langgraph.graph.message import add_messages
from langgraph.graph import END, StateGraph, START
from langgraph.prebuilt import ToolNode
from langgraph.checkpoint.sqlite import SqliteSaver

class State(TypedDict):
    messages: Annotated[list[AnyMessage], add_messages]

# Define the condition function for routing to the tools node
def tools_condition(state: State) -> Union[str, None]:
    messages = state['messages']
    last_message = messages[-1]
    # If the last message includes tool calls, route to the "tools" node
    if last_message.tool_calls:
        return "tools"
    # Otherwise, end the conversation
    return END

def create_graph(assistant, tools):
    builder = StateGraph(State)
    builder.add_node("assistant", assistant)

    # Create a ToolNode for the tools
    tool_node = ToolNode(tools)

    builder.add_node("tools", tool_node)

    builder.add_edge(START, "assistant")
    builder.add_conditional_edges("assistant", tools_condition)
    builder.add_edge("tools", "assistant")
    memory = SqliteSaver.from_conn_string(":memory:")
    return builder.compile(checkpointer=memory)

def create_graph_companion(assistant, tools):
    builder = StateGraph(State)
    builder.add_node("assistant", assistant)

    # Create a ToolNode for the tools
    tool_node = ToolNode(tools)

    builder.add_node("tools", tool_node)

    builder.add_edge(START, "assistant")
    builder.add_conditional_edges("assistant", tools_condition)
    builder.add_edge("tools", "assistant")
    memory = SqliteSaver.from_conn_string(":memory:")
    return builder.compile(checkpointer=memory)
