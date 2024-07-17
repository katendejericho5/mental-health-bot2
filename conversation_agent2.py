# import os
# from typing import List, Dict, Any
# from langchain.chat_models import ChatOpenAI
# from langchain.prompts import ChatPromptTemplate
# from langgraph.graph import StateGraph, END

# # Set your OpenAI API key here
# os.environ["OPENAI_API_KEY"] = "your-api-key-here"

# class ConversationState:
#     """
#     Represents the state of the conversation.
    
#     Attributes:
#         messages (List[Dict[str, Any]]): A list of message dictionaries, 
#                                          each containing 'role' and 'content'.
#     """
#     def __init__(self):
#         self.messages: List[Dict[str, Any]] = []

# def process_message(state: ConversationState, message: Dict[str, Any]) -> ConversationState:
#     """
#     Adds a new message to the conversation state.
    
#     Args:
#         state (ConversationState): The current state of the conversation.
#         message (Dict[str, Any]): The message to be added.
    
#     Returns:
#         ConversationState: The updated state with the new message added.
#     """
#     state.messages.append(message)
#     return state

# def generate_response(state: ConversationState) -> Dict[str, Any]:
#     """
#     Generates an AI response based on the conversation state.
    
#     Args:
#         state (ConversationState): The current state of the conversation.
    
#     Returns:
#         Dict[str, Any]: A dictionary containing the AI's response.
#     """
#     # Initialize the language model
#     llm = ChatOpenAI(temperature=0.7)
    
#     # Define the conversation prompt template
#     prompt = ChatPromptTemplate.from_messages([
#         ("system", "You are a friendly and empathetic AI assistant designed to provide emotional support "
#                    "and engage in casual conversation. Respond to the user's message in a supportive and engaging manner."),
#         ("human", "{input}"),
#     ])
    
#     # Create a chain of the prompt and language model
#     chain = prompt | llm
    
#     # Generate a response based on the last user message
#     response = chain.invoke({"input": state.messages[-1]["content"]})
#     return {"response": response.content}

# def main_conversation_flow() -> StateGraph:
#     """
#     Defines the main conversation flow using a StateGraph.
    
#     Returns:
#         StateGraph: A compiled state graph representing the conversation flow.
#     """
#     # Initialize the state graph with our ConversationState
#     workflow = StateGraph(ConversationState)

#     # Add nodes to the graph
#     workflow.add_node("process", process_message)  # Node for processing incoming messages
#     workflow.add_node("respond", generate_response)  # Node for generating AI responses

#     # Set the entry point of the graph
#     workflow.set_entry_point("process")

#     # Define the edges of the graph
#     workflow.add_edge("process", "respond")  # After processing, move to response generation
#     workflow.add_edge("respond", "process")  # After responding, return to process for the next message

#     # Set the finish point of the graph
#     workflow.set_finish_point("respond")

#     # Compile the graph
#     return workflow.compile()

# def run_conversation(app: StateGraph, input_message: str, max_turns: int = 5):
#     """
#     Runs an interactive conversation with the AI.
    
#     Args:
#         app (StateGraph): The compiled conversation flow.
#         input_message (str): The initial message to start the conversation.
#         max_turns (int): The maximum number of conversation turns (default is 5).
#     """
#     # Initialize the conversation state with the first user message
#     state = ConversationState()
#     state.messages.append({"role": "user", "content": input_message})
    
#     turn = 0
#     while turn < max_turns:
#         # Process the current state through the app
#         for output in app.stream(state):
#             if "response" in output:
#                 # Print AI's response
#                 print(f"AI: {output['response']}")
                
#                 # Get user input
#                 user_input = input("You: ")
                
#                 # Check if user wants to end the conversation
#                 if user_input.lower() in ['quit', 'exit', 'bye']:
#                     print("AI: Goodbye! Take care.")
#                     return
                
#                 # Add user's message to the conversation state
#                 state.messages.append({"role": "user", "content": user_input})
#                 break
#         turn += 1
    
#     print("AI: We've reached the maximum number of turns. I hope our conversation was helpful!")

# if __name__ == "__main__":
#     # Create the conversation flow
#     app = main_conversation_flow()
    
#     # Start the conversation
#     print("AI: Hello! I'm here to chat and offer support. How are you feeling today?")
#     run_conversation(app, "Hello, I'm feeling a bit down today.")