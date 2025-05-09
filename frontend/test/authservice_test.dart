import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:example/services/auth_service.dart';

// Create a mock HTTP client
class MockClient extends Mock implements http.Client {}

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      authService = AuthService();
      // Inject the mock client
    });

    test('successful login returns user data', () async {
      // Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"success": true, "message": "Login successful", "firstName": "TestUser"}', 200));

      // Act
      final result = await authService.loginUser('test@example.com', 'password123');

      // Assert
      expect(result['success'], true);
      expect(result['firstName'], 'TestUser');
    });

    test('login with invalid credentials returns error', () async {
      // Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"success": false, "message": "Incorrect password"}', 401));

      // Act
      final result = await authService.loginUser('test@example.com', 'wrongpassword');

      // Assert
      expect(result['success'], false);
      expect(result['message'], contains('Incorrect password'));
    });
  });
}