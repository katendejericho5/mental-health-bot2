import os
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain.tools import Tool
from booking import  create_booking_tool, get_all_therapists, get_all_therapists_tool, get_therapist_by_name, get_user_by_email_tool, is_slot_available
from retrieval import retrieve_db, retrieve_db_tool
from langchain_core.messages import HumanMessage, ToolMessage


def create_tools(tavily_api_key=None):
    # If tavily_api_key is not provided, try to get it from environment variable
    if tavily_api_key is None:
        tavily_api_key = os.getenv('TAVILY_API_KEY')
    
    if not tavily_api_key:
        raise ValueError("Tavily API key not found. Please provide it as an argument or set the TAVILY_API_KEY environment variable.")

    # Create the retrieve_db tool
    # retrieve_db_tool = Tool(
    #     name="retrieve_db",
    #     func=retrieve_db,
    #     description="Search and return information about Mental Health from the database"
    # )
    
    # get_all_therapists_tool = Tool(
    #     name="get_all_therapists",
    #     func=get_all_therapists,
    #     description="Get a list of all therapists"
    # )  
    # get_therapist_by_name_tool = Tool(
    #     name="get_therapist_by_name",
    #     func=get_therapist_by_name,
    #     description="Get the therapist details"
    # )
    # get_user_by_email_tool = Tool(
    #     name="get_user_by_email",
    #     func=get_user_by_email,
    #     description="Get the user details using the email provided" 
    # )
    # is_slot_available_tool = Tool(
    #     name="is_slot_available",
    #     func=is_slot_available,
    #     description="Check if the slot is available"
    # )





    # Create the Tavily search tool with the API key
    tavily_search_tool = TavilySearchResults(max_results=5, api_key=tavily_api_key)

    # Combine both tools
    tools = [retrieve_db_tool, tavily_search_tool,get_all_therapists_tool,get_user_by_email_tool,create_booking_tool]
    return tools