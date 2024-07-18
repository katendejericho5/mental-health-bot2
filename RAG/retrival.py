
# Part 2: Retrieval using language model

from langchain_groq import ChatGroq

from vector_store import GROQ_API_KEY

from langchain.chains import RetrievalQA

def setup_retrieval(vector_store):
    llm = ChatGroq(
        temperature=0.4,
        model="llama3-70b-8192",
        api_key=GROQ_API_KEY,
    )
    qa = RetrievalQA.from_chain_type(
        llm=llm,
        chain_type="stuff",
        retriever=vector_store.as_retriever()
    )
    return qa

def perform_query(qa, query):
    return qa(query)
