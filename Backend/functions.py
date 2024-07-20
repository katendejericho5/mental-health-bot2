import os
from langchain_core.messages import AIMessage, HumanMessage
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def setup_environment():
    os.environ["TAVILY_API_KEY"] = os.getenv("TAVILY_API_KEY")
    # os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")
    os.environ['OPENAI_API_KEY']= os.getenv('OPENAI_API_KEY')
    os.environ["PINECONE_API_KEY"] = os.getenv("PINECONE_API_KEY")
    os.environ["GROQ_API_KEY"] = os.getenv("GROQ_API_KEY")


def format_event(event):
    messages = event.get("messages", [])
    
    # Debug: Print the structure of messages
    print("Debug: Messages structure -", messages)
    
    # Initialize variable to keep track of the latest AI message
    latest_ai_message = None
    
    # Iterate through messages to find the latest AI message
    for message in messages:
        # Debug: Print each message
        print("Debug: Processing message -", message)
        
        # Check if the message is of type AIMessage and has content
        if isinstance(message, AIMessage) and hasattr(message, 'content'):
            latest_ai_message = message  # Update with the latest AI message

    if latest_ai_message:
        # Return the content of the latest AI message
        return {"message": latest_ai_message.content}
    
    return {"message": "No AI message found"}
