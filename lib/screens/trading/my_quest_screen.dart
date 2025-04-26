// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../models/user_model.dart';

// class MyQuestScreen extends StatelessWidget {
//   final UserModel user;

//   MyQuestScreen({required this.user});

//   void _markAsFinished(String questId) {
//     FirebaseFirestore.instance.collection('quests').doc(questId).update({
//       'isFinished': true,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Quest Saya")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('quests')
//             .where('status', isEqualTo: 'diterima') // Filter quest yang diterima
//             .where('participants', arrayContains: user.uid) // Menampilkan quest yang diterima oleh user
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final receivedQuests = snapshot.data!.docs;

//           return StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('quests')
//                 .where('ownerId', isEqualTo: user.uid) // Filter quest yang dibuat oleh user
//                 .snapshots(),
//             builder: (context, snapshot2) {
//               if (!snapshot2.hasData)
//                 return Center(child: CircularProgressIndicator());

//               final createdQuests = snapshot2.data!.docs;

//               // Gabungkan kedua daftar quest
//               final allQuests = [...createdQuests, ...receivedQuests];

//               if (allQuests.isEmpty)
//                 return Center(child: Text("Tidak ada quest yang tersedia."));

//               return ListView.builder(
//                 itemCount: allQuests.length,
//                 itemBuilder: (context, index) {
//                   final doc = allQuests[index];
//                   final data = doc.data() as Map<String, dynamic>;

//                   return Card(
//                     margin: const EdgeInsets.all(8),
//                     child: ListTile(
//                       title: Text(data['akun']),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Lokasi: ${data['lokasi']}"),
//                           Text("Kontak: ${data['kontak']}"),
//                           Text("Harga: ${data['harga']}"),
//                           Text("Jumlah: ${data['jumlah']}"),
//                         ],
//                       ),
//                       trailing: ElevatedButton(
//                         onPressed: () => _markAsFinished(doc.id),
//                         child: Text("Selesai"),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class MyQuestScreen extends StatelessWidget {
  final UserModel user;

  MyQuestScreen({required this.user});

  void _markAsFinished(String questId) {
    FirebaseFirestore.instance.collection('quests').doc(questId).update({
      'isFinished': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quest Saya")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('quests')
                .where(
                  'status',
                  isEqualTo: 'diterima',
                ) // Quest yang diterima oleh pengguna
                .where(
                  'diterimaOleh',
                  isEqualTo: user.uid,
                ) // Quest yang diterima oleh user (menggunakan 'diterimaOleh')
                .snapshots(),
        builder: (context, receivedSnapshot) {
          if (!receivedSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final receivedQuests = receivedSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('quests')
                    .where(
                      'ownerId',
                      isEqualTo: user.uid,
                    ) // Quest yang dibuat oleh pengguna
                    .snapshots(),
            builder: (context, createdSnapshot) {
              if (!createdSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final createdQuests = createdSnapshot.data!.docs;

              // Gabungkan kedua daftar quest (quest yang diterima dan quest yang dibuat)
              final allQuests = [...createdQuests, ...receivedQuests];

              if (allQuests.isEmpty) {
                return Center(child: Text("Tidak ada quest yang tersedia."));
              }

              return ListView.builder(
                itemCount: allQuests.length,
                itemBuilder: (context, index) {
                  final doc = allQuests[index];
                  final data = doc.data() as Map<String, dynamic>;

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
                        ],
                      ),
                      // Menambahkan tombol "Selesai" hanya jika quest dibuat oleh pengguna
                      trailing:
                          data['ownerId'] == user.uid
                              ? ElevatedButton(
                                onPressed: () => _markAsFinished(doc.id),
                                child: Text("Selesai"),
                              )
                              : null, // Jika quest diterima oleh pengguna, tidak ada tombol "Selesai"
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
