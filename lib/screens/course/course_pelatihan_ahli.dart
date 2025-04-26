// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../../models/user_model.dart';
// import 'course_upload.dart';

// class CoursePelatihanAhliScreen extends StatelessWidget {
//   final UserModel user;

//   const CoursePelatihanAhliScreen({super.key, required this.user});

//   // Fungsi untuk menampilkan popup detail course
//   void _showDetailPopup(BuildContext context, DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(data['title'] ?? 'Tanpa Judul'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Menampilkan gambar lokal
//             data.containsKey('imagePath') && data['imagePath'] != null
//                 ? Image.file(
//                     File(data['imagePath']),
//                     height: 150,
//                     fit: BoxFit.cover,
//                   )
//                 : const Icon(Icons.image_not_supported, size: 150),
//             const SizedBox(height: 10),
//             Text(data['description'] ?? 'Tanpa Deskripsi'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Tutup'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Fungsi untuk menghapus course
//   void _deleteCourse(String id) {
//     FirebaseFirestore.instance.collection('courses_pelatihan').doc(id).delete();
//   }

//   // Fungsi untuk mengedit course
//   void _editCourse(BuildContext context, DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CourseUploadScreen(
//           user: user,
//           isEdit: true,
//           docId: doc.id,
//           initialTitle: data['title'] ?? '',
//           initialDescription: data['description'] ?? '',
//           initialImagePath: data['imagePath'] ?? '',
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Course Pelatihan Ahli'),
//         actions: [
//           if (user.role == 'admin')
//             IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CourseUploadScreen(user: user),
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('courses_pelatihan')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(child: Text('Terjadi kesalahan'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final docs = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final doc = docs[index];
//               final data = doc.data() as Map<String, dynamic>;

//               return ListTile(
//                 leading: data.containsKey('imagePath') && data['imagePath'] != null
//                     ? Image.file(
//                         File(data['imagePath']),
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       )
//                     : const Icon(Icons.image_not_supported, size: 50),
//                 title: Text(data['title'] ?? 'Tanpa Judul'),
//                 subtitle: Text(data['description'] ?? 'Tanpa Deskripsi'),
//                 onTap: () => _showDetailPopup(context, doc),
//                 trailing: data['authorId'] == user.uid || user.role == 'admin'
//                     ? Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Tombol edit, hanya untuk admin atau author
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.orange),
//                             onPressed: () => _editCourse(context, doc),
//                           ),
//                           // Tombol hapus, hanya untuk admin atau author
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _deleteCourse(doc.id),
//                           ),
//                         ],
//                       )
//                     : null,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'course_upload.dart';

class CoursePelatihanAhliScreen extends StatelessWidget {
  final UserModel user;

  const CoursePelatihanAhliScreen({super.key, required this.user});

  // Fungsi untuk menampilkan popup detail course
  void _showDetailPopup(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final imagePath = data['image_path'];
    final imageFile = imagePath != null ? File(imagePath) : null;
    final fileExists = imageFile?.existsSync() ?? false;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(data['title'] ?? 'Tanpa Judul'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                fileExists
                    ? Image.file(imageFile!, height: 150, fit: BoxFit.cover)
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
    FirebaseFirestore.instance.collection('courses_pelatihan').doc(id).delete();
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

  bool _isUserSubscribed() {
    if (user.role == 'admin') return true;
    if (user.subscriptionStatus == 'active') {
      final now = DateTime.now();
      if (user.subscriptionExpiry != null &&
          user.subscriptionExpiry!.isAfter(now)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUserSubscribed()) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Pelatihan Ahli')),
        body: const Center(
          child: Text(
            'Fitur ini hanya tersedia untuk pengguna yang sudah berlangganan.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Pelatihan Ahli'),
        actions: [
          if (user.role == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CourseUploadScreen(
                          user: user,
                          isPelatihanAhli: true,
                        ),
                  ),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('courses_pelatihan')
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
              final imagePath = data['image_path'];
              final imageFile = imagePath != null ? File(imagePath) : null;
              final fileExists = imageFile?.existsSync() ?? false;

              return ListTile(
                leading:
                    fileExists
                        ? Image.file(
                          imageFile!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.image_not_supported, size: 50),
                title: Text(data['title'] ?? 'Tanpa Judul'),
                subtitle: Text(data['description'] ?? 'Tanpa Deskripsi'),
                onTap: () => _showDetailPopup(context, doc),
                trailing:
                    data['authorId'] == user.uid || user.role == 'admin'
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
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
