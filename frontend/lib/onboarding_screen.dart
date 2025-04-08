import 'package:example/sign_in.dart';
import 'package:flutter/material.dart';

class Onboard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            return Column(
              children: [
                // Image with Sharp Top Corners & Rounded Bottom Corners
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,   // Keeps top-left sharp
                    topRight: Radius.zero,  // Keeps top-right sharp
                    bottomLeft: Radius.circular(20), 
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    "assets/images/splash.png",
                    width: screenWidth, 
                    height: screenHeight * 0.6, 
                    fit: BoxFit.cover, // Ensures image fills container width
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Title Text
                SizedBox(
                  width: screenWidth * 0.8,
                  child: Text(
                    'Navigate Oxford Like a Local!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.08,
                      fontFamily: 'Gabriela',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),

                // Subtitle Text
                SizedBox(
                  width: screenWidth * 0.8,
                  child: Text(
                    'Find the best places for food, fun, and essentials all in one app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Get Started Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Container(
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Color(0xFF24BAEC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
