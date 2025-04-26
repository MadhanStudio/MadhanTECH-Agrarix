import 'package:intl/intl.dart';
import '../../services/firestore_service.dart';


Future<void> verifyAndActivateUser(String qrData) async {
  final Map<String, String> parsed = Map.fromEntries(
    qrData.split('|').map((e) {
      final parts = e.split(':');
      return MapEntry(parts[0], parts[1]);
    }),
  );

  final String userId = parsed['userId']!;
  final DateTime expiryDate = DateFormat('yyyy-MM-dd').parse(parsed['expiryDate']!);

  await FirestoreService().updateSubscriptionStatus(
    userId: userId,
    expiryDate: expiryDate,
  );
}
