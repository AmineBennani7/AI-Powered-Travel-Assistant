import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000'; // IP for Android emulator

  // REGISTER
  Future<Map<String, dynamic>> registerUser(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'User registered successfully.'};
      } else {
        try {
          final responseData = json.decode(response.body);
          if (responseData is Map<String, dynamic>) {
            return {
              'success': false,
              'message': responseData['message'] ?? 'Registration failed.'
            };
          } else {
            return {
              'success': false,
              'message': 'Unexpected response format.'
            };
          }
        } catch (e) {
          return {
            'success': false,
            'message': 'Error decoding response: ${response.reasonPhrase}'
          };
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // LOGIN
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic>) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Login successful.',
            'firstName': responseData['first_name'] ?? 'User',
          };
        } else {
          return {
            'success': true,
            'message': 'Login successful.',
            'firstName': 'User',
          };
        }
      } else {
        try {
          final responseData = json.decode(response.body);
          if (responseData is Map<String, dynamic>) {
            return {
              'success': false,
              'message': responseData['message'] ?? 'Login failed.',
            };
          } else {
            return {
              'success': false,
              'message': 'Login failed. Unexpected response format.'
            };
          }
        } catch (e) {
          return {
            'success': false,
            'message': 'Login failed. Unable to parse response.'
          };
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
