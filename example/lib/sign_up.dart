import 'package:example/sign_in.dart';
import 'package:flutter/material.dart';
import 'next_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(body: SignUp()),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _onSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NextScreen()), //navigation to next screen
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.07),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: screenWidth * 0.07),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Image.asset(
                'assets/images/logo.png',
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'Sign up now',
                style: TextStyle(
                  color: Color(0xFF1B1E28),
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Please fill the details and create account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7C838D),
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              _buildTextField(_firstNameController, 'Enter First Name'),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(_lastNameController, 'Enter Last Name'),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(_emailController, 'Enter Email'),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(_phoneController, 'Enter Phone Number'),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                _passwordController,
                'Enter Password',
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.02),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password must be 8 characters',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                _confirmPasswordController,
                'Confirm Password',
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.05),
              GestureDetector(
                onTap: _onSignUp,
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.07,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF24BAEC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Color(0xFF707B81),
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Color(0xFFFF7029),
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),

              // Social Media Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.facebook, Colors.blue),
                  _buildSocialIcon(Icons.mail, Colors.red),
                  SizedBox(
                    width: screenWidth * 0.1, // 10% of screen width
                    height: screenWidth * 0.1, // Maintain aspect ratio
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/twitter.png',
                        fit: BoxFit.contain, // Ensures proper scaling
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    bool obscureText = false,
  }) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(icon: Icon(icon, color: color), onPressed: () {}),
    );
  }
}

