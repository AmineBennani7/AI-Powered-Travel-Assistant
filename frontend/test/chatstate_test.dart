import 'package:flutter_test/flutter_test.dart';
import 'package:example/services/chat_state.dart';

void main() {
  group('ChatState', () {
    test('addMessage adds message to list', () {
      // Arrange
      final chatState = ChatState.instance;
      final initialCount = chatState.messages.length;
      
      // Act
      chatState.addMessage('user', 'Hello, world!');
      
      // Assert
      expect(chatState.messages.length, initialCount + 1);
      expect(chatState.messages.last['sender'], 'user');
      expect(chatState.messages.last['text'], 'Hello, world!');
    });
    
    test('setRecommendations updates recommendations', () {
      // Arrange
      final chatState = ChatState.instance;
      final recommendations = [
        {'name': 'Test Place', 'address': 'Test Address'}
      ];
      
      // Act
      chatState.setRecommendations(recommendations);
      
      // Assert
      expect(chatState.recommendations, recommendations);
    });
  });
}