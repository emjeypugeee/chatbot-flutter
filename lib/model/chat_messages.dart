// models/message.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  // Convert a Message object into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp), // Use Firestore Timestamp
    };
  }

  // Create a Message object from a Firestore DocumentSnapshot
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'] as String,
      isUser: map['isUser'] as bool,
      timestamp: (map['timestamp'] as Timestamp)
          .toDate(), // Convert back to DateTime
    );
  }
}
