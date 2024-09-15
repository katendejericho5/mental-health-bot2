import os
from typing import Annotated, Union
from langchain_openai import ChatOpenAI
from typing_extensions import TypedDict
from langchain_core.messages import AnyMessage
from langgraph.graph.message import add_messages
from langgraph.graph import END, StateGraph, START
from langgraph.prebuilt import ToolNode
from langgraph.checkpoint.sqlite import SqliteSaver
from langchain_core.messages import HumanMessage
from langchain_core.messages import SystemMessage, RemoveMessage
from langgraph.checkpoint.sqlite import SqliteSaver
from langgraph.graph import MessagesState, StateGraph, START, END
from langgraph.checkpoint.memory import MemorySaver


OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
model = ChatOpenAI(model="gpt-4o-mini", api_key=OPENAI_API_KEY)
class State(MessagesState):
    summary: str

def tools_condition(state: State) -> Union[str, None]:
    messages = state['messages']
    last_message = messages[-1]
    # If the last message includes tool calls, route to the "tools" node
    # todo: change the number of messages to check as needed
    if len(messages) > 30:
        return "summarize_conversation"
    if last_message.tool_calls:
        return "tools"
        # Otherwise, end the conversation
    else:
        return END
    
def summarize_conversation(state: State):
    # First, we summarize the conversation
    summary = state.get("summary", "")
    if summary:
        # If a summary already exists, we use a different system prompt
        # to summarize it than if one didn't
        summary_message = (
            
            f"This is summary of the conversation to date: {summary}\n\n"
            "Extend the summary by taking into account the new messages above:"
        )
    else:
        summary_message = '''
        Create a summary of the following conversation concisely while preserving crucial information about the user. Focus on:
         
        1. Personal Information: Name, age, occupation, family details, etc from the conversation except profile URL.
        2. Mental Health: Any mentioned conditions, symptoms, or concerns mentioned in the conversation.
        3. Therapy History: Past or current treatments, medications, or therapists.
        4. Goals: User's objectives for therapy or personal growth.
        5. Hobbies and Interests: Activities the user enjoys or is passionate about.
        6. Key Life Events: Significant experiences or milestones mentioned.
        7. Emotional State: User's expressed feelings or mood patterns.
        8. Coping Mechanisms: Strategies the user employs to manage stress or emotions.
        9. Social Support: Information about the user's relationships or support system.
        
        10. Cultural or Religious Factors: Any mentioned beliefs or practices that influence the user's perspective.
        11. Strengths and Challenges: User's self-identified strengths or areas of difficulty.
        Organize the summary in a clear, concise manner. Prioritize information that is most relevant for maintaining a continuous and personalized conversation. Exclude any irrelevant small talk or tangential information.'''

    messages = state["messages"] + [HumanMessage(content=summary_message)]
    response = model.invoke(messages)
    # We now need to delete messages that we no longer want to show up
    # I will delete all but the last five messages, but you can change this
    # todo: change the number of messages to delete as needed
    delete_messages = [RemoveMessage(id=m.id) for m in state["messages"][:-5]]
    return {"summary": response.content, "messages": delete_messages}



def create_graph(assistant, tools):
    builder = StateGraph(State)
    builder.add_node("assistant", assistant)

    # Create a ToolNode for the tools
    tool_node = ToolNode(tools)
    builder.add_node("tools", tool_node)
    builder.add_node(summarize_conversation)
    builder.add_edge("summarize_conversation", "assistant")

    builder.add_edge(START, "assistant")
    builder.add_conditional_edges("assistant", tools_condition)
    builder.add_edge("tools", "assistant")
    builder.add_edge("summarize_conversation", "assistant")
    
    memory = SqliteSaver.from_conn_string(":memory:")
    memory = MemorySaver()
    return builder.compile(checkpointer=memory)

def create_graph_companion(assistant, tools):
    builder = StateGraph(State)
    builder.add_node("assistant", assistant)

    # Create a ToolNode for the tools
    tool_node = ToolNode(tools)

    builder.add_node("tools", tool_node)
    builder.add_node(summarize_conversation)
    builder.add_edge("summarize_conversation", "assistant")

    builder.add_edge(START, "assistant")
    builder.add_conditional_edges("assistant", tools_condition)
    builder.add_edge("tools", "assistant")
    memory = SqliteSaver.from_conn_string(":memory:")
    memory = MemorySaver()
    return builder.compile(checkpointer=memory)

