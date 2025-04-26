import 'package:example/calendar.dart';
import 'package:example/premium.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'recommendations.dart';
import 'profile.dart';
import 'chatbot.dart';
import 'sign_in.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: SplashScreen(), // this makes screen show
      routes: { // Pages routing, very important, without this the menu doesn't work
        '/sign_in': (context) => SignIn(),
        '/recommendations': (context) => const RecommendationsPage(),
        '/profile': (context) => const ProfilePage(),
        '/chatbot': (context) => const ChatbotPage(),
        '/calendar': (context) => const CalendarPage(), 
        '/premium' : (context) => const PremiumPage(),
      },
    );
  }
}
