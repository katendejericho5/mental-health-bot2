import os
from langchain_pinecone import PineconeVectorStore
from langchain_openai import OpenAIEmbeddings


# Set API keys and environment variables
os.environ["OPENAI_API_KEY"] = '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'
os.environ["PINECONE_API_KEY"] = '1a2097d8-79f1-48d8-bbfc-35e12d082eb2'
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


# what is a mentor search the retrieve_db tool  