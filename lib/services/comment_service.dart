import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentService {
  final _commentCollection = FirebaseFirestore.instance.collection('comments');

  Future<List<CommentModel>> getCommentsByPost(String postId) async {
    final snapshot =
    await _commentCollection
        .where('postId', isEqualTo: postId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CommentModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> addComment(CommentModel comment) async {
    await _commentCollection.doc(comment.id).set(comment.toMap());
  }
}
