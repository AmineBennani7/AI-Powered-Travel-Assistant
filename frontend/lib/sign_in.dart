import 'package:example/forgot_password.dart';
import 'package:example/sign_up.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SignInForm(),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onSignIn() async {
    final response = await _authService.loginUser(
      _emailController.text,
      _passwordController.text,
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message']), backgroundColor: Colors.green),
      );
      Navigator.pushNamed(
        context,
        '/recommendations',
        arguments: {
          'firstName': response['firstName'],
        },
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.05),
        IconButton(
          icon: Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: screenWidth * 0.3,
            height: screenWidth * 0.3,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF6F6F8),
            hintText: 'Enter your email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: screenHeight * 0.02),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF6F6F8),
            hintText: 'Enter your password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: screenHeight * 0.02),
        Center(
          child: Text(
            'Password must be 8 characters',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF24BAEC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _onSignIn,
            child: Text(
              'Sign In',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPassword()),
              );
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New User?',
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
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      ' Sign up',
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

      ],
    );
  }
}
