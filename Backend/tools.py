import os
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain.tools import Tool
from retrieval import retrieve_db

def create_tools(tavily_api_key=None):
    # If tavily_api_key is not provided, try to get it from environment variable
    if tavily_api_key is None:
        tavily_api_key = os.getenv('TAVILY_API_KEY')
    
    if not tavily_api_key:
        raise ValueError("Tavily API key not found. Please provide it as an argument or set the TAVILY_API_KEY environment variable.")

    # Create the retrieve_db tool
    retrieve_db_tool = Tool(
        name="retrieve_db",
        func=retrieve_db,
        description="Search and return information about Mental Health from the database"
    )

    # Create the Tavily search tool with the API key
    tavily_search_tool = TavilySearchResults(max_results=5, api_key=tavily_api_key)

    # Combine both tools
    tools = [retrieve_db_tool, tavily_search_tool]
    return tools