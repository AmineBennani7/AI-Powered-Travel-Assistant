from login import login_user

def main():
    print("User Login")

    email = input("Email: ").strip()
    password = input("Password: ").strip()

    success, message = login_user(email, password)
    print("User logged in successfully." if success else "User login failed", message)

if __name__ == "__main__":
    main()
