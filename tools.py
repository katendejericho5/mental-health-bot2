from langchain_community.tools.tavily_search import TavilySearchResults
from langchain.tools import Tool
from retrieval import retrieve_db

def create_tools():
    # Create the retrieve_db tool
    retrieve_db_tool = Tool(
        name="retrieve_db",
        func=retrieve_db,
        description="Search and return information about Mental Health from the database"
    )

    # Create the Tavily search tool
    tavily_search_tool = TavilySearchResults(max_results=5)

    # Combine both tools
    tools = [retrieve_db_tool, tavily_search_tool]
    return tools