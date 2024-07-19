from flask import Flask, request, jsonify
import uuid
from graph import create_graph
from tools import create_tools
from functions import format_event, setup_environment
from agents import create_groq, create_assistant

app = Flask(__name__)

# Initialize chatbot components
setup_environment()
llm = create_groq()
tools = create_tools()
assistant = create_assistant(llm, tools)
graph = create_graph(assistant, tools)

@app.route('/thread', methods=['GET'])
def create_thread():
    """Generate and return a unique thread ID."""
    try:
        # Generate a unique thread ID
        thread_id = str(uuid.uuid4())
        return jsonify({"thread_id": thread_id})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    
@app.route('/chat', methods=['POST'])
def chat():
    """Process user messages and return only the last response from the chatbot."""
    try:
        # Extract user input and thread ID from the request
        data = request.json
        user_input = data.get('message')
        thread_id = data.get('thread_id')
        
        if not user_input:
            return jsonify({"error": "No message provided"}), 400
        
        if not thread_id:
            return jsonify({"error": "No thread_id provided"}), 400

        # Set up the state with the user's message
        state = {
            "messages": [("user", user_input)]
        }

        # Generate the configuration
        config = {
            "configurable": {
                "thread_id": thread_id,
            }
        }

        # Get the response from the chatbot
        events = graph.stream(
            {"messages": ("user", user_input)}, config, stream_mode="values"
        )

        # Initialize response object
        response = {"message": None}
        
        # Iterate through events to find the last AI message
        for event in events:
            formatted_message = format_event(event)
            if formatted_message and "message" in formatted_message:
                response["message"] = formatted_message["message"]

        if response["message"] is None:
            return jsonify({"error": "No AI response found"}), 404
        
        return jsonify(response)
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500
if __name__ == '__main__':
    app.run(debug=True)
