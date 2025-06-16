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
      // Safely parse integers
      final int? harga = int.tryParse(_hargaController.text.trim());
      final int? jumlah = int.tryParse(_jumlahController.text.trim());

      if (harga == null || jumlah == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Harga dan Jumlah harus berupa angka yang valid.')));
        }
        return;
      }

      final data = {
        'nama': widget.user.name, // User's display name
        'lokasi': _lokasiController.text.trim(),
        'kontak': _kontakController.text.trim(),
        'harga': harga,
        'jumlah': jumlah,
        'barang': selectedBarang,
        'status': 'pending',
        'ownerId': widget.user.uid, // User's unique ID
        'timestamp': Timestamp.now(),
      };

      try {
        await FirebaseFirestore.instance.collection('quests').add(data);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permintaan berhasil diunggah!')));
        Navigator.pop(context); // Pop after showing snackbar and if still mounted
      } catch (e) {
        print('Error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengunggah Permintaan.')));
        }
      }
    }
  }

  Future<void> _openGoogleMaps() async {
    final Uri uri = Uri.parse("https://www.google.com/maps");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka Google Maps')),
        );
      }
    }
  }


  Widget _buildHppInfo() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('settings').doc('hpp').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Memuat HPP...", style: TextStyle(fontStyle: FontStyle.italic));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("Info HPP umum tidak tersedia.", style: TextStyle(color: Colors.orange));
        }

        final hpp = snapshot.data!.get('value');
        return Text(
          "HPP Saat Ini: Rp ${hpp.toString()}",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[700]),
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    _lokasiController.dispose();
    _kontakController.dispose();
    _hargaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Permintaan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Harga Pokok Penjualan (HPP):", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: _showHppPopup,
                    icon: const Icon(Icons.info_outline),
                    label: const Text("Detail HPP Barang"),
                  ),
                ],
              ),
              _buildHppInfo(), // Displaying the general HPP info
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Pilih Barang", border: OutlineInputBorder()),
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
                  labelText: 'Nama Lokasi (Contoh: Pasar Keputran)',
                  hintText: 'atau tempel link Google Maps di sini',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: _openGoogleMaps, // buka maps langsung!
                    tooltip: 'Buka Google Maps untuk mencari/menyalin link',
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Masukkan lokasi atau link Google Maps' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kontakController,
                decoration: const InputDecoration(labelText: 'Kontak (No. Telepon)', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Masukkan kontak' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga yang Ditawarkan (per kg)', prefixText: "Rp ", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga';
                  }
                  final n = int.tryParse(value);
                  if (n == null) {
                    return 'Masukkan angka yang valid';
                  }
                  if (n <= 0) {
                    return 'Harga harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(labelText: 'Jumlah yang Dibutuhkan (kg)', suffixText: "kg", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah';
                  }
                  final n = int.tryParse(value);
                  if (n == null) {
                    return 'Masukkan angka yang valid';
                  }
                  if (n <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadQuest,
                child: Text("Kirim Permintaan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}