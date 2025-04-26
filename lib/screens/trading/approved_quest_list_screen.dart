// import 'package:flutter/material.dart';
// import 'quest_list_by_barang.dart';

// class ApprovedListQuestScreen extends StatelessWidget {
//   const ApprovedListQuestScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text('Komoditas Pilihan'),
//           bottom: TabBar(
//             isScrollable: true,
//             tabs: [
//               Tab(text: 'Padi'),
//               Tab(text: 'Jagung'),
//               Tab(text: 'kentang'),
//               Tab(text: 'singkong'),
//               Tab(text: 'Bawang putih'),
//               Tab(text: 'Bawang Merah'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             QuestListByBarang(barangLabel: 'Padi'),
//             QuestListByBarang(barangLabel: 'Jagung'),
//             QuestListByBarang(barangLabel: 'kentang'),
//             QuestListByBarang(barangLabel: 'singkong'),
//             QuestListByBarang(barangLabel: 'Bawang Putih'),
//             QuestListByBarang(barangLabel: 'Bawang Merah'),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:agrarixx/models/user_model.dart';
import 'package:flutter/material.dart';
import 'quest_list_by_barang.dart';
import 'upload_quest_screen.dart';

class ApprovedListQuestScreen extends StatefulWidget {
  final UserModel user;
  const ApprovedListQuestScreen({super.key, required this.user});

  @override
  _ApprovedListQuestScreenState createState() =>
      _ApprovedListQuestScreenState();
}

class _ApprovedListQuestScreenState extends State<ApprovedListQuestScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Komoditas Pilihan'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Padi'),
              Tab(text: 'Jagung'),
              Tab(text: 'Kentang'),
              Tab(text: 'Singkong'),
              Tab(text: 'Bawang Putih'),
              Tab(text: 'Bawang Merah'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            QuestListByBarang(barangLabel: 'Padi'),
            QuestListByBarang(barangLabel: 'Jagung'),
            QuestListByBarang(barangLabel: 'kentang'),
            QuestListByBarang(barangLabel: 'singkong'),
            QuestListByBarang(barangLabel: 'Bawang Putih'),
            QuestListByBarang(barangLabel: 'Bawang Merah'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF053B3F), // warna sesuai permintaan
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadQuestScreen(user: widget.user),
              ),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
