// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AdminHppInputScreen extends StatefulWidget {
//   const AdminHppInputScreen({super.key});

//   @override
//   _AdminHppInputScreenState createState() => _AdminHppInputScreenState();
// }

// class _AdminHppInputScreenState extends State<AdminHppInputScreen> {
//   final TextEditingController _controller = TextEditingController();
//   bool _loading = false;

//   Future<void> _saveHpp() async {
//     setState(() => _loading = true);

//     final double? hppValue = double.tryParse(_controller.text);
//     if (hppValue == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Masukkan angka yang valid")),
//       );
//       setState(() => _loading = false);
//       return;
//     }

//     await FirebaseFirestore.instance.collection('settings').doc('hpp').set({
//       'value': hppValue,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     setState(() => _loading = false);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("HPP berhasil disimpan")),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadExistingHpp();
//   }

//   Future<void> _loadExistingHpp() async {
//     final doc = await FirebaseFirestore.instance.collection('settings').doc('hpp').get();
//     if (doc.exists) {
//       final value = doc['value'];
//       _controller.text = value.toString();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Input HPP")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Nilai HPP",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _loading ? null : _saveHpp,
//               child: Text(_loading ? "Menyimpan..." : "Simpan"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHppInputScreen extends StatefulWidget {
  const AdminHppInputScreen({Key? key}) : super(key: key);

  @override
  _AdminHppInputScreenState createState() => _AdminHppInputScreenState();
}

class _AdminHppInputScreenState extends State<AdminHppInputScreen> {
  final List<String> barangList = [
    'Padi',
    'Jagung',
    'Singkong',
    'Kentang',
    'Bawang Merah',
    'Bawang Putih',
  ];

  final Map<String, TextEditingController> _controllers = {};

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    for (var item in barangList) {
      _controllers[item] = TextEditingController();
    }
    _loadExistingHpp();
  }

  Future<void> _loadExistingHpp() async {
    final snapshot = await FirebaseFirestore.instance.collection('hpp_barang').get();
    for (var doc in snapshot.docs) {
      _controllers[doc.id]?.text = doc['value'].toString();
    }
    setState(() {});
  }

  Future<void> _saveAllHpp() async {
    setState(() => _loading = true);
    for (var barang in barangList) {
      final val = double.tryParse(_controllers[barang]!.text);
      if (val != null) {
        await FirebaseFirestore.instance.collection('hpp_barang').doc(barang).set({
          'value': val,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    }
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("HPP berhasil disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Input HPP Barang")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            for (var barang in barangList)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: _controllers[barang],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "$barang (Rp)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _saveAllHpp,
              child: Text(_loading ? "Menyimpan..." : "Simpan Semua"),
            ),
          ],
        ),
      ),
    );
  }
}
