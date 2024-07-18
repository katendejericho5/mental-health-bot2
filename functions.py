import os

def setup_environment():
    os.environ["TAVILY_API_KEY"] = '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'
    os.environ["OPENAI_API_KEY"] = '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'
    os.environ["PINECONE_API_KEY"] = '1a2097d8-79f1-48d8-bbfc-35e12d082eb2'


def _print_event(event: dict, _printed: set, max_length=1500):
    current_state = event.get("dialog_state")
    if current_state:
        print("Currently in: ", current_state[-1])
    message = event.get("messages")
    if message:
        if isinstance(message, list):
            message = message[-1]
        if message.id not in _printed:
            msg_repr = message.pretty_repr(html=True)
            if len(msg_repr) > max_length:
                msg_repr = msg_repr[:max_length] + " ... (truncated)"
            print(msg_repr)
            _printed.add(message.id)