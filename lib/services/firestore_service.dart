import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateSubscriptionStatus({
    required String userId,
    required DateTime expiryDate,
  }) async {
    await _db.collection('users').doc(userId).update({
      'subscriptionStatus': 'active',
      'subscriptionExpiry': expiryDate.toIso8601String(),
    });
  }

}
