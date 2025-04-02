from flask import Flask
from flask_restful import Api
from routes.auth import Register  

app = Flask(__name__)
api = Api(app)

api.add_resource(Register, '/register')

if __name__ == '__main__':
    app.run(debug=True)
