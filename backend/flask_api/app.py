from flask import Flask
from flask_restful import Api
# from flask_cors import CORS  # Uncomment if you want to enable CORS
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
