import mysql.connector
from mysql.connector import Error
import hashlib

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def login_user(email, password):
    try:
        conn = mysql.connector.connect(
            host='localhost',
            user='root',
            password='root123',
            database='users_db'
        )

        cursor = conn.cursor()
        cursor.execute(
            '''SELECT first_name, last_name, email, phone_number, password, is_premium 
               FROM users WHERE email = %s''', 
            (email,)
        )
        result = cursor.fetchone()

        if result:
            stored_password = result[4]
            if hash_password(password) == stored_password:
                return True, {
                    "first_name": result[0],
                    "last_name": result[1],
                    "email": result[2],
                    "phone_number": result[3],
                    "is_premium": bool(result[5])
                }
            else:
                return False, "Incorrect password."
        else:
            return False, "User not found."

    except Error as e:
        return False, f"MySQL Error: {e}"

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()
