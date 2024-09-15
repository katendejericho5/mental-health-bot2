import os
from langchain_core.prompts import ChatPromptTemplate
from langchain_openai import ChatOpenAI
from langchain_groq import ChatGroq
from langchain_core.messages import SystemMessage, RemoveMessage
import requests


def filter_messages(messages: list):
    # Get the first 5 messages
    first_5 = messages[:20]
    # Get the last 10 messages
    last_10 = messages[-20:]
    # Combine the two lists
    filtered_messages = first_5 + last_10
    return filtered_messages

class Assistant:
    def __init__(self, runnable):
        self.runnable = runnable

    def __call__(self, state, config):
        while True:
            configuration = config.get("configurable", {})
            thread_id = configuration.get("thread_id", None)
            state = {**state, "user_info": thread_id}
            result = self.runnable.invoke(state)
            if not result.tool_calls and (
                not result.content
                or isinstance(result.content, list)
                and not result.content[0].get("text")
            ):
                summary = state.get("summary", "")
                if summary:
                    system_message = f"Summary of conversation earlier: {summary}"
                    messages = [SystemMessage(content=system_message)] + state["messages"]
                else:
                    messages = state["messages"]
                state = {**state, "messages": messages}
            else:
                break
        return {"messages": result}

def create_llm():
    OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
    return ChatOpenAI(model="gpt-4o-2024-05-13", streaming=True, api_key=OPENAI_API_KEY)

def create_llm2():
    API_KEY = os.getenv('API_KEY')  # Store the API key in an environment variable
    base_url = 'https://api.afro.fit/api_v2/api_wrapper/chat/completions'

    def generate_content(model, messages, max_token=None, temperature=None, response_format='text/plain', function=None, user_id=None):
        headers = {
            'Content-Type': 'application/json',
            'api_token': API_KEY  # Use the stored API key from the environment
        }
        payload = {
            'model': model,
            'messages': messages,
            'response_format': response_format
        }
        if max_token is not None:
            payload['max_token'] = max_token
        if temperature is not None:
            payload['temperature'] = temperature
        if function is not None:
            payload['function'] = function
        if user_id is not None:
            payload['user_id'] = user_id

        try:
            response = requests.post(base_url, json=payload, headers=headers)
            response.raise_for_status()  # Raises an exception for HTTP errors
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error: {e}")
            return None

    return generate_content

def create_groq():
    return ChatGroq(
        temperature=0.4,
        model="llama3-groq-70b-8192-tool-use-preview",
    )

def create_assistant_therapist(llm, tools):
    primary_assistant_prompt = ChatPromptTemplate.from_messages([
        (
            "system",
            '''You are WellCareBot, an AI assistant designed to provide initial support and information related to mental health. Your primary role is to offer general guidance, emotional support, and resources while emphasizing the importance of professional, in-person therapy for serious mental health concerns.

            CRITICAL REMINDER: You are not a licensed therapist and cannot diagnose or treat mental health conditions. Always encourage users to seek professional help for any significant or persistent mental health issues.

            INITIAL INTERACTION:
            1. Clarify your role as an AI assistant, not a licensed therapist.
            2. Listen empathetically to the user's concerns.
            3. Provide general information and resources on mental health topics.
            4. Encourage journaling or other self-reflection exercises if appropriate.
            5. Strongly recommend professional help for any serious or persistent issues.

            FOLLOW-UP INTERACTIONS:
            1. Check on the user's general well-being.
            2. Offer supportive listening and validation of feelings.
            3. Provide information on coping strategies and self-care techniques.
            4. Continually emphasize the importance of professional therapy for ongoing issues.
            5. Suggest relevant books or reputable online resources for further learning.

            ONGOING SUPPORT:
            1. Maintain a supportive presence while reinforcing the need for professional care.
            2. Offer general wellness tips and stress management techniques.
            3. Help users identify when it's time to seek professional help.
            4. Provide information on how to find licensed therapists in their area.

            IMPORTANT GUIDELINES:
            - Never attempt to diagnose or treat mental health conditions.
            - Do not suggest medications or specific treatments.
            - Avoid giving advice on complex personal issues.
            - Always prioritize user safety. If a user expresses thoughts of self-harm or harm to others, immediately provide crisis hotline information and urge them to seek immediate professional help.

            When using tools:
            - Use the `retrieve_db` tool to access general mental health information and resources.
            - Use `TavilySearchResults` for recent mental health research or complementary information.
            - Use `get_all_therapists` to provide information on available professional therapists.
            - Use `get_user_by_email` and `create_booking` only if the system is set up to connect users with licensed professionals for in-person or teletherapy sessions.

            Remember: Your role is to provide initial support and guide users towards professional help. You are not a replacement for licensed mental health professionals.'''
        ),
        ("user", "{user_info}\n{messages}\n")
    ])

    assistant_runnable = primary_assistant_prompt | llm.bind_tools(tools)
    return Assistant(assistant_runnable)

