
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdvertisementManagerScreen extends StatefulWidget {
  @override
  _AdvertisementManagerScreenState createState() => _AdvertisementManagerScreenState();
}

class _AdvertisementManagerScreenState extends State<AdvertisementManagerScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _pickedImage;

  final Color primaryColor = const Color(0xFF053B3F);

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  void _addAd() {
    FirebaseFirestore.instance.collection('advertisements').add({
      'title': _titleController.text,
      'description': _descController.text,
      'image_path': _pickedImage?.path ?? '',
    });

    _titleController.clear();
    _descController.clear();
    setState(() {
      _pickedImage = null;
    });
  }

  void _deleteAd(String id) {
    FirebaseFirestore.instance.collection('advertisements').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manajemen Iklan"),
        // backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Judul Iklan",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: "Deskripsi",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_pickedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_pickedImage!, height: 100),
                      ),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image, color: primaryColor),
                      label: Text("Pilih Gambar", style: TextStyle(color: primaryColor)),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _addAd,
                      icon: Icon(Icons.send),
                      label: Text("Unggah Iklan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('advertisements').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  final ads = snapshot.data!.docs;

                  if (ads.isEmpty) {
                    return Center(child: Text("Belum ada iklan."));
                  }

                  return ListView.builder(
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final data = ads[index].data() as Map<String, dynamic>;
                      final imgPath = data['image_path'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            data['title'],
                            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(data['description']),
                              SizedBox(height: 8),
                              if (imgPath != null &&
                                  imgPath.isNotEmpty &&
                                  File(imgPath).existsSync())
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(File(imgPath), height: 100, fit: BoxFit.cover),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAd(ads[index].id),
                          ),
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

