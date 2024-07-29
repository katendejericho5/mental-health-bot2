from dotenv import load_dotenv
from flask import Flask, request, jsonify
import uuid
import os
import logging

from flask_cors import CORS

# Ensure logging is configured


# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Initialize chatbot components
from graph import create_graph, create_graph_companion
from tools import create_tools
from functions import format_event, setup_environment
from agents import create_assistant_therapist, create_assistant_companion, create_groq, create_llm

setup_environment()
llm = create_groq()
tools = create_tools()
therapist_assistant = create_assistant_therapist(llm, tools)
companion_assistant = create_assistant_companion(llm, tools)
therapist_graph = create_graph(therapist_assistant, tools)
companion_graph = create_graph_companion(companion_assistant, tools)

@app.route('/thread', methods=['GET'])
def create_thread():
    try:
        thread_id = str(uuid.uuid4())
        return jsonify({"thread_id": thread_id})
    except Exception as e:
        logging.error("Error in /thread endpoint: %s", str(e))
        return jsonify({"error": str(e)}), 500

@app.route('/chat/therapist', methods=['POST'])
def chat_therapist():
    try:
        data = request.json
        user_input = data.get('message')
        thread_id = data.get('thread_id')

        if not user_input:
            return jsonify({"error": "No message provided"}), 400

        if not thread_id:
            return jsonify({"error": "No thread_id provided"}), 400

        state = {"messages": [("user", user_input)]}
        config = {"configurable": {"thread_id": thread_id}}

        events = therapist_graph.stream({"messages": ("user", user_input)}, config, stream_mode="values")

        response = {"response": None}
        for event in events:
            formatted_message = format_event(event)
            if formatted_message and "message" in formatted_message:
                response["response"] = formatted_message["message"]

        if response["response"] is None:
            return jsonify({"error": "No AI response found"}), 404

        return jsonify(response)
    except Exception as e:
        logging.error("Error in /chat/therapist endpoint: %s", str(e))
        return jsonify({"error": str(e)}), 500

@app.route('/chat/companion', methods=['POST'])
def chat_companion():
    try:
        data = request.json
        user_input = data.get('message')
        thread_id = data.get('thread_id')

        if not user_input:
            return jsonify({"error": "No message provided"}), 400

        if not thread_id:
            return jsonify({"error": "No thread_id provided"}), 400

        state = {"messages": [("user", user_input)]}
        config = {"configurable": {"thread_id": thread_id}}

        events = companion_graph.stream({"messages": ("user", user_input)}, config, stream_mode="values")

        response = {"response": None}
        for event in events:
            formatted_message = format_event(event)
            if formatted_message and "message" in formatted_message:
                response["response"] = formatted_message["message"]

        if response["response"] is None:
            return jsonify({"error": "No AI response found"}), 404

        return jsonify(response)
    except Exception as e:
        logging.error("Error in /chat/companion endpoint: %s", str(e))
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)