import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/quest_model.dart';
import '../../models/user_model.dart';

class AdminVerifikasiQuestScreen extends StatelessWidget {
  final UserModel user;
  const AdminVerifikasiQuestScreen({Key? key, required this.user}) : super(key: key);

  void _approveQuest(String docId) {
    FirebaseFirestore.instance.collection('quests').doc(docId).update({
      'status': 'approved',
    });
  }

  void _rejectQuest(String docId) {
    FirebaseFirestore.instance.collection('quests').doc(docId).update({
      'status': 'rejected',
    });
  }


  Future<void> _openLocation(String lokasi) async {
    final Uri uri;
    if (lokasi.startsWith('http')) {
      uri = Uri.parse(lokasi);
    } else {
      final encodedLocation = Uri.encodeComponent(lokasi);
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedLocation');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Jika gagal buka link
      debugPrint('Tidak dapat membuka lokasi: $lokasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verifikasi Permintaan (Admin)")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quests')
            .where('status', isEqualTo: 'pending')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final quests = snapshot.data!.docs;

          if (quests.isEmpty) return Center(child: Text("Tidak ada Permintaan pending."));

          return ListView.builder(
            itemCount: quests.length,
            itemBuilder: (context, index) {
              final questData = quests[index];
              final data = questData.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  // title: Text(data['nama']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _openLocation(data['lokasi']),
                        child: Text(
                          "Lokasi: ${data['lokasi']}",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text("Kontak: ${data['kontak']}"),
                      Text("Harga: ${data['harga']}"),
                      Text("Jumlah: ${data['jumlah']}"),
                      Text("Owner ID: ${data['ownerId']}"),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _approveQuest(questData.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _rejectQuest(questData.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
