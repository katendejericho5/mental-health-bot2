# import os
# import time
# from dotenv import load_dotenv
# from langchain_community.document_loaders import PyPDFLoader
# from langchain_openai import OpenAIEmbeddings
# from langchain_text_splitters import CharacterTextSplitter
# from langchain_pinecone import PineconeVectorStore
# import pinecone
# from pinecone import Pinecone, ServerlessSpec


# # Load environment variables from .env file
# load_dotenv()

# # Get API keys from environment variables
# openai_api_key = os.getenv('OPENAI_API_KEY')
# tavily_api_key = os.getenv('TAVILY_API_KEY')
# pinecone_api_key = os.getenv('PINECONE_API_KEY')

# # Function to set up environment variables
# def setup_environment():
#     os.environ['OPENAI_API_KEY'] = openai_api_key
#     os.environ['TAVILY_API_KEY'] = tavily_api_key
#     os.environ['PINECONE_API_KEY'] = pinecone_api_key

# # Initialize environment
# setup_environment()

# # Constants
# PDF_PATH = "/path/to/your/pdf_file.pdf"  # Update with your PDF file path
# INDEX_NAME = "your_index_name"  # Update with your Pinecone index name

# # Function to load and split PDF document
# def load_and_split_document(file_path):
#     loader = PyPDFLoader(file_path)
#     return loader.load_and_split(text_splitter=CharacterTextSplitter(chunk_size=1000, chunk_overlap=0))

# # Function to initialize Pinecone
# def initialize_pinecone():
#     pinecone.init(api_key=pinecone_api_key)
#     return pinecone

# # Function to create Pinecone index
# def create_pinecone_index(pc, index_name):
#     existing_indexes = [index_info["name"] for index_info in pc.list_indexes()]
#     if index_name not in existing_indexes:
#         pc.create_index(
#             name=index_name,
#             dimension=1536,
#             metric="cosine",
#             spec=ServerlessSpec(cloud="aws", region="us-east-1"),
#         )
#         while not pc.describe_index(index_name).status["ready"]:
#             time.sleep(1)
#     return pc.Index(index_name)

# # Function to store documents in Pinecone
# def store_documents_in_pinecone(docs, embeddings, index_name):
#     return PineconeVectorStore.from_documents(docs, embeddings, index_name=index_name)

# # Function to store documents
# def store_documents():
#     setup_environment()
#     docs = load_and_split_document(PDF_PATH)
#     embeddings = OpenAIEmbeddings(model="text-embedding-ada-002")
#     pc = initialize_pinecone()
#     index = create_pinecone_index(pc, INDEX_NAME)
#     vector_store = store_documents_in_pinecone(docs, embeddings, INDEX_NAME)
#     print("Documents stored successfully in Pinecone.")
#     return vector_store

# # Function to retrieve documents from Pinecone
# def doc_retriever(query, embeddings, index_name):
#     vector_store = PineconeVectorStore.from_documents(query, embeddings, index_name=index_name)
#     return vector_store.as_retriever()

# # Function to delete Pinecone index
# def delete_pinecone_index(index_name):
#     pc = initialize_pinecone()
#     pc.delete_index(index_name)
#     print(f"Index '{index_name}' has been deleted.")

# # Example usage:
# if __name__ == "__main__":
#     # Store documents
#     store_documents()
    
#     # Retrieve documents (example query)
#     query = "Example query text"  # Replace with actual query
#     embeddings = OpenAIEmbeddings(model="text-embedding-ada-002")
#     retriever = doc_retriever(query, embeddings, INDEX_NAME)
    
#     # Delete Pinecone index (optional)
#     # delete_pinecone_index(INDEX_NAME)
