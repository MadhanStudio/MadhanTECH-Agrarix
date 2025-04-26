// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/post_model.dart';

// class PostService {
//   final _posts = FirebaseFirestore.instance.collection('posts');

//   Future<void> createPost(PostModel post) async {
//     await _posts.add(post.toMap());
//   }

//   Future<List<PostModel>> getAllPosts() async {
//     final snapshot = await _posts.orderBy('timestamp', descending: true).get();
//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return PostModel.fromMap(data, doc.id);
//     }).toList();
//   }

//   Future<void> updatePost(PostModel post) async {
//     await _posts.doc(post.id).update(post.toMap());
//   }

//   Future<void> toggleLike(String postId, String userId) async {
//     final doc = _posts.doc(postId);
//     final snap = await doc.get();

//     if (!snap.exists) return;

//     final post = PostModel.fromMap(snap.data() as Map<String, dynamic>, doc.id);
//     final updatedLikes = List<String>.from(post.likes);

//     if (updatedLikes.contains(userId)) {
//       updatedLikes.remove(userId);
//     } else {
//       updatedLikes.add(userId);
//     }

//     await doc.update({'likes': updatedLikes});
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final _posts = FirebaseFirestore.instance.collection('posts');

  // Membuat Post
  Future<void> createPost(PostModel post) async {
    await _posts.add(post.toMap());
  }

  // Mengambil semua Post
  Future<List<PostModel>> getAllPosts() async {
    final snapshot = await _posts.orderBy('timestamp', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel.fromMap(data, doc.id);
    }).toList();
  }

  Future<void> deletePost(String postId) async {
    await _posts.doc(postId).delete();
  }

  Future<void> updatePost(PostModel post) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .update(post.toMap());
  }

  // Mengubah status suka / tidak suka pada Post
  Future<void> toggleLike(String postId, String userId) async {
    final doc = _posts.doc(postId);
    final snap = await doc.get();

    if (!snap.exists) return;

    final post = PostModel.fromMap(snap.data() as Map<String, dynamic>, doc.id);
    final updatedLikes = List<String>.from(post.likes);

    if (updatedLikes.contains(userId)) {
      updatedLikes.remove(userId);
    } else {
      updatedLikes.add(userId);
    }

    await doc.update({'likes': updatedLikes});
  }
}
