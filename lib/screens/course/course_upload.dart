import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseUploadScreen extends StatefulWidget {
  final bool isEdit;
  final String? docId;
  final String? initialTitle;
  final String? initialDescription;
  final String? initialImagePath;
  final bool isPelatihanAhli;
  final UserModel user;

  const CourseUploadScreen({
    super.key,
    this.isEdit = false,
    this.docId,
    this.initialTitle,
    this.initialDescription,
    this.initialImagePath,
    this.isPelatihanAhli = false,
    required this.user,
  });

  @override
  State<CourseUploadScreen> createState() => _CourseUploadScreenState();
}

class _CourseUploadScreenState extends State<CourseUploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _localImagePath;
  File? _selectedImage;

  List<Module> modules = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _titleController.text = widget.initialTitle ?? '';
      _descController.text = widget.initialDescription ?? '';
      _localImagePath = widget.initialImagePath;
      if (_localImagePath != null) {
        _selectedImage = File(_localImagePath!);
      }
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _localImagePath = picked.path;
      });
    }
  }

  Future<void> pickModuleFile(int index) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        modules[index].file = File(picked.path);
        modules[index].filePath = picked.path;
      });
    }
  }

  Future<void> uploadCourse() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan Deskripsi tidak boleh kosong")),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User tidak ditemukan. Silakan login ulang."),
        ),
      );
      return;
    }

    final collectionName =
        widget.isPelatihanAhli ? "courses_pelatihan" : "courses_komunitas";
    final docRef = FirebaseFirestore.instance.collection(collectionName);

    if (widget.isEdit) {
      // Update course yang sudah ada
      await docRef.doc(widget.docId).update({
        "title": _titleController.text,
        "description": _descController.text,
        "image_path": _localImagePath, // Menyimpan path gambar lokal
        "updatedAt": Timestamp.now(),
      });
    } else {
      // Tambahkan course baru
      final newDoc = await docRef.add({
        "title": _titleController.text,
        "description": _descController.text,
        "authorId": currentUser.uid,
        "authorName": widget.user.name,
        "image_path": _localImagePath, // Menyimpan path gambar lokal
        "createdAt": Timestamp.now(),
      });

      // Jika ini pelatihan ahli, unggah modul-modul
      if (widget.isPelatihanAhli && modules.isNotEmpty) {
        for (final module in modules) {
          await newDoc.collection('modules').add({
            "title": module.title,
            "description": module.description,
            "file_path": module.filePath,
            "createdAt": Timestamp.now(),
          });
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEdit
              ? 'Course berhasil diperbarui'
              : 'Course berhasil diunggah',
        ),
      ),
    );

    Navigator.pop(context);
  }

  void addModule() {
    setState(() {
      modules.add(Module());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Course" : "Upload Course"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Judul"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pilih Gambar"),
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 10),
                Image.file(_selectedImage!, height: 100),
              ],
              const SizedBox(height: 20),

              if (widget.isPelatihanAhli) ...[
                const Text(
                  "Modul",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: modules.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Judul Modul",
                              ),
                              onChanged: (value) {
                                modules[index].title = value;
                              },
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Deskripsi Modul",
                              ),
                              maxLines: 2,
                              onChanged: (value) {
                                modules[index].description = value;
                              },
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => pickModuleFile(index),
                              child: const Text("Upload File Modul"),
                            ),
                            if (modules[index].file != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  path.basename(modules[index].file!.path),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: addModule,
                  child: const Text("Tambah Modul"),
                ),
              ],

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadCourse,
                child: Text(widget.isEdit ? "Simpan Perubahan" : "Upload"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Module {
  String title = '';
  String description = '';
  String? filePath;
  File? file;
}
