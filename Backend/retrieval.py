import os
from langchain_pinecone import PineconeVectorStore
from langchain_openai import OpenAIEmbeddings


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
