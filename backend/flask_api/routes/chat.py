from flask_restful import Resource, reqparse
from langchain.memory import ConversationBufferMemory
import pandas as pd
import re
from chatbot_utils import load_dataset, create_chunks, create_or_get_vector_store, get_conversation_chain
from chatbot_preprompts import system_message_prompt_info

# Dictionary to store session memories
memories = {}

# Dictionary to cache vector stores
vector_stores = {}

# Mapping of categories to their respective CSV files
csv_files = {
    "combined": "backend/data/combined_places.csv",
    "pubs": "backend/data/pubs.csv",
    "restaurants": "backend/data/restaurants.csv",
    "retailers_other": "backend/data/retailers_other.csv",
}

# Regular expressions to detect the correct category
regex_patterns = {
    "restaurants": r"\b(restaurant|restaurants|food\s?place|dining\s?(hall|area|spot)?|meal|cuisine|eatery|bistro|brasserie|cafe|cafeteria|grill|steakhouse|diner|fine\s?dining|buffet|sushi\s?bar|ramen\s?shop|pizzeria|pizza\s?place|fast\s?food|vegan\s?restaurant|vegetarian\s?restaurant|seafood\s?restaurant|bbq\s?place|barbecue|tapas\s?bar|sandwich\s?shop|burgers|gourmet\s?food|ethnic\s?food)\b",
    "pubs": r"\b(pub|pubs|bar|bars|nightclub|nightclubs|club|clubs|club\s?(night|scene|event|music|dance|dj|party|venue|rave|electronic|festival|afterparty)|dance\s?club|electronic\s?music|live\s?music|dj\s?set|cocktail\s?bar|wine\s?bar|beer\s?hall|brewery|ale\s?house|sports\s?bar|karaoke\s?bar|rooftop\s?bar|cocktail\s?lounge|gin\s?bar|whiskey\s?bar|speakeasy|after\s?party|late\s?night\s?bar|rave|music\s?club|party\s?club)\b",
    "retailers_other": r"\b(retail(er|ers)?|store|stores|shop|shops|market|markets|supermarket|supermarkets|grocery\s?(store|market)?|food\s?supply|corner\s?shop|convenience\s?store|hypermarket|discount\s?store|farmer'?s\s?market|organic\s?market|ethnic\s?grocery|butcher|fishmonger|delicatessen|bakery)\b",
    "combined": r"\b(hotel|hotels|accommodation|stay|lodging|hostel|motel|bed\s?&\s?breakfast|bnb|guest\s?house|inn|resort|villa|suite|spa\s?hotel|business\s?hotel|luxury\s?hotel|budget\s?hotel|capsule\s?hotel|boutique\s?hotel|aparthotel|all-inclusive\s?hotel|mobile\s?caterer|takeaway|fast\s?food|food\s?delivery|room\s?service|self-catering\s?accommodation)\b"
}

def detect_csv_from_query(query):
    """
    Detects the relevant CSV file based on the user's query.
    If no specific category is found, the default dataset is `combined_places.csv`.
    """
    query = query.lower()

    for category, pattern in regex_patterns.items():
        if re.search(pattern, query):
            return csv_files[category]

    return csv_files["combined"]

class Chat(Resource):
    def __init__(self):
        self.parser = reqparse.RequestParser()
        self.parser.add_argument('message', type=str, required=True, help='Message cannot be blank')
        self.parser.add_argument('session_id', type=str, required=False, default='default')
        
    def post(self):
        args = self.parser.parse_args()
        message = args['message']
        session_id = args['session_id']
        
        # Initialize memory for this session if it doesn't exist
        if session_id not in memories:
            memories[session_id] = ConversationBufferMemory(
                memory_key="history", 
                input_key="question"
            )
        
        # Detect relevant dataset based on query
        detected_csv = detect_csv_from_query(message)
        
        # Create or get vector store
        if detected_csv not in vector_stores:
            df = pd.read_csv(detected_csv)
            chunks = create_chunks(df, 2000, 0)
            vector_stores[detected_csv] = create_or_get_vector_store(chunks, detected_csv)
        
        # Get retriever and process the query
        retriever = vector_stores[detected_csv].as_retriever()
        df = pd.read_csv(detected_csv)
        
        # Get response from the conversation chain
        response = get_conversation_chain(
            retriever, 
            df, 
            message, 
            memories[session_id], 
            system_message_prompt_info
        )
        
        return {
            'message': response,
            'session_id': session_id
        }, 200