from typing import Annotated, Union
from typing_extensions import TypedDict
from langchain_core.messages import AnyMessage
from langgraph.graph.message import add_messages
from langgraph.graph import END, StateGraph, START
from langgraph.prebuilt import ToolNode
from langgraph.checkpoint.memory import MemorySaver  # Try using MemorySaver instead
from langgraph.checkpoint.sqlite import SqliteSaver

class State(TypedDict):
    messages: Annotated[list[AnyMessage], add_messages]

def tools_condition(state: State) -> Union[str, None]:
    messages = state['messages']
    last_message = messages[-1]
    if last_message.tool_calls:
        return "tools"
    return END

def create_graph(assistant, tools):
    builder = StateGraph(State)
    builder.add_node("assistant", assistant)

    tool_node = ToolNode(tools)
    builder.add_node("tools", tool_node)

    builder.add_edge(START, "assistant")
    builder.add_conditional_edges("assistant", tools_condition)
    builder.add_edge("tools", "assistant")
    
    # Using MemorySaver for testing
    memory = MemorySaver()  # Adjust if needed

    return builder.compile(checkpointer=memory)

def create_graph_companion(assistant, tools):
    builder = StateGraph(State)
    builder.add_node("assistant", assistant)

    tool_node = ToolNode(tools)
    builder.add_node("tools", tool_node)

    builder.add_edge(START, "assistant")
    builder.add_conditional_edges("assistant", tools_condition)
    builder.add_edge("tools", "assistant")
    
    # Using MemorySaver for testing
    memory = MemorySaver()  # Adjust if needed

    return builder.compile(checkpointer=memory)
