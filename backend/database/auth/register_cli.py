from register import register_user

def main():
    print("📝 User Registration")

    first_name = input("First name: ").strip()
    last_name = input("Last name: ").strip()
    email = input("Email: ").strip()
    password = input("Password: ").strip()

    success, message = register_user(first_name, last_name, email, password)

    if success:
        print("User created successfully.")
    else:
        print("User creation failed.")
    
    print(message)

if __name__ == "__main__":
    main()
