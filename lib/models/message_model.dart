import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
