// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ApprovedQuestListScreen extends StatelessWidget {
//   const ApprovedQuestListScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Daftar Quest Tersedia")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('quests')
//             .where('status', isEqualTo: 'approved')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

//           final quests = snapshot.data!.docs;

//           if (quests.isEmpty) return Center(child: Text("Belum ada quest yang tersedia."));

//           return ListView.builder(
//             itemCount: quests.length,
//             itemBuilder: (context, index) {
//               final data = quests[index].data() as Map<String, dynamic>;

//               return Card(
//                 margin: const EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text(data['akun']),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Lokasi: ${data['lokasi']}"),
//                       Text("Kontak: ${data['kontak']}"),
//                       Text("Harga: ${data['harga']}"),
//                       Text("Jumlah: ${data['jumlah']}"),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'quest_list_by_barang.dart'; // Pastikan kamu punya file ini

class ApprovedListQuestScreen extends StatelessWidget {
  const ApprovedListQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Approved Quest List'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Padi'),
              Tab(text: 'Jagung'),
              Tab(text: 'Kedelai'),
              Tab(text: 'Cabe'),
              Tab(text: 'Bawang Merah'),
              Tab(text: 'Bawang Merah'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            QuestListByBarang(barangLabel: 'Padi'),
            QuestListByBarang(barangLabel: 'Jagung'),
            QuestListByBarang(barangLabel: 'Kedelai'),
            QuestListByBarang(barangLabel: 'Cabe'),
            QuestListByBarang(barangLabel: 'Bawang Putih'),
            QuestListByBarang(barangLabel: 'Bawang Merah'),
          ],
        ),
      ),
    );
  }
}