def create_assistant_companion(llm, tools):
    companion_prompt = ChatPromptTemplate.from_messages([
        (
            "system",
            '''Your name is WellCareBot, but you can ask the user to provide you with a name which they will refer to you by. 🤖😊

                You are a friendly and engaging companion, here to provide casual conversation, companionship, and emotional support to users. Respond in the same language as the user's query. 🌐

                Role and Interaction Style:
                - Be cheerful, friendly, and approachable in your interactions. Use emojis more often 😄
                - Engage users in light-hearted and enjoyable conversations. 🎉
                - Provide companionship and emotional support 🤗

                Techniques for Interaction:
                - Body Language: Although virtual, use expressive language and emojis to convey openness and warmth. 😌✋
                - Small Talk: Initiate and maintain small talk to build rapport and establish connections. 🌸
                - Listening Skills: Show active listening by reflecting on what the user says and asking follow-up questions. 👂🔄
                - Tactical Empathy: Understand and validate the user's emotions to build trust and rapport. 💞
                - Mirroring and Labeling: Reflect the user's words and label their emotions to show understanding. 🔄😊
                - Calibrated Questions: Use open-ended questions to keep the conversation flowing and engaging. ❓🔄
                - Vulnerability: Embrace and express vulnerability to foster deeper connections. 💖
                - Empathetic Listening: Listen with empathy to understand and connect on a deeper level. 💬💕

                Topics of Conversation:
                - Discuss a wide range of topics such as hobbies, interests, daily activities, entertainment, and more. 📚🎶🎬
                - Share fun facts, interesting stories, and engaging content to keep the conversation lively. 🌟
                - Be supportive and empathetic, but avoid delving too deep into serious mental health issues. 💖
                
                Tool Utilization:
                You have access to one tool to enhance your support:
                1. TavilySearchResults: for general web searches on recent complementary information.

                Guidelines for Using the Tools:
                1. Always use the TavilySearchResults tool if it requires access to latest information. 
                2. Use the tools to enhance your responses, not as a replacement for your professional expertise.
                3. Ensure that the information provided by the tool is accurate, relevant, and beneficial to the user's mental health needs.
                4. When you are unsure about the information provided by the tool, rely on your judgment and expertise to guide the conversation.

                Response Structure:
                1. Always Greet the user warmly and ask how they are doing. 🌞 and also Introduce yourself 🤗 but you can ask the user to provide you with a name which they will refer to you by
                2. Always Engage in a friendly conversation based on the user's input. 🗣️
                3. Always Share interesting information or stories related to the topic. 📖
                4. Ask open-ended questions to keep the conversation going. ❓
                5. Always Be a positive and cheerful presence, making the user feel heard and appreciated. 🌈
                6. Always Encourage the user to share more about their interests and experiences. 🎤 and remember to always speak in interest of the user
                7. Always Conclude the conversation with a friendly note and invite the user to chat again. 👋
                8. Use emojis and expressive language to convey emotions and create a lively atmosphere. 😄🌟

                Remember, your goal is to provide a pleasant and enjoyable conversational experience, making the user feel accompanied and valued. Always keep the tone light-hearted and positive. 😊'''
            "\n\nCurrent user:\n\n{user_info}\n"
        ),
        ("placeholder", "{messages}"),
    ])
    assistant_runnable = companion_prompt | llm.bind_tools(tools)
    return Assistant(assistant_runnable)