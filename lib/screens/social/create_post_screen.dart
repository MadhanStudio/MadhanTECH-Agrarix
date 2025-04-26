import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  final UserModel user;
  final PostModel? existingPost;

  const CreatePostScreen({Key? key, required this.user, this.existingPost}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.existingPost != null) {
      _textController.text = widget.existingPost!.content;
      if (widget.existingPost!.imagePath != null &&
          File(widget.existingPost!.imagePath!).existsSync()) {
        _selectedImage = File(widget.existingPost!.imagePath!);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitPost() async {
    final content = _textController.text.trim();
    if (content.isEmpty && _selectedImage == null) return;

    if (widget.existingPost != null) {
      // Mode edit: update postingan yang sudah ada
      final updatedPost = widget.existingPost!.copyWith(
        content: content,
        imagePath: _selectedImage?.path,
        timestamp: DateTime.now(),
      );
      await PostService().updatePost(updatedPost);
    } else {
      // Mode baru: buat postingan baru
      final newPost = PostModel(
        id: const Uuid().v4(),
        username: widget.user.name,
        userId: widget.user.uid,
        content: content,
        imagePath: _selectedImage?.path,
        timestamp: DateTime.now(),
        likes: [],
      );
      await PostService().createPost(newPost);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingPost != null ? "Edit Postingan" : "Buat Postingan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Apa yang ingin kamu bagikan?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Tambah Gambar"),
                ),
                ElevatedButton(
                  onPressed: _submitPost,
                  child: Text(widget.existingPost != null ? "Simpan" : "Posting"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
