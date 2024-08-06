import os
from typing import Annotated, Union
from typing_extensions import TypedDict
from langchain_core.messages import AnyMessage
from langgraph.graph.message import add_messages
from langgraph.graph import END, StateGraph, START
from langgraph.prebuilt import ToolNode
from langgraph.checkpoint.sqlite import SqliteSaver
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI

class State(TypedDict):
    messages: Annotated[list[AnyMessage], add_messages]
    summary: str

def is_conversation_too_long(state: State) -> bool:
    return len(state['messages']) > 30  # Adjusted threshold to 30 messages

def summarize_conversation(state: State) -> State:
    OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
    summarizer = ChatOpenAI(model="gpt-4o-mini", api_key=OPENAI_API_KEY)
    summary_prompt = ChatPromptTemplate.from_messages([
        ("system", 
         """Summarize the following conversation concisely while preserving crucial information about the user. Focus on:
         
        1. Personal Information: Name, age, occupation, family details, etc from the conversation.
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

        Organize the summary in a clear, concise manner. Prioritize information that is most relevant for maintaining a continuous and personalized conversation. Exclude any irrelevant small talk or tangential information."""),
        ("human", "{conversation}")
    ])
    conversation = "\n".join([f"{m.type}: {m.content}" for m in state['messages']])
    summary = summarizer.invoke(summary_prompt.format_messages(conversation=conversation))
    
    # Keep last 15 messages for context 
    retained_messages = state['messages'][-15:]
    
    return {
        "summary": summary.content, 
        "messages": retained_messages
    }

def tools_condition(state: State) -> Union[str, None]:
    messages = state['messages']
    last_message = messages[-1]
    
    if is_conversation_too_long(state):
        return "summarize"
    
    if last_message.tool_calls:
        return "tools"
    
    return END

def create_graph(assistant, tools):
    builder = StateGraph(State)
    builder.add_node("assistant", assistant)

    # Create a ToolNode for the tools
    tool_node = ToolNode(tools)
    builder.add_node("tools", tool_node)
    
    # Add summarization node
    builder.add_node("summarize", summarize_conversation)

    builder.add_edge(START, "assistant")
    builder.add_conditional_edges("assistant", tools_condition)
    builder.add_edge("tools", "assistant")
    builder.add_edge("summarize", "assistant")
    
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