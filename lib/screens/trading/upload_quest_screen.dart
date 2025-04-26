import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Tambahkan ini
import '../../models/user_model.dart';

class UploadQuestScreen extends StatefulWidget {
  final UserModel user;

  const UploadQuestScreen({required this.user, Key? key}) : super(key: key);

  @override
  _UploadQuestScreenState createState() => _UploadQuestScreenState();
}

class _UploadQuestScreenState extends State<UploadQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  String? selectedBarang;
  final List<String> barangList = [
    'Padi',
    'Jagung',
    'Singkong',
    'Kentang',
    'Bawang Merah',
    'Bawang Putih',
  ];

  void _showHppPopup() async {
    final snapshot = await FirebaseFirestore.instance.collection('hpp_barang').get();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Harga HPP Barang"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: snapshot.docs.map((doc) {
              return ListTile(
                title: Text(doc.id),
                trailing: Text("Rp ${doc['value']}"),
              );
            }).toList(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Tutup")),
          ],
        );
      },
    );
  }

  Future<void> _uploadQuest() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'ownerId': widget.user.name,
        'lokasi': _lokasiController.text.trim(),
        'kontak': _kontakController.text.trim(),
        'harga': int.parse(_hargaController.text.trim()),
        'jumlah': int.parse(_jumlahController.text.trim()),
        'barang': selectedBarang,
        'status': 'pending',
        'ownerId': widget.user.uid,
        'timestamp': Timestamp.now(),
      };

      try {
        await FirebaseFirestore.instance.collection('quests').add(data);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quest berhasil diunggah!')));
        Navigator.pop(context);
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengunggah quest.')));
      }
    }
  }

  Future<void> _openGoogleMaps() async {
    final Uri uri = Uri.parse("https://www.google.com/maps");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka Google Maps')),
      );
    }
  }


  Widget _buildHppInfo() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('settings').doc('hpp').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Memuat HPP...", style: TextStyle(fontWeight: FontWeight.bold));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text("HPP belum tersedia.", style: TextStyle(color: Colors.red));
        }

        final hpp = snapshot.data!.get('value');
        return Text(
          "HPP Saat Ini: Rp ${hpp.toString()}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Quest")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Lihat Harga HPP:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: _showHppPopup,
                    icon: Icon(Icons.visibility),
                    label: Text("Lihat HPP"),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Pilih Barang", border: OutlineInputBorder()),
                value: selectedBarang,
                items: barangList.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBarang = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih barang' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lokasiController,
                decoration: InputDecoration(
                  labelText: 'Link atau Nama Lokasi',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.map),
                    onPressed: _openGoogleMaps, // buka maps langsung!
                  ),

                ),
                validator: (value) => value!.isEmpty ? 'Masukkan lokasi atau link Google Maps' : null,
              ),
              TextFormField(
                controller: _kontakController,
                decoration: InputDecoration(labelText: 'Kontak'),
                validator: (value) => value!.isEmpty ? 'Masukkan kontak' : null,
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga yang Ditawarkan'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Masukkan harga' : null,
              ),
              TextFormField(
                controller: _jumlahController,
                decoration: InputDecoration(labelText: 'Jumlah yang Dibeli'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Masukkan jumlah' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadQuest,
                child: Text("Kirim Quest"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}