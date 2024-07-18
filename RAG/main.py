from langchain_openai import OpenAIEmbeddings
from rag import INDEX_NAME, PDF_PATH, create_pinecone_index, create_vector_store, initialize_pinecone, load_and_split_document, perform_similarity_search, setup_environment


def main():
    setup_environment()
    
    # Load and split the document
    docs = load_and_split_document(PDF_PATH)
    
    # Initialize embeddings
    embeddings = OpenAIEmbeddings(model="text-embedding-ada-002")
    
    # Initialize Pinecone
    pc = initialize_pinecone()
    
    # Create Pinecone index
    index = create_pinecone_index(pc, INDEX_NAME)
    
    # Create vector store
    docsearch = create_vector_store(docs, embeddings, INDEX_NAME)
    
    # Perform similarity search
    query = "Who is the new mentor"
    result = perform_similarity_search(docsearch, query)
    print(result)

if __name__ == "__main__":
    main()