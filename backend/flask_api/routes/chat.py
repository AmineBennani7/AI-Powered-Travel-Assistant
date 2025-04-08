from flask import Flask, request, make_response
from flask_restful import Resource, Api
from dotenv import load_dotenv
from langchain.memory import ConversationBufferMemory
from chatbot_main_nomic import load_dynamic_dataset, get_conversation_chain, init_memory, create_vector_store_for_csv
from chatbot_preprompts import system_message_prompt_info
import os
import re


load_dotenv()

app = Flask(__name__)
api = Api(app)

memory = init_memory()

def format_to_markdown(text):
    lines = text.split("  ")  
    formatted = ""
    for line in lines:
        line = line.strip()
        match = re.match(r"^(\d+\.)\s([^:]+):", line)
        if match:
            number = match.group(1)
            title = match.group(2).strip()
            rest = line.split(":", 1)[1].strip()
            formatted += f"{number} **{title}**: {rest}\n\n"
        else:
            formatted += f"{line}\n\n"
    return formatted.strip()


class Chat(Resource):
    def post(self):
        global memory
        try:
            data = request.get_json()
            user_question = data.get('message', '')

            if not user_question:
                return make_response("Empty message", 400)

            df, csv_file = load_dynamic_dataset(user_question)

            vector_store = create_vector_store_for_csv(df, csv_file)
            retriever = vector_store.as_retriever()

            response = get_conversation_chain(retriever, df, user_question, memory, system_message_prompt_info)

            if not isinstance(response, str):
                response = str(response)

            response_str = format_to_markdown(response)

            print(f"Type of response of the chatbot: {type(response_str)}")
            print(f"Message content: {response_str}")

            return make_response(response_str, 200)

        except Exception as e:
            print(f"Error: {str(e)}")
            return make_response(f"Error: {str(e)}", 500)

api.add_resource(Chat, '/chat')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
