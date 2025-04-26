import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class MessageService {
  final _messages = FirebaseFirestore.instance.collection('messages');

  Future<void> sendMessage(MessageModel message) async {
    await _messages.add(message.toMap());
  }

  Stream<List<MessageModel>> getMessages(String currentUserId, String otherUserId) {
    return _messages
      .where('senderId', whereIn: [currentUserId, otherUserId])
      .where('receiverId', whereIn: [currentUserId, otherUserId])
      .orderBy('timestamp')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return MessageModel.fromMap(data, doc.id);
      }).toList());
  }

  // Untuk mendapatkan daftar user yang pernah chatting
  Future<List<String>> getChatHistoryUserIds(String userId) async {
    final snapshot = await _messages
      .where('senderId', isEqualTo: userId)
      .get();

    final receiverIds = snapshot.docs.map((doc) => doc['receiverId'] as String).toSet().toList();
    return receiverIds;
  }
}
