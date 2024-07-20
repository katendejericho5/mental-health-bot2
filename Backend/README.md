# WellCareBot :Mental Health Chatbot

This project implements a mental health chatbot using advanced language models and various tools to provide empathetic, professional, and evidence-based support to users seeking help with their mental health and emotional well-being.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Project Structure](#project-structure)
7. [Configuration](#configuration)
8. [API Endpoints](#api-endpoints)
9. [Contributing](#contributing)
10. [License](#license)

## Project Overview

The Mental Health Chatbot is designed to act as a virtual psychotherapist, utilizing a combination of cognitive-behavioral therapy (CBT), interpersonal therapy (IPT), psychodynamic therapy, and supportive therapy. It uses advanced language models and specialized tools to provide personalized support and information to users.

## Features

- Empathetic and professional responses to user queries
- Integration of multiple therapeutic approaches
- Use of specialized tools for retrieving mental health information and conducting web searches
- Flask-based API for easy integration into web applications
- Persistence of conversation threads
- Streaming responses for a more dynamic user experience

## Prerequisites

- Python 3.7+
- OpenAI API key
- Tavily API key
- Pinecone API key
- Groq API key (if using Groq models)

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/mental-health-chatbot.git
   cd mental-health-chatbot
   ```

2. Install the required packages:
   ```
   pip install -r requirements.txt
   ```

3. Set up your environment variables by creating a `.env` file in the project root:
   ```
   OPENAI_API_KEY=your_openai_api_key
   TAVILY_API_KEY=your_tavily_api_key
   PINECONE_API_KEY=your_pinecone_api_key
   GROQ_API_KEY=your_groq_api_key
   ```

## Usage

To start the Flask server, run:

```
python main.py
```

The server will start on `http://localhost:5000` by default.

## Project Structure

- `app.py`: Main Flask application
- `graph.py`: Defines the conversation flow graph
- `tools.py`: Implements specialized tools for information retrieval
- `functions.py`: Utility functions for environment setup and message formatting
- `agents.py`: Defines the AI assistant and language model setup
- `retrieval.py`: Handles document retrieval from Pinecone

## Configuration

The project uses environment variables for configuration. Ensure you have set up the following in your `.env` file:

- `OPENAI_API_KEY`: Your OpenAI API key
- `TAVILY_API_KEY`: Your Tavily API key for web searches
- `PINECONE_API_KEY`: Your Pinecone API key for vector storage
- `GROQ_API_KEY`: Your Groq API key (if using Groq models)

## API Endpoints

### Create a new thread

- **URL**: `/thread`
- **Method**: `GET`
- **Response**: JSON object with a `thread_id`

### Send a message

- **URL**: `/chat`
- **Method**: `POST`
- **Body**:
  ```json
  {
    "message": "User's message",
    "thread_id": "UUID of the conversation thread"
  }
  ```
- **Response**: JSON object with the AI's response

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
