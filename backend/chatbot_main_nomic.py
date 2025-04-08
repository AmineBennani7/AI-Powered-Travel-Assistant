import os
from dotenv import load_dotenv
from langchain.memory import ConversationBufferMemory
from chatbot_utils import load_dataset, create_chunks, create_or_get_vector_store, get_conversation_chain  # Import functions from utils.py
from chatbot_preprompts import system_message_prompt_info  # Import prompt definitions from prompts.py
import sys
import pandas as pd
import re

# Disable OpenMP to avoid conflicts
os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"
os.environ["OMP_NUM_THREADS"] = "1"

def init_memory(): 
    """ Initializes the chatbot's memory to retain conversation history. """
    memory = ConversationBufferMemory(
        memory_key="history",  # Short-term conversation history
        input_key="question"
    )
    return memory

import os

script_dir = os.path.dirname(os.path.abspath(__file__))

data_dir = os.path.join(script_dir, "data")

csv_files = {
    "combined": os.path.join(data_dir, "combined_places.csv"),
    "pubs": os.path.join(data_dir, "pubs.csv"),
    "restaurants": os.path.join(data_dir, "restaurants.csv"),
    "retailers_other": os.path.join(data_dir, "retailers_other.csv"),
}



# Regular expressions to detect the correct category
regex_patterns = {
    # 🔹 Restaurants
    "restaurants": r"\b(restaurant|restaurants|food\s?place|dining\s?(hall|area|spot)?|meal|cuisine|eatery|bistro|brasserie|cafe|cafeteria|grill|steakhouse|diner|fine\s?dining|buffet|sushi\s?bar|ramen\s?shop|pizzeria|pizza\s?place|fast\s?food|vegan\s?restaurant|vegetarian\s?restaurant|seafood\s?restaurant|bbq\s?place|barbecue|tapas\s?bar|sandwich\s?shop|burgers|gourmet\s?food|ethnic\s?food)\b",

    # 🔹 Pubs, Bars, and Nightclubs
    "pubs": r"\b(pub|pubs|bar|bars|nightclub|nightclubs|club|clubs|club\s?(night|scene|event|music|dance|dj|party|venue|rave|electronic|festival|afterparty)|dance\s?club|electronic\s?music|live\s?music|dj\s?set|cocktail\s?bar|wine\s?bar|beer\s?hall|brewery|ale\s?house|sports\s?bar|karaoke\s?bar|rooftop\s?bar|cocktail\s?lounge|gin\s?bar|whiskey\s?bar|speakeasy|after\s?party|late\s?night\s?bar|rave|music\s?club|party\s?club)\b",

    # 🔹 Stores and supermarkets
    "retailers_other": r"\b(retail(er|ers)?|store|stores|shop|shops|market|markets|supermarket|supermarkets|grocery\s?(store|market)?|food\s?supply|corner\s?shop|convenience\s?store|hypermarket|discount\s?store|farmer'?s\s?market|organic\s?market|ethnic\s?grocery|butcher|fishmonger|delicatessen|bakery)\b",

    # 🔹 Hotels and accommodations (removing "club" to avoid confusion)
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

def load_dynamic_dataset(query):
    """
    Loads only the relevant dataset based on the user's query.
    """
    csv_file = detect_csv_from_query(query)
    ##print(f"Loading dataset: {csv_file}")  # Debugging output

    df = pd.read_csv(csv_file)
    return df, csv_file  

def create_vector_store_for_csv(df, dataset_name):
    """
    Creates or loads a vector store for the given dataset.
    """
    file_name = os.path.basename(dataset_name)

    chunks = create_chunks(df, 2000, 0)

    vector_db_path = os.path.join("vectorialDB", file_name)

    vector_store = create_or_get_vector_store(chunks, vector_db_path)
    return vector_store

def main():
    load_dotenv()
    memory = init_memory()

    print("Welcome to the Oxford Travel Assistant! Ask me anything about places to visit, restaurants, and more.")

    vector_store = None
    current_csv = None  

    while True:
        query = input("\nAsk your question: ")  

        if query.lower() in ["exit", "quit", "bye"]:  
            print("Goodbye! Enjoy your trip to Oxford.")
            sys.exit()

        # Detect the dataset based on the user's query
        detected_csv = detect_csv_from_query(query)

        # If no specific keywords are found, use the last dataset for context
        if detected_csv == "data/combined_places.csv" and current_csv is not None:
            detected_csv = current_csv  # Maintain context

        # Load the dataset only if it has changed
        if detected_csv != current_csv:
            ##print(f"Switching dataset from {current_csv} to {detected_csv}")
            df = pd.read_csv(detected_csv)
            vector_store = create_vector_store_for_csv(df, detected_csv)
            current_csv = detected_csv  # Update the current dataset in use

        if vector_store is None:
            print("I'm sorry, I don't have information on that topic.")
            continue

        retriever = vector_store.as_retriever()
        response = get_conversation_chain(retriever, df, query, memory, system_message_prompt_info)

        print("\nChatbot:", response)

if __name__ == "__main__":
    main()
