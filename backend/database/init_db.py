import mysql.connector
from mysql.connector import Error

#FIRST, in the console mysql: CREATE DATABASE users_db;

def create_database_if_not_exists():
    try:
        conn = mysql.connector.connect(
            host='localhost',
            user='root',
            password='1234'
        )
        cursor = conn.cursor()
        cursor.execute("CREATE DATABASE IF NOT EXISTS users_db")
        print("Database 'users_db' created or already exists.")
        cursor.close()
        conn.close()
    except Error as e:
        print(f"Error creating database: {e}")


def create_mysql_connection():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='1234',   
            database='users_db'         
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

def create_users_table():
    conn = create_mysql_connection()
    if conn is None:
        return

    cursor = conn.cursor()

    create_table_query = '''
    CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        is_premium BOOLEAN NOT NULL DEFAULT FALSE
    );
    '''

    try:
        cursor.execute(create_table_query)
        conn.commit()
        print("MySQL table 'users' created or already exists.")
    except Error as e:
        print(f"Error creating table: {e}")
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    create_database_if_not_exists()
    create_users_table()
