import 'package:flutter/material.dart';
import '../../models/post_model.dart';

class PostDetailScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Postingan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(post.content),
            if (post.imagePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Image.asset(post.imagePath!),
              ),
          ],
        ),
      ),
    );
  }
}
