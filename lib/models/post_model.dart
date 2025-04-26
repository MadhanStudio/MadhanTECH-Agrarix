import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String content;
  final String? imagePath;
  final List<String> likes;
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    this.imagePath,
    required this.likes,
    required this.timestamp,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      id: id,
      userId: map['userId'],
      username: map['username'],
      content: map['content'],
      imagePath: map['imagePath'],
      likes: List<String>.from(map['likes'] ?? []),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'content': content,
      'imagePath': imagePath,
      'likes': likes,
      'timestamp': timestamp,
    };
  }

  PostModel copyWith({
    String? userId,
    String? username,
    String? content,
    String? imagePath,
    List<String>? likes,
    DateTime? timestamp,
  }) {
    return PostModel(
      id: id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      likes: likes ?? this.likes,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
