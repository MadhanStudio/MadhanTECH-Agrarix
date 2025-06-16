import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_model.dart';

class MyQuestScreen extends StatelessWidget {
  final UserModel user;

  MyQuestScreen({required this.user});

  void _markAsFinished(String questId) {
    FirebaseFirestore.instance.collection('quests').doc(questId).update({
      'isFinished': true,
    });
  }

  void _launchLocation(String lokasi) async {
    final url = Uri.encodeFull(lokasi);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka lokasi: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Permintaan Saya"),
          bottom: TabBar(
            tabs: [Tab(text: "Permintaan Dibuat"), Tab(text: "Permintaan Diterima")],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('quests')
                      .where('ownerId', isEqualTo: user.uid)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                final createdQuests = snapshot.data!.docs;
                if (createdQuests.isEmpty)
                  return Center(child: Text("Belum ada permintaan yang kamu buat."));

                return ListView.builder(
                  itemCount: createdQuests.length,
                  itemBuilder: (context, index) {
                    final doc = createdQuests[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final isFinished = data['isFinished'] == true;
                    final status = data['status'] ?? 'unknown';

                    Color? cardColor;
                    String statusLabel = "";

                    if (status == 'approved') {
                      cardColor = Colors.green[100];
                      statusLabel = "Disetujui";
                    } else if (status == 'rejected') {
                      cardColor = Colors.red[100];
                      statusLabel = "Ditolak";
                    } else if (status == 'pending') {
                      cardColor = Colors.yellow[100];
                      statusLabel = "Menunggu Verifikasi";
                    }

                    return Card(
                      margin: const EdgeInsets.all(8),
                      color: cardColor,
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => _launchLocation(data['lokasi']),
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
                            Text("Status: $statusLabel"),
                          ],
                        ),
                        trailing:
                            isFinished || status != 'approved'
                                ? null
                                : ElevatedButton(
                                  onPressed: () => _markAsFinished(doc.id),
                                  child: Text("Permintaan Telah Selesai"),
                                ),
                      ),
                    );
                  },
                );
              },
            ),

            // Tab 2: Quest yang diterima
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('quests')
                      .where('status', isEqualTo: 'diterima')
                      .where('diterimaOleh', isEqualTo: user.uid)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                final receivedQuests = snapshot.data!.docs;
                if (receivedQuests.isEmpty)
                  return Center(
                    child: Text("Belum ada Permintaan yang kamu terima."),
                  );

                return ListView.builder(
                  itemCount: receivedQuests.length,
                  itemBuilder: (context, index) {
                    final doc = receivedQuests[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => _launchLocation(data['lokasi']),
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
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
