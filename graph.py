# graph.py
from typing import Annotated
from typing_extensions import TypedDict
from langchain_core.messages import AnyMessage
from langgraph.graph.message import add_messages
from langgraph.graph import END, StateGraph, START
from langgraph.prebuilt import tools_condition, ToolExecutor
from langgraph.checkpoint.sqlite import SqliteSaver

class State(TypedDict):
    messages: Annotated[list[AnyMessage], add_messages]

def create_graph(assistant, tools):
    builder = StateGraph(State)
    builder.add_node("assistant", assistant)
    
    # Create a ToolExecutor for the tools
    tool_executor = ToolExecutor(tools)
    builder.add_node("tools", tool_executor)
    
    builder.add_edge(START, "assistant")
    builder.add_conditional_edges("assistant", tools_condition)
    builder.add_edge("tools", "assistant")
    memory = SqliteSaver.from_conn_string(":memory:")
    return builder.compile(checkpointer=memory)