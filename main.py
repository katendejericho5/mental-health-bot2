# main.py
import uuid
from graph import create_graph
from tools import create_tools
from functions import setup_environment, _print_event
from conversation_agent import create_llm, create_assistant,create_groq

def main():
    setup_environment()
    
    # llm = create_llm()
    llm = create_groq()
    tools = create_tools()
    assistant = create_assistant(llm, tools)
    graph = create_graph(assistant, tools)

    thread_id = str(uuid.uuid4())
    config = {
        "configurable": {
            "thread_id": thread_id,
        }
    }

    _printed = set()
    print("Welcome to the Mental Health Assistant. Type 'quit' to exit.")
    
    while True:
        user_input = input("\nYou: ")
        if user_input.lower() == 'quit':
            print("Thank you for using the Mental Health Assistant. Take care!")
            break
        
        events = graph.stream(
            {"messages": ("user", user_input)}, config, stream_mode="values"
        )
        
        print("\nAssistant:", end=" ")
        for event in events:
            _print_event(event, _printed)
        print()

if __name__ == "__main__":
    main()