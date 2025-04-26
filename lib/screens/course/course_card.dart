import 'dart:io';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onTap;

  const CourseCard({Key? key, required this.course, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = course['title'] ?? 'Tanpa Judul';
    final String? imagePath = course['image_path'];

    Widget imageWidget;
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        // Ini URL internet
        imageWidget = Image.network(
          imagePath,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _fallbackImage();
          },
        );
      } else {
        // Ini path lokal (file di hp)
        final file = File(imagePath);
        if (file.existsSync()) {
          imageWidget = Image.file(
            file,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        } else {
          imageWidget = _fallbackImage();
        }
      }
    } else {
      imageWidget = _fallbackImage();
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageWidget,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/images/logo.png',
      height: 150,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
