// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AdvertisementManagerScreen extends StatefulWidget {
//   @override
//   _AdvertisementManagerScreenState createState() => _AdvertisementManagerScreenState();
// }

// class _AdvertisementManagerScreenState extends State<AdvertisementManagerScreen> {
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();

//   void _addAd() {
//     FirebaseFirestore.instance.collection('advertisements').add({
//       'title': _titleController.text,
//       'description': _descController.text,
//       'image_path': '', // Tambahkan path gambar lokal jika diperlukan
//     });

//     _titleController.clear();
//     _descController.clear();
//   }

//   void _deleteAd(String id) {
//     FirebaseFirestore.instance.collection('advertisements').doc(id).delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: TextField(controller: _titleController, decoration: InputDecoration(labelText: "Judul Iklan")),
//           subtitle: TextField(controller: _descController, decoration: InputDecoration(labelText: "Deskripsi")),
//           trailing: IconButton(icon: Icon(Icons.send), onPressed: _addAd),
//         ),
//         Expanded(
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('advertisements').snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

//               final ads = snapshot.data!.docs;

//               return ListView.builder(
//                 itemCount: ads.length,
//                 itemBuilder: (context, index) {
//                   final data = ads[index].data() as Map<String, dynamic>;
//                   return ListTile(
//                     title: Text(data['title']),
//                     subtitle: Text(data['description']),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () => _deleteAd(ads[index].id),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdvertisementManagerScreen extends StatefulWidget {
  @override
  _AdvertisementManagerScreenState createState() =>
      _AdvertisementManagerScreenState();
}

class _AdvertisementManagerScreenState
    extends State<AdvertisementManagerScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _pickedImage;

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
      'image_path': _pickedImage?.path ?? '', // Simpan path lokal
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
    return Column(
      children: [
        ListTile(
          title: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Judul Iklan"),
              ),
              TextField(
                controller: _descController,
                decoration: InputDecoration(labelText: "Deskripsi"),
              ),
              const SizedBox(height: 8),
              if (_pickedImage != null) Image.file(_pickedImage!, height: 100),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pilih Gambar"),
              ),
            ],
          ),
          trailing: IconButton(icon: Icon(Icons.send), onPressed: _addAd),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('advertisements')
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final ads = snapshot.data!.docs;

              return ListView.builder(
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  final data = ads[index].data() as Map<String, dynamic>;
                  final imgPath = data['image_path'];

                  return ListTile(
                    title: Text(data['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['description']),
                        if (imgPath != null &&
                            imgPath.isNotEmpty &&
                            File(imgPath).existsSync())
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Image.file(File(imgPath), height: 100),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteAd(ads[index].id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
