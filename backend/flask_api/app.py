from flask import Flask
from flask_restful import Api
from flask_cors import CORS  
import os
import sys

# Añadir el directorio principal al path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from dotenv import load_dotenv
os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"
os.environ["OMP_NUM_THREADS"] = "1"

from routes.auth import Register, Login 
from routes.chat import Chat 

app = Flask(__name__)
CORS(app)  
api = Api(app)

api.add_resource(Register, '/register')
api.add_resource(Login, '/login')

# Chatbot endpoint
api.add_resource(Chat, '/chat')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

