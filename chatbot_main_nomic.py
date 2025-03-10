


import os
from dotenv import load_dotenv
from langchain.memory import ConversationBufferMemory
from chatbot_utils import load_dataset, create_chunks, create_or_get_vector_store, calculate_retriever, get_conversation_chain  # Importa las funciones desde utils.py
from chatbot_preprompts import system_message_prompt_info  # Importa las definiciones desde prompts.py
import sys


# Desactivar OpenMP para evitar conflictos
os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"
os.environ["OMP_NUM_THREADS"] = "1"


def initMemoria(): 
    memory = ConversationBufferMemory(
        memory_key="history",  # historial de la conversación a corto plazo del chatbot
        input_key="question"
    )
    return memory

def main():
    load_dotenv()  # Carga las variables de entorno (API_KEY)
    dataset = load_dataset("oxford_food_hygiene_cleaned.csv")
    chunks = create_chunks(dataset, 2000, 0)
  
    # Crear o cargar el vector store, calcular retriever, iniciar memoria y definir el prompt por defecto
    vector_store = create_or_get_vector_store(chunks)
    retriever1 = calculate_retriever(vector_store, dataset)
    memory = initMemoria()
    print(memory)
    
    # Iniciar memoria para la conversación
    prompt = system_message_prompt_info  # Prompt por defecto

    
    print("Welcome to the Oxford Travel Assistant! Ask me anything about places to visit, restaurants, and more.")

    while True:
        query = input("\nAsk your question: ")  # Pregunta del usuario
        
        if query.lower() in ["exit", "quit", "bye"]:  # Permitir salir del chatbot
            print("Goodbye! Enjoy your trip to Oxford.")
            sys.exit()

        response = get_conversation_chain(retriever1, query, memory)  
        print("\nChatbot:", response)


if __name__ == "__main__":
    main()