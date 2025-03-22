import sqlite3
import hashlib
import os

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def login_user(email, password):
    db_path = os.path.join(os.path.dirname(__file__), '../users.db')
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    try:
        cursor.execute('SELECT first_name, last_name, email, password, is_premium FROM users WHERE email = ?', (email,))
        result = cursor.fetchone()

        if result:
            stored_password = result[3]
            if hash_password(password) == stored_password:
                return True, {
                    "first_name": result[0],
                    "last_name": result[1],
                    "email": result[2],
                    "is_premium": bool(result[4])
                }
            else:
                return False, "Incorrect password."
        else:
            return False, "User not found."
    finally:
        conn.close()
