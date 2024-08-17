import os
from dotenv import load_dotenv
from langchain_pinecone import PineconeVectorStore
from langchain_openai import OpenAIEmbeddings
from langchain_core.tools import tool


# Load the .env file
load_dotenv()

# Set API keys and environment variables
os.environ["OPENAI_API_KEY"] =  os.getenv('OPENAI_API_KEY')
os.environ["PINECONE_API_KEY"] = os.getenv("PINECONE_API_KEY")
os.environ["PINECONE_ENVIRONMENT"] = 'gcp-starter'

INDEX_NAME = "test-index"


embeddings = OpenAIEmbeddings()

vectorstore = PineconeVectorStore(index_name=INDEX_NAME, embedding=embeddings)



def query_similar_texts(text, count=5):
    try:
        query_results =vectorstore.similarity_search(
                query=text,
                k=4
                )
        return query_results
    except Exception as e:
        print(f"Error querying similar texts: {e}")
        return None

def retrieve_db(text, count=5):

    similar_texts = query_similar_texts(text, count)
    return similar_texts

@tool
def retrieve_db_tool(message)->list:
    """
    Search and return list of information about Mental Health from the database
    Args:
        message: The message  containing the text to search for in the database.    
    Returns:
        A list of  the details all results from the database.
    """
    
    return retrieve_db(message)
