import os
import time
from langchain_community.document_loaders import PyPDFLoader
from langchain_openai import OpenAIEmbeddings
from langchain_text_splitters import CharacterTextSplitter
from langchain_pinecone import PineconeVectorStore
from pinecone import Pinecone, ServerlessSpec

# Configuration
OPENAI_API_KEY = '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'
PINECONE_API_KEY = '1a2097d8-79f1-48d8-bbfc-35e12d082eb2'
GROQ_API_KEY = "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"
PDF_PATH = "/home/jericho/Documents/GitHub/deeplearning/projects/drylab.pdf"
INDEX_NAME = "test-index"

def setup_environment():
    os.environ['OPENAI_API_KEY'] = OPENAI_API_KEY
    os.environ["PINECONE_API_KEY"] = PINECONE_API_KEY

# Part 1: Storing documents in Pinecone

def load_and_split_document(file_path):
    loader = PyPDFLoader(file_path)
    return loader.load_and_split(text_splitter=CharacterTextSplitter(chunk_size=1000, chunk_overlap=0))

def initialize_pinecone():
    return Pinecone(api_key=PINECONE_API_KEY)

def create_pinecone_index(pc, index_name):
    existing_indexes = [index_info["name"] for index_info in pc.list_indexes()]
    if index_name not in existing_indexes:
        pc.create_index(
            name=index_name,
            dimension=1536,
            metric="cosine",
            spec=ServerlessSpec(cloud="aws", region="us-east-1"),
        )
        while not pc.describe_index(index_name).status["ready"]:
            time.sleep(1)
    return pc.Index(index_name)

def store_documents_in_pinecone(docs, embeddings, index_name):
    return PineconeVectorStore.from_documents(docs, embeddings, index_name=index_name)

def store_documents():
    setup_environment()
    docs = load_and_split_document(PDF_PATH)
    embeddings = OpenAIEmbeddings(model="text-embedding-ada-002")
    pc = initialize_pinecone()
    index = create_pinecone_index(pc, INDEX_NAME)
    vector_store = store_documents_in_pinecone(docs, embeddings, INDEX_NAME)
    print("Documents stored successfully in Pinecone.")
    return vector_store


def doc_retriever(query, embeddings, index_name):
    vector_store = PineconeVectorStore.from_documents(query, embeddings,index_name=index_name)
    return vector_store.as_retriever()
    




# New function to delete Pinecone index
def delete_pinecone_index(index_name):
    pc = initialize_pinecone()
    pc.delete_index(index_name)
    print(f"Index '{index_name}' has been deleted.")
