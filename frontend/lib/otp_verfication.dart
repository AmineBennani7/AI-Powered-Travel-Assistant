import 'package:flutter/material.dart';
import 'next_screen.dart';

class Verification extends StatelessWidget {
  const Verification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color:Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Please check your email to see the verification code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'OTP Code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 70,
                  height: 56,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Color(0xFFF6F6F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
                },
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Resend code',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                /*Text(
                  '01:26',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}

