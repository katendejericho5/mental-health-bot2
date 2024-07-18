# tools.py
from langchain_community.tools.tavily_search import TavilySearchResults

def create_tools():
    return [TavilySearchResults(max_results=5)]