import 'package:example/otp_verfication.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              IconButton(
                icon: Icon(Icons.arrow_back, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // logo path
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.3,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  'Enter your email to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                   fillColor: Color(0xFFF6F6F8),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.05),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.08,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF24BAEC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  Verification(), // Replace with your next screen widget
                        ),
                      );
                    },
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
