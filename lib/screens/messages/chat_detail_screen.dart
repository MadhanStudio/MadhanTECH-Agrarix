// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../models/user_model.dart'; // pastikan path sesuai struktur project kamu
// import '../../models/message_model.dart'; // pastikan path sesuai struktur project kamu

// class ChatDetailScreen extends StatefulWidget {
//   final UserModel currentUser;
//   final UserModel targetUser;

//   const ChatDetailScreen({required this.currentUser, required this.targetUser, Key? key}) : super(key: key);

//   @override
//   _ChatDetailScreenState createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();

//   String get chatId {
//     final ids = [widget.currentUser.uid, widget.targetUser.uid]..sort();
//     return ids.join('_');
//   }

//   // Fungsi untuk membuat chat dan participants jika belum ada
//   Future<void> _createChatIfNotExists() async {
//     try {
//       final chatDoc = FirebaseFirestore.instance.collection('chats').doc(chatId);
//       final chatSnapshot = await chatDoc.get();
    
//       if (!chatSnapshot.exists) {
//         // Jika chat belum ada, buat dokumen baru dan set participants
//         await chatDoc.set({
//           'participants': [widget.currentUser.uid, widget.targetUser.uid],
//         });
//       }
//     } catch (e) {
//       print("Error creating chat: $e");
//       // Tampilkan dialog atau snackbar error jika terjadi kesalahan
//     }
//   }

//   // void _sendMessage() async {
//   //   final message = _messageController.text.trim();
//   //   if (message.isEmpty) return;

//   //   final timestamp = Timestamp.now();

//   //   try {
//   //     // Pastikan chat ada sebelum mengirim pesan
//   //     await _createChatIfNotExists();

//   //     // Kirim pesan ke subkoleksi messages
//   //     await FirebaseFirestore.instance
//   //         .collection('chats')
//   //         .doc(chatId)
//   //         .collection('messages')
//   //         .add({
//   //           'senderId': widget.currentUser.uid,
//   //           'receiverId': widget.targetUser.uid,
//   //           'message': message,
//   //           'timestamp': timestamp,
//   //         });

//   //     _messageController.clear();
//   //   } catch (e) {
//   //     print("Error sending message: $e");
//   //     // Tampilkan dialog atau snackbar error jika terjadi kesalahan
//   //   }
//   // }
// void _sendMessage() async {
//   final message = _messageController.text.trim();
//   if (message.isEmpty) return;

//   final timestamp = Timestamp.now();

//   try {
//     // Pastikan chat ada sebelum mengirim pesan
//     await _createChatIfNotExists();

//     // Kirim pesan ke subkoleksi messages
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .add({
//           'senderId': widget.currentUser.uid,
//           'receiverId': widget.targetUser.uid,
//           'message': message,
//           'timestamp': timestamp,
//         });

//     // Update dokumen chats dengan lastMessage dan lastTimestamp
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .update({
//           'lastMessage': message,
//           'lastTimestamp': timestamp,
//         });

//     _messageController.clear();
//   } catch (e) {
//     print("Error sending message: $e");
//     // Tampilkan dialog atau snackbar error jika terjadi kesalahan
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.targetUser.name),
//       ),
//       body: Column(
//         children: [
//           // 📩 List pesan
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

//                 final messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final data = messages[index].data() as Map<String, dynamic>;
//                     final isMe = data['senderId'] == widget.currentUser.uid;

//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blue[200] : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(data['message']),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // ✍️ Input pesan
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Ketik pesan...',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';

class ChatDetailScreen extends StatefulWidget {
  final UserModel currentUser;
  final UserModel targetUser;
  final String initialMessage; // Menambahkan parameter untuk pesan otomatis

  const ChatDetailScreen({
    required this.currentUser,
    required this.targetUser,
    required this.initialMessage, // Menerima pesan otomatis
    Key? key,
  }) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  String get chatId {
    final ids = [widget.currentUser.uid, widget.targetUser.uid]..sort();
    return ids.join('_');
  }

  Future<void> _createChatIfNotExists() async {
    try {
      final chatDoc = FirebaseFirestore.instance.collection('chats').doc(chatId);
      final chatSnapshot = await chatDoc.get();
      if (!chatSnapshot.exists) {
        await chatDoc.set({
          'participants': [widget.currentUser.uid, widget.targetUser.uid],
        });
      }
    } catch (e) {
      print("Error creating chat: $e");
    }
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final timestamp = Timestamp.now();

    try {
      await _createChatIfNotExists();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': widget.currentUser.uid,
            'receiverId': widget.targetUser.uid,
            'message': message,
            'timestamp': timestamp,
          });

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .update({
            'lastMessage': message,
            'lastTimestamp': timestamp,
          });

      _messageController.clear();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // Set initial message when chat starts
    _messageController.text = widget.initialMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.targetUser.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == widget.currentUser.uid;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(data['message']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
