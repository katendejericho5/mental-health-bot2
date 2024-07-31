from dotenv import load_dotenv
from flask import Flask, request, jsonify
import uuid
import os
import logging
from flask_cors import CORS
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

# Ensure logging is configured
logging.basicConfig(level=logging.INFO)

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Initialize rate limiter
limiter = Limiter(
    app=app,
    key_func=get_remote_address,
    default_limits=["200 per day", "50 per hour"]
)

# Initialize chatbot components
from graph import create_graph, create_graph_companion
from tools import create_tools
from functions import format_event, setup_environment
from agents import create_assistant_therapist, create_assistant_companion, create_groq, create_llm
from dotenv import load_dotenv
from flask import Flask, request, jsonify
import uuid
import os
import logging
from flask_cors import CORS
from datetime import datetime, timedelta
from collections import defaultdict


setup_environment()
llm = create_groq()
tools = create_tools()
therapist_assistant = create_assistant_therapist(llm, tools)
companion_assistant = create_assistant_companion(llm, tools)
therapist_graph = create_graph(therapist_assistant, tools)
companion_graph = create_graph_companion(companion_assistant, tools)


# Custom rate limit storage
rate_limits = defaultdict(lambda: {'count': 0, 'reset_time': datetime.utcnow()})

# Define rate limits
LIMITS = {
    '/chat/therapist': {'limit': 1, 'period': timedelta(minutes=1)},
    '/chat/companion': {'limit': 30, 'period': timedelta(minutes=1)},
}

def check_rate_limit(path):
    user_address = get_remote_address()
    current_time = datetime.now(datetime.UTC)
    limit_info = LIMITS.get(path)

    if limit_info:
        user_limits = rate_limits[user_address]
        if current_time > user_limits['reset_time']:
            user_limits['count'] = 0
            user_limits['reset_time'] = current_time + limit_info['period']

        if user_limits['count'] < limit_info['limit']:
            user_limits['count'] += 1
            return True
        else:
            return False

    return True



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
    if not check_rate_limit('/chat/therapist'):
        return jsonify({"error": "Rate limit exceeded. Please wait before making more requests."}), 429

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
    if not check_rate_limit('/chat/companion'):
        return jsonify({"error": "Rate limit exceeded. Please wait before making more requests."}), 429

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

@app.route('/renew-rate-limit', methods=['POST'])
def renew_rate_limit():
    try:
        user_address = get_remote_address()
        # Log the address for debugging
        logging.info(f"Renewing rate limits for {user_address}")

        # Manually renew limits
        rate_limits[user_address]['reset_time'] = datetime.now(datetime.UTC)
        return jsonify({"message": "Rate limit successfully renewed"})
    except Exception as e:
        logging.error("Error in /renew-rate-limit endpoint: %s", str(e))
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)