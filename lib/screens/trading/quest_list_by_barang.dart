// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'quest_detail_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Untuk mendapatkan currentUser

// class QuestListByBarang extends StatelessWidget {
//   final String barangLabel;

//   const QuestListByBarang({required this.barangLabel});

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     return StreamBuilder<QuerySnapshot>(
//       stream:
//           FirebaseFirestore.instance
//               .collection('quests')
//               .where('status', isEqualTo: 'approved')
//               .where('barang', isEqualTo: barangLabel)
//               .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return Center(child: CircularProgressIndicator());

//         final docs = snapshot.data!.docs;

//         // Filter untuk menghindari menampilkan quest yang dibuat oleh user itu sendiri
//         final filteredDocs =
//             docs.where((doc) {
//               return doc['ownerId'] != currentUser!.uid;
//             }).toList();

//         if (filteredDocs.isEmpty) {
//           return Center(child: Text("Belum ada quest untuk $barangLabel"));
//         }

//         return ListView.builder(
//           itemCount: filteredDocs.length,
//           itemBuilder: (context, index) {
//             final data = filteredDocs[index].data() as Map<String, dynamic>;
//             final id = filteredDocs[index].id;

//             return ListTile(
//               title: Text('${data['name']}'),
//               subtitle: Text('${data['lokasi']} • ${data['barang']}'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (_) => QuestDetailScreen(questId: id, questData: data),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart'; // ini penting untuk buka link
import 'quest_detail_screen.dart';

class QuestListByBarang extends StatelessWidget {
  final String barangLabel;

  const QuestListByBarang({required this.barangLabel});

  // Function untuk membuka URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak bisa membuka URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('quests')
              .where('status', isEqualTo: 'approved')
              .where('barang', isEqualTo: barangLabel)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        // Filter untuk tidak menampilkan quest milik sendiri
        final filteredDocs =
            docs.where((doc) {
              return doc['ownerId'] != currentUser!.uid;
            }).toList();

        if (filteredDocs.isEmpty) {
          return Center(child: Text("Belum ada quest untuk $barangLabel"));
        }

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final data = filteredDocs[index].data() as Map<String, dynamic>;
            final id = filteredDocs[index].id;

            return ListTile(
              title: Text('${data['nama']}'), // Misal title-nya barang
              // Removed redundant Text widget causing the error
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _launchURL(data['lokasi']);
                    },
                    child: Text(
                      'Lihat Lokasi',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Kontak: ${data['kontak']}'),
                  Text('Tekan untuk detail lebih lanjut'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => QuestDetailScreen(questId: id, questData: data),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
