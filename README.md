# WellCareBot: Mental Health Chatbot

![Screenshot_20240720-083611](https://github.com/user-attachments/assets/2e5fb439-bd50-42cb-acba-afc6de50cd7c)
![Screenshot_20240720-194852](https://github.com/user-attachments/assets/0a461b55-9dd6-4b55-9bca-56ae2e6f8eec)
![Screenshot_20240720-194903](https://github.com/user-attachments/assets/0023d3e7-dd5d-4997-be54-4be6b2f5e218)
![Screenshot_20240720-173624](https://github.com/user-attachments/assets/04f6c5c3-33ba-4a80-91c7-e29ee184e4ad)
![Screenshot_20240720-203751](https://github.com/user-attachments/assets/94dc3d90-b87d-4011-bc2a-aebd8c1beb7d)

This project implements a mental health chatbot using advanced language models and various tools to provide empathetic, professional, and evidence-based support to users seeking help with their mental health and emotional well-being.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Backend Setup](#backend-setup)
6. [Frontend Setup](#frontend-setup)
7. [Usage](#usage)
8. [Project Structure](#project-structure)
9. [Configuration](#configuration)
10. [API Endpoints](#api-endpoints)
11. [Contributing](#contributing)
12. [License](#license)

## Project Overview

The WellCareBot is designed to act as a virtual psychotherapist, utilizing a combination of cognitive-behavioral therapy (CBT), interpersonal therapy (IPT), psychodynamic therapy, and supportive therapy. It uses advanced language models and specialized tools to provide personalized support and information to users.

## Features

- Empathetic and professional responses to user queries
- Integration of multiple therapeutic approaches
- Use of specialized tools for retrieving mental health information and conducting web searches
- Flask-based API for easy integration into web applications
- Persistence of conversation threads
- Streaming responses for a more dynamic user experience
- Flutter-based mobile application for user interaction

## Prerequisites

### Backend
- Python 3.7+
- OpenAI API key
- Tavily API key
- Pinecone API key
- Groq API key (if using Groq models)

### Frontend
- Flutter SDK
- Android Studio or VS Code with Flutter extension
- A device or emulator to run the application

## Installation

### Backend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/mental-health-chatbot.git
   cd mental-health-chatbot/backend
   ```

2. Install the required packages:
   ```bash
   pip install -r requirements.txt
   ```

3. Set up your environment variables by creating a `.env` file in the `backend` directory:
   ```env
   OPENAI_API_KEY=your_openai_api_key
   TAVILY_API_KEY=your_tavily_api_key
   PINECONE_API_KEY=your_pinecone_api_key
   GROQ_API_KEY=your_groq_api_key
   ```

4. To start the Flask server, run:
   ```bash
   python main.py
   ```

The server will start on `http://localhost:5000` by default.

### Frontend Setup

1. Clone the repository (if not already done):
   ```bash
   git clone https://github.com/katendejericho5/mental-health-chatbot.git
   cd mental-health-chatbot/frontend
   ```

2. Ensure you have the Flutter SDK installed. If not, follow the [official installation guide](https://flutter.dev/docs/get-started/install).

3. Install the required dependencies:
   ```bash
   flutter pub get
   ```



4. Run the application on an emulator or connected device:
   ```bash
   flutter run
   ```

## Usage

### Backend

To start the Flask server:
```bash
python main.py
```
The server will start on `http://localhost:5000` by default.

### Frontend

To run the Flutter application:
```bash
flutter run
```

## Project Structure

### Backend
- `backend/app.py`: Main Flask application
- `backend/graph.py`: Defines the conversation flow graph
- `backend/tools.py`: Implements specialized tools for information retrieval
- `backend/functions.py`: Utility functions for environment setup and message formatting
- `backend/agents.py`: Defines the AI assistant and language model setup
- `backend/retrieval.py`: Handles document retrieval from Pinecone

### Frontend
- `frontend/lib/`: Contains the Flutter application code
- `frontend/lib/screens/`: UI screens of the application
- `frontend/lib/widgets/`: Custom widgets used in the application
- `frontend/lib/services/`: Services for API calls and data handling

## Configuration

### Backend

Ensure you have set up the following in your `.env` file:
- `OPENAI_API_KEY`: Your OpenAI API key
- `TAVILY_API_KEY`: Your Tavily API key for web searches
- `PINECONE_API_KEY`: Your Pinecone API key for vector storage
- `GROQ_API_KEY`: Your Groq API key (if using Groq models)

### Frontend

Ensure you have set up the following in your `.env` file:
- `API_BASE_URL`: Base URL of the backend API (e.g., `http://localhost:5000`)

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
