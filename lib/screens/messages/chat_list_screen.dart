// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatListScreen extends StatelessWidget {
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream:
//           FirebaseFirestore.instance
//               .collection('chats')
//               .where('participants', arrayContains: currentUserId)
//               .orderBy('lastTimestamp', descending: true)
//               .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(child: Text("Belum ada pesan masuk."));
//         }

//         final chats = snapshot.data!.docs;

//         return ListView.builder(
//           itemCount: chats.length,
//           itemBuilder: (context, index) {
//             final chat = chats[index];
//             final participants = List<String>.from(chat['participants']);
//             final otherUserId = participants.firstWhere(
//               (id) => id != currentUserId,
//             );
//             final lastMessage = chat['lastMessage'] ?? '';
//             final timestamp = (chat['lastTimestamp'] as Timestamp?)?.toDate();
//             final unreadCount = chat['unread']?[currentUserId] ?? 0;

//             return FutureBuilder<DocumentSnapshot>(
//               future:
//                   FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(otherUserId)
//                       .get(),
//               builder: (context, userSnapshot) {
//                 if (userSnapshot.connectionState == ConnectionState.waiting) {
//                   return ListTile(title: Text('Memuat...'));
//                 }

//                 if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
//                   return ListTile(title: Text('Pengguna tidak ditemukan'));
//                 }

//                 final userData =
//                     userSnapshot.data!.data() as Map<String, dynamic>;
//                 final displayName = userData['name'] ?? 'Pengguna';

//                 return ListTile(
//                   leading: CircleAvatar(child: Text(displayName[0])),
//                   title: Text(displayName),
//                   subtitle: Text(
//                     lastMessage,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   trailing: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (timestamp != null)
//                         Text(
//                           TimeOfDay.fromDateTime(timestamp).format(context),
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       if (unreadCount > 0)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: CircleAvatar(
//                             radius: 10,
//                             backgroundColor: Colors.red,
//                             child: Text(
//                               unreadCount.toString(),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   onTap: () {
//                     // TODO: Arahkan ke ChatRoomScreen atau halaman percakapan
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import 'chat_detail_screen.dart';
import 'dart:io';

class ChatListScreen extends StatelessWidget {
  final UserModel currentUser;

  ChatListScreen({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('chats')
              .where('participants', arrayContains: currentUser.uid)
              .orderBy('lastTimestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final chats = snapshot.data!.docs;

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final data = chats[index].data() as Map<String, dynamic>;
            final participants = List<String>.from(data['participants']);
            final partnerId = participants.firstWhere(
              (id) => id != currentUser.uid,
            );

            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(partnerId)
                      .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return SizedBox();

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                final targetUser = UserModel(
                  uid: partnerId,
                  name: userData['name'],
                  email: userData['email'],
                  role:
                      userData['role'] ??
                      'Unknown', // Provide a default value if necessary
                  imagePath:
                      userData['imagePath'] ??
                      '', // Provide a default value if necessary
                );

                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        userData['imagePath'] != null
                            ? FileImage(File(userData['imagePath']))
                            : null,
                    child:
                        userData['imagePath'] == null
                            ? Icon(Icons.person, color: Colors.white)
                            : null,
                  ),
                  title: Text(targetUser.name),
                  subtitle: Text(data['lastMessage'] ?? 'Belum ada pesan'),
                  trailing: Text(
                    (data['lastTimestamp'] as Timestamp?)
                            ?.toDate()
                            .toLocal()
                            .toString()
                            .substring(0, 16) ??
                        '',
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ChatDetailScreen(
                              currentUser: currentUser,
                              targetUser: targetUser,
                              initialMessage: data['lastMessage'] ?? '',
                            ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
