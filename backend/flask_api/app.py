from flask import Flask
from flask_restful import Api
# from flask_cors import CORS  # Uncomment if you want to enable CORS
import os
import sys
# Add the parent directory to the path so we can import chatbot_utils etc. in the routes
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from dotenv import load_dotenv
# Disable OpenMP to avoid conflicts
os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"
os.environ["OMP_NUM_THREADS"] = "1"
# Get the path to the .env file in the parent directory, this might need to come before the from imports
dotenv_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env')
load_dotenv(dotenv_path)







from routes.auth import Register, Login 
from routes.chat import Chat 

app = Flask(__name__)
#CORS(app)  # Uncomment if you want to enable CORS
api = Api(app)

api.add_resource(Register, '/register')
api.add_resource(Login, '/login')

# Chatbot endpoint
api.add_resource(Chat, '/chat')


if __name__ == '__main__':
    app.run(debug=True)
