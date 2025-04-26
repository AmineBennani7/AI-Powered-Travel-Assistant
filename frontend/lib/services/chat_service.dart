import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_state.dart';

class ChatService {
  final String baseUrl = 'http://10.0.2.2:5000'; // Android Emulator IP
  String? _sessionId;

  Future<void> _initSession() async {
    if (_sessionId != null) return;
    final prefs = await SharedPreferences.getInstance();
    _sessionId = prefs.getString('session_id');

    if (_sessionId == null) {
      _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('session_id', _sessionId!);
    }
  }

  Future<String> sendMessage(String message) async {
    await _initSession();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'session_id': _sessionId,
        }),
      );

      if (response.statusCode == 200) {
        final botResponse = response.body;

        ChatState.instance.addMessage("user", message);
        ChatState.instance.addMessage("bot", botResponse);

        final extracted = _extractRecommendations(botResponse);
        ChatState.instance.setRecommendations(extracted);

        return botResponse;
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error connecting to the server: $e';
    }
  }

  List<Map<String, dynamic>> _extractRecommendations(String text) {
    final List<Map<String, dynamic>> recommendations = [];
    final RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');

    for (final match in boldPattern.allMatches(text)) {
      final name = match.group(1)?.trim();
      if (name == null || name.isEmpty) continue;

      final postNameText = text.substring(match.end);
      final addressMatch = RegExp(r'([A-Z][a-z]+(?: [A-Za-z0-9&]+)*),? (.*?)(?:\s*-|$)')
          .firstMatch(postNameText);

      final address = addressMatch != null
          ? addressMatch.group(0)?.trim()
          : 'Oxford';

      final imageUrl =
          "https://source.unsplash.com/featured/?${Uri.encodeComponent('$name Oxford')}";

      recommendations.add({
        'name': name.replaceAll('*', ''),
        'address': address,
        'imageUrl': imageUrl,
        'price': '£80',
      });
    }

    return recommendations;
  }
}
