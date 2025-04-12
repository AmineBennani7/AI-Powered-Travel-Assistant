class ChatState {
  static final ChatState instance = ChatState._internal();
  ChatState._internal();

  final List<Map<String, String>> _messages = [
    {
      "sender": "bot",
      "text": "Hi! I am your travel assistant. How can I help you today?",
    }
  ];

  List<Map<String, dynamic>> _recommendations = [];

  List<Map<String, String>> get messages => _messages;
  List<Map<String, dynamic>> get recommendations => _recommendations;

  void addMessage(String sender, String text) {
    _messages.add({"sender": sender, "text": text});
  }

  void setRecommendations(List<Map<String, dynamic>> recs) {
    _recommendations = recs;
  }
}
