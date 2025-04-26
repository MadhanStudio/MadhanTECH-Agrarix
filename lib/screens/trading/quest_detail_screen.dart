// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../messages/chat_detail_screen.dart';
// import '../../models/user_model.dart';

// class QuestDetailScreen extends StatelessWidget {
//   final String questId;
//   final Map<String, dynamic> questData;

//   const QuestDetailScreen({
//     required this.questId,
//     required this.questData,
//     Key? key,
//   }) : super(key: key);

//   Future<UserModel> getUserModelByUid(String uid) async {
//     final doc =
//         await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     final data = doc.data();
//     if (data == null) throw Exception("User not found");
//     return UserModel.fromMap(data);
//   }

//   void _navigateToChat(BuildContext context) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) return;

//     try {
//       final currentUserModel = await getUserModelByUid(currentUser.uid);
//       final targetUserModel = await getUserModelByUid(questData['ownerId']);

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (_) => ChatDetailScreen(
//                 currentUser: currentUserModel,
//                 targetUser: targetUserModel,
//               ),
//         ),
//       );
//     } catch (e) {
//       print("Error navigating to chat: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Gagal membuka chat")));
//     }
//   }

//   void _acceptQuest(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     await FirebaseFirestore.instance.collection('quests').doc(questId).update({
//       'status': 'diterima',
//       'diterimaOleh': user.uid,
//     });

//     Navigator.pop(context); // Kembali ke list
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Detail Quest")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Dari: ${questData['akun']}"),
//             Text("Barang: ${questData['barang']}"),
//             Text("Lokasi: ${questData['lokasi']}"),
//             Text("Kontak: ${questData['kontak']}"),
//             Text("Harga: ${questData['harga']}"),
//             Text("Jumlah: ${questData['jumlah']}"),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () => _navigateToChat(context),
//                   child: const Text("Chat"),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: () => _acceptQuest(context),
//                   child: const Text("Terima"),
//                 ),
//                 const SizedBox(width: 16),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../messages/chat_detail_screen.dart';
import '../../models/user_model.dart';

class QuestDetailScreen extends StatelessWidget {
  final String questId;
  final Map<String, dynamic> questData;

  const QuestDetailScreen({
    required this.questId,
    required this.questData,
    Key? key,
  }) : super(key: key);

  Future<UserModel> getUserModelByUid(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null) throw Exception("User not found");
    return UserModel.fromMap(data);
  }

  void _navigateToChat(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final currentUserModel = await getUserModelByUid(currentUser.uid);
      final targetUserModel = await getUserModelByUid(questData['ownerId']);

      // Menyiapkan pesan otomatis dengan data quest
      String autoMessage =
          "Saya tertarik dengan quest Anda. Berikut adalah detail quest:\n"
          "Barang: ${questData['barang']}\n"
          "Lokasi: ${questData['lokasi']}\n"
          "Harga: ${questData['harga']}\n"
          "Jumlah: ${questData['jumlah']}\n"
          "Kontak: ${questData['kontak']}\n\n"
          "Apakah Anda bisa memberikan penjelasan lebih lanjut?";

      // Menambahkan pesan otomatis ke dalam chat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ChatDetailScreen(
                currentUser: currentUserModel,
                targetUser: targetUserModel,
                initialMessage: autoMessage, // Menyertakan pesan otomatis
              ),
        ),
      );
    } catch (e) {
      print("Error navigating to chat: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal membuka chat")));
    }
  }

  void _acceptQuest(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('quests').doc(questId).update({
      'status': 'diterima',
      'diterimaOleh': user.uid,
    });

    // Navigator.pop(context); // Kembali ke list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Quest")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Dari: ${questData['akun']}"),
            Text("Nama: ${questData['nama']}"),
            Text("Barang: ${questData['barang']}"),
            Text("Lokasi: ${questData['lokasi']}"),
            Text("Kontak: ${questData['kontak']}"),
            Text("Harga: ${questData['harga']}"),
            Text("Jumlah: ${questData['jumlah']}"),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _acceptQuest(context);
                    _navigateToChat(context);
                  },
                  child: const Text("Terima"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
