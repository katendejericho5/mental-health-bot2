
from retrival import perform_query, setup_retrieval
from vector_store import store_documents


def main():
    # Store documents
    vector_store = store_documents()

    # Set up retrieval
    qa = setup_retrieval(vector_store)

    # Perform a query
    query = 'mentor'
    result = perform_query(qa, query)
    print(f"Query: {query}")
    print(f"Result: {result}")

if __name__ == "__main__":
    main()