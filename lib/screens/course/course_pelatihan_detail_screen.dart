import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursePelatihanDetailScreen extends StatelessWidget {
  final String courseId;
  final Map<String, dynamic> courseData;

  const CoursePelatihanDetailScreen({
    super.key,
    required this.courseId,
    required this.courseData,
  });

  void _showModuleDetail(BuildContext context, DocumentSnapshot moduleDoc) {
    final data = moduleDoc.data() as Map<String, dynamic>;
    final title = data['title'] ?? 'Tanpa Judul Modul';
    final description = data['description'] ?? 'Tanpa Deskripsi Modul';
    final fileUrl = data['file_path'];

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  if (fileUrl != null)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _downloadFile(fileUrl);
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download File Modul'),
                      ),
                    ),
                ],
              ),
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

  Future<void> _downloadFile(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak bisa membuka URL: $url';
      }
    } catch (e) {
      debugPrint('Error membuka URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = courseData['image_path'];
    final imageFile = imagePath != null ? File(imagePath) : null;
    final fileExists = imageFile?.existsSync() ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(courseData['title'] ?? 'Detail Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fileExists
                ? Image.file(
                  imageFile!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                : Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 100),
                ),
            const SizedBox(height: 20),
            Text(
              courseData['title'] ?? 'Tanpa Judul',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              courseData['description'] ?? 'Tanpa Deskripsi',
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 40),
            const Text(
              'Daftar Modul:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('courses_pelatihan')
                        .doc(courseId)
                        .collection('modules')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Terjadi kesalahan'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final modules = snapshot.data!.docs;

                  if (modules.isEmpty) {
                    return const Center(child: Text('Belum ada modul.'));
                  }

                  return ListView.builder(
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      final module =
                          modules[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(module['title'] ?? 'Tanpa Judul Modul'),
                          subtitle: Text(
                            module['description'] ?? 'Tanpa Deskripsi Modul',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            _showModuleDetail(context, modules[index]);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
