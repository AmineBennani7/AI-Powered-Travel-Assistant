

import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'recommendations.dart';  // Import your other pages
import 'profile.dart';  // Add your actual pages
import 'chatbot.dart';  // Import the chatbot page
// If you have a settings page

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: SplashScreen(),  // Initial screen
      routes: {
        //'/': (context) => SplashScreen(), // Define your splash screen route
        '/recommendations': (context) => RecommendationsPage(),
        '/profile': (context) => ProfilePage(),
        '/chatbot': (context) => ChatbotPage(), // Define chatbot route here
        '/settings': (context) => ProfilePage(),
        // Add any other routes here
      },
    );
  }
}
