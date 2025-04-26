class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String text;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'username': username,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
  };

  static CommentModel fromMap(Map<String, dynamic> map) => CommentModel(
    id: map['id'],
    postId: map['postId'],
    userId: map['userId'],
    username: map['username'],
    text: map['text'],
    timestamp: DateTime.parse(map['timestamp']),
  );
}
