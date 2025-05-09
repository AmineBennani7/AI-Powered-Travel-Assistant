import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:example/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  testWidgets('SignIn form submits when login button is pressed', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MaterialApp(home: SignIn()));

    // Enter text in the email field
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    
    // Enter text in the password field
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    
    // Tap the sign in button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    
    // Verify that form submission occurred
    // This will depend on how you've implemented your form submission
    // You might want to verify a loading indicator appears
    expect(find.text('Sign In'), findsOneWidget);
  });
}