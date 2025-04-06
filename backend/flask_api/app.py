from flask import Flask
from flask_restful import Api
# from flask_cors import CORS  # Uncomment if you want to enable CORS
from routes.auth import Register, Login 
from routes.chat import Chat 
from dotenv import load_dotenv
import os

# Get the path to the .env file in the parent directory
dotenv_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env')
load_dotenv(dotenv_path)

app = Flask(__name__)
#CORS(app)  # Uncomment if you want to enable CORS
api = Api(app)

api.add_resource(Register, '/register')
api.add_resource(Login, '/login')

# Chatbot endpoint
api.add_resource(Chat, '/chat')


if __name__ == '__main__':
    app.run(debug=True)
