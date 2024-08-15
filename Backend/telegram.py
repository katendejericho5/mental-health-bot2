import os
import logging
import requests
from telegram.ext import Application, CommandHandler, InlineQueryHandler
from telegram import InlineQueryResultArticle, InputTextMessageContent

import logging

import requests
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Telegram Bot Token
TOKEN = os.getenv('TELEGRAM_BOT_TOKEN')

FLASK_APP_URL = "http://localhost:5000"

# Enable logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Dictionary to store user modes
user_modes = {}

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Send a message when the command /start is issued."""
    user = update.effective_user
    await update.message.reply_html(
        f"Hi {user.mention_html()}! I'm your Telegram bot. Use /therapist to switch to therapist mode or /companion to switch to companion mode."
    )

async def set_mode(update: Update, context: ContextTypes.DEFAULT_TYPE, mode: str) -> None:
    """Set the mode for the user."""
    user_id = update.effective_user.id
    user_modes[user_id] = mode
    await update.message.reply_text(f"Switched to {mode} mode. You can start chatting now!")

async def therapist(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Switch to therapist mode."""
    await set_mode(update, context, "therapist")

async def companion(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Switch to companion mode."""
    await set_mode(update, context, "companion")

async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Handle the user message."""
    user_id = update.effective_user.id
    mode = user_modes.get(user_id, "companion")  # Default to companion mode if not set
    message = update.message.text

    # Get or create a thread_id for the user
    if 'thread_id' not in context.user_data:
        response = requests.get(f"{FLASK_APP_URL}/thread")
        if response.status_code == 200:
            context.user_data['thread_id'] = response.json()['thread_id']
        else:
            await update.message.reply_text("Sorry, I couldn't create a new conversation thread. Please try again later.")
            return

    # Prepare the request data
    data = {
        "message": message,
        "thread_id": context.user_data['thread_id']
    }

    # Add email for therapist mode (you may need to collect this separately)
    if mode == "therapist":
        # For now, use a placeholder email. In a real application, you'd need to securely collect and store user emails.
        data["email"] = f"{user_id}@example.com"  

    # Send request to the appropriate endpoint
    response = requests.post(f"{FLASK_APP_URL}/chat/{mode}", json=data)

    if response.status_code == 200:
        ai_response = response.json().get('response', "I'm sorry, I couldn't process your request.")
        await update.message.reply_text(ai_response)
    else:
        await update.message.reply_text("I'm sorry, I encountered an error. Please try again later.")

def main() -> None:
    """Start the bot."""
    # Create the Application and pass it your bot's token.
    application = Application.builder().token(TOKEN).build()

    # Add handlers
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("therapist", therapist))
    application.add_handler(CommandHandler("companion", companion))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))

    # Run the bot until the user presses Ctrl-C
    application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == "__main__":
    main()