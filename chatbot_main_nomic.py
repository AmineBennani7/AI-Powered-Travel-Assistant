import os
from dotenv import load_dotenv
from langchain.memory import ConversationBufferMemory
from chatbot_utils import load_dataset, create_chunks, create_or_get_vector_store, calculate_retriever, get_conversation_chain  # Import functions from utils.py
from chatbot_preprompts import system_message_prompt_info  # Import prompt definitions from prompts.py
import sys

# Disable OpenMP to avoid conflicts
os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"
os.environ["OMP_NUM_THREADS"] = "1"

def init_memory(): 
    memory = ConversationBufferMemory(
        memory_key="history",  # Short-term conversation history for the chatbot
        input_key="question"
    )
    return memory

def main():
    load_dotenv()  # Load environment variables (API_KEY)
    dataset = load_dataset("data/restaurants.csv")
    chunks = create_chunks(dataset, 2000, 0)
  
    # Create or load the vector store, compute retriever, initialize memory, and set the default prompt
    vector_store = create_or_get_vector_store(chunks)
    retriever1 = calculate_retriever(vector_store, dataset)
    memory = init_memory()
    print(memory)
    
    # Initialize memory for the conversation
    prompt = system_message_prompt_info  # Default prompt

    print("Welcome to the Oxford Travel Assistant! Ask me anything about places to visit, restaurants, and more.")

    while True:
        query = input("\nAsk your question: ")  # User's input question
        
        if query.lower() in ["exit", "quit", "bye"]:  # Allow the user to exit the chatbot
            print("Goodbye! Enjoy your trip to Oxford.")
            sys.exit()

        response = get_conversation_chain(retriever1, query, memory, prompt)
        print("\nChatbot:", response)

if __name__ == "__main__":
    main()
