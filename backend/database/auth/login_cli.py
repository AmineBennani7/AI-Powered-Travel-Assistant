from login import login_user

def main():
    print("User Login")

    email = input("Email: ").strip()
    password = input("Password: ").strip()

    success, info = login_user(email, password)

    if success:
        print("Login successful!")
        print(f"Welcome {info['first_name']} {info['last_name']}")
    else:
        print("Login failed.")
        print(info)

if __name__ == "__main__":
    main()
