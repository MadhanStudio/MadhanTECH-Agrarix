import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/user_model.dart';
import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../../services/comment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentScreen extends StatefulWidget {
  final PostModel post;
  final UserModel user;

  const CommentScreen({super.key, required this.post, required this.user});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();
  final _commentService = CommentService();
  List<CommentModel> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final data = await _commentService.getCommentsByPost(widget.post.id);
    setState(() {
      _comments = data;
    });
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    final comment = CommentModel(
      id: const Uuid().v4(),
      postId: widget.post.id,
      userId: widget.user.uid,
      username: widget.user.name,
      text: _commentController.text.trim(),
      timestamp: DateTime.now(),
    );

    await _commentService.addComment(comment);
    _commentController.clear();
    _loadComments();
  }

  Widget _buildUserProfile(String userId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("users").doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircleAvatar(child: CircularProgressIndicator());
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        final imagePath = userData?["imagePath"];

        ImageProvider? profileImageProvider;
        if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
          profileImageProvider = FileImage(File(imagePath));
        }

        return CircleAvatar(
          backgroundColor: Colors.grey[300],
          backgroundImage: profileImageProvider,
          child: profileImageProvider == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Komentar")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final c = _comments[index];
                return ListTile(
                  leading: _buildUserProfile(c.userId),  // Menampilkan profil pengguna
                  title: Text(c.username),
                  subtitle: Text(c.text),
                  trailing: Text(
                    '${c.timestamp.hour}:${c.timestamp.minute}',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Tulis komentar...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
