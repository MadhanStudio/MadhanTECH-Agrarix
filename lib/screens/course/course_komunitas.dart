import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'course_upload.dart';
import 'dart:io';

class CourseKomunitasScreen extends StatelessWidget {
  final UserModel user;

  const CourseKomunitasScreen({super.key, required this.user});

  void _showDetailPopup(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(data['title'] ?? 'Tanpa Judul'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gunakan Image.file untuk gambar lokal
                data.containsKey('image_path') && data['image_path'] != null
                    ? Image.file(
                      File(data['image_path']),
                      height: 150,
                      fit: BoxFit.cover,
                    )
                    : const Icon(Icons.image_not_supported, size: 150),
                const SizedBox(height: 10),
                Text(data['description'] ?? 'Tanpa Deskripsi'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
    );
  }

  void _deleteCourse(String id) {
    FirebaseFirestore.instance.collection('courses_komunitas').doc(id).delete();
  }

  void _editCourse(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CourseUploadScreen(
              user: user,
              isEdit: true,
              docId: doc.id,
              initialTitle: data['title'] ?? '',
              initialDescription: data['description'] ?? '',
              initialImagePath: data['image_path'] ?? '',
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Komunitas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseUploadScreen(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('courses_komunitas')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading:
                    data.containsKey('image_path') && data['image_path'] != null
                        ? Image.file(
                          File(data['image_path']),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.image_not_supported, size: 50),
                title: Text(data['title'] ?? 'Tanpa Judul'),
                subtitle: Text(data['description'] ?? 'Tanpa Deskripsi'),
                onTap: () => _showDetailPopup(context, doc),
                trailing: data['authorId'] == user.uid
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _editCourse(context, doc),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCourse(doc.id),
                        ),
                      ],
                    )
                  : null,

              );
            },
          );
        },
      ),
    );
  }
}
