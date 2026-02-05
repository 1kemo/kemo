import 'ai_personality.dart';

enum MessageSender {
  user,
  ai,
}

class ChatMessage {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final PersonalityType? aiPersonality;

  ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.aiPersonality,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender.toString(),
      'timestamp': timestamp.toIso8601String(),
      'aiPersonality': aiPersonality?.toString(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      sender: json['sender'] == 'MessageSender.user' 
          ? MessageSender.user 
          : MessageSender.ai,
      timestamp: DateTime.parse(json['timestamp']),
      aiPersonality: json['aiPersonality'] != null
          ? PersonalityType.values.firstWhere(
              (e) => e.toString() == json['aiPersonality'])
          : null,
    );
  }
}
