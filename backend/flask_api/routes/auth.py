from flask import request, jsonify
from flask_restful import Resource
from werkzeug.security import generate_password_hash, check_password_hash

import re
import os

from database.db import create_mysql_connection
from database import create_mysql_connection


def is_valid_email(email):
    return re.match(r"[^@]+@[^@]+\.[^@]+", email)

def is_valid_phone(phone):
    return re.match(r"^\+?\d{7,15}$", phone)

class Register(Resource):
    def post(self):
        data = request.get_json()

        first_name = data.get("first_name")
        last_name = data.get("last_name")
        email = data.get("email")
        phone_number = data.get("phone_number")
        password = data.get("password")

        if not all([first_name, last_name, email, phone_number, password]):
            return {"success": False, "message": "All fields are required"}, 400

        if not is_valid_email(email):
            return {"success": False, "message": "Invalid email format"}, 400

        if not is_valid_phone(phone_number):
            return {"success": False, "message": "Invalid phone number format"}, 400

        if len(password) < 8:
            return {"success": False, "message": "Password must be at least 8 characters"}, 400

        try:
            hashed_password = generate_password_hash(password)
        except Exception as e:
            return {"success": False, "message": f"Password hashing error: {str(e)}"}, 500

        try:
            conn = create_mysql_connection()
            if conn:
                cursor = conn.cursor()

                cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
                if cursor.fetchone():
                    return {"success": False, "message": "Email already exists"}, 400

                insert_query = '''
                INSERT INTO users (first_name, last_name, email, phone_number, password, is_premium)
                VALUES (%s, %s, %s, %s, %s, %s)
                '''
                cursor.execute(insert_query, (first_name, last_name, email, phone_number, hashed_password, False))
                conn.commit()
                return {"success": True, "message": "User registered successfully"}, 201
        except Exception as e:
            return {"success": False, "message": f"Database error: {str(e)}"}, 500
        finally:
            if conn:
                cursor.close()
                conn.close()


def is_valid_email(email):
    return re.match(r"[^@]+@[^@]+\.[^@]+", email)

class Login(Resource):
    def post(self):
        data = request.get_json()

        email = data.get("email")
        password = data.get("password")

        if not all([email, password]):
            return {"success": False, "message": "Email and password are required"}, 400

        if not is_valid_email(email):
            return {"success": False, "message": "Invalid email format"}, 400

        try:
            conn = create_mysql_connection()
            if conn:
                cursor = conn.cursor()
                cursor.execute("SELECT password FROM users WHERE email = %s", (email,))
                result = cursor.fetchone()

                if not result:
                    return {"success": False, "message": "Email does not exist"}, 404

                stored_password = result[0]
                if not check_password_hash(stored_password, password):
                    return {"success": False, "message": "Incorrect password"}, 401

                return {"success": True, "message": "Login successful"}, 200
        except Exception as e:
            return {"success": False, "message": f"Database error: {str(e)}"}, 500
        finally:
            if conn:
                cursor.close()
                conn.close()