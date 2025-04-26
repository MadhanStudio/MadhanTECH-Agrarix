import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    FirebaseFirestore.instance.collection('quests').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verifikasi Quest (Admin)")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quests')
            .where('status', isEqualTo: 'pending')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final quests = snapshot.data!.docs;

          if (quests.isEmpty) return Center(child: Text("Tidak ada quest pending."));

          return ListView.builder(
            itemCount: quests.length,
            itemBuilder: (context, index) {
              final questData = quests[index];
              final data = questData.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(user.name),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lokasi: ${data['lokasi']}"),
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
