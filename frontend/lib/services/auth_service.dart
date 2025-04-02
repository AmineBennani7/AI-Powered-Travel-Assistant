import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000'; // IP local for android emulaor

  Future<Map<String, dynamic>> registerUser(
      String firstName, String lastName, String email, String phoneNumber, String password) async {
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
          final Map<String, dynamic> responseData = json.decode(response.body);
          return {'success': false, 'message': responseData['message'] ?? 'Registration failed.'};
        } catch (e) {
          return {'success': false, 'message': 'Error: ${response.reasonPhrase}'};
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }


   // LOGIN
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {'success': true, 'message': responseData['message']};
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {'success': false, 'message': responseData['message'] ?? 'Login failed.'};
    }
  }
}



