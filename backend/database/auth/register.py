import mysql.connector
import hashlib
import re
from mysql.connector import Error

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def is_valid_email(email):
    return re.match(r"[^@]+@[^@]+\.[^@]+", email)

def is_strong_password(password):
    return (
        len(password) >= 8 and
        re.search(r"[A-Za-z]", password) and
        re.search(r"\d", password) and
        re.search(r"[!@#$%^&*(),.?\":{}|<>]", password)
    )

def is_valid_phone(phone):
    # Simple regex to accept international numbers like +34 123456789
    return re.match(r"^\+?\d{7,15}$", phone)

def register_user(first_name, last_name, email, phone_number, password):
    if not is_valid_email(email):
        return False, "Invalid email format. Please use a valid email like example@mail.com."

    if not is_valid_phone(phone_number):
        return False, "Invalid phone number. Use format like +34123456789 or 612345678."

    if not is_strong_password(password):
        return False, "Password must be at least 8 characters long and include letters, numbers, and special characters."

    try:
        conn = mysql.connector.connect(
            host='localhost',
            user='root',
            password='1234',
            database='users_db'
        )
        cursor = conn.cursor()

        insert_query = '''
        INSERT INTO users (first_name, last_name, email, phone_number, password, is_premium)
        VALUES (%s, %s, %s, %s, %s, %s)
        '''
        cursor.execute(insert_query, (first_name, last_name, email, phone_number, hash_password(password), False))
        conn.commit()

        return True, "User registered successfully."

    except mysql.connector.IntegrityError as e:
        return False, f"Integrity Error: {e}"

    except Error as e:
        return False, f"MySQL Error: {e}"

    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
