from flask import Flask, request, make_response
from flask_restful import Resource, Api
from dotenv import load_dotenv
from langchain.memory import ConversationBufferMemory
from chatbot_main_nomic import load_dynamic_dataset, get_conversation_chain, init_memory, create_vector_store_for_csv
from chatbot_preprompts import system_message_prompt_info
import os

# Cargar variables de entorno
load_dotenv()

app = Flask(__name__)
api = Api(app)

# Inicializar memoria del chatbot (global)
memory = init_memory()

# Clase Chat que hereda de Resource
class Chat(Resource):
    def post(self):
        global memory
        try:
            # Obtener el mensaje del usuario desde la solicitud POST
            data = request.get_json()
            user_question = data.get('message', '')

            # Verificar si el mensaje está vacío
            if not user_question:
                return make_response("Empty message", 400)

            # Cargar el conjunto de datos relevante usando la función ya existente
            df, csv_file = load_dynamic_dataset(user_question)

            # Crear el vector store utilizando el conjunto de datos cargado
            vector_store = create_vector_store_for_csv(df, csv_file)
            retriever = vector_store.as_retriever()

            # Obtener la respuesta del chatbot
            response = get_conversation_chain(retriever, df, user_question, memory, system_message_prompt_info)

            # Convertir la respuesta a texto plano
            if not isinstance(response, str):
                response = str(response)

            # Limpiar caracteres especiales o saltos de línea
            response_str = response.replace('\n', ' ').strip()

            # Verificación de impresión
            print(f"Tipo de respuesta del chatbot: {type(response_str)}")
            print(f"Contenido de la respuesta: {response_str}")

            # Devolver la respuesta directamente como texto plano
            return make_response(response_str, 200)

        except Exception as e:
            print(f"Error: {str(e)}")
            return make_response(f"Error: {str(e)}", 500)

# Registrar el recurso en el API
api.add_resource(Chat, '/chat')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
