import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import 'package:intl/intl.dart'; // Untuk format timestamp

class ChatDetailScreen extends StatefulWidget {
  final UserModel currentUser;
  final UserModel targetUser;
  final String initialMessage;

  const ChatDetailScreen({
    required this.currentUser,
    required this.targetUser,
    required this.initialMessage,
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
                    final timestamp = (data['timestamp'] as Timestamp).toDate();
                    final timeString = DateFormat('HH:mm').format(timestamp);

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFF013133) : const Color(0xFFFEEEDA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['message'],
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              timeString,
                              style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
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
