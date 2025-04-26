import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CourseEditScreen extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final String initialImagePath;

  const CourseEditScreen({
    Key? key,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialImagePath,
  }) : super(key: key);

  @override
  State<CourseEditScreen> createState() => _CourseEditScreenState();
}

class _CourseEditScreenState extends State<CourseEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _selectedImage = File(widget.initialImagePath);
  }

  Future<void> _pickNewImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedImage != null) {
      // Simpan perubahan ke Firestore / local
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan berhasil disimpan!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150)
                : const Text('Belum ada gambar'),
            TextButton.icon(
              onPressed: _pickNewImage,
              icon: const Icon(Icons.image),
              label: const Text('Ganti Gambar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Simpan Perubahan'),
            )
          ],
        ),
      ),
    );
  }
}
