import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firestore_service.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  @override
  _ConfirmPaymentScreenState createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  final TextEditingController _qrController = TextEditingController();
  String status = "";

  Future<void> _verifyAndActivate() async {
    final qrText = _qrController.text.trim();

    try {
      final parts = qrText.split('|');
      final Map<String, String> parsed = {
        for (var part in parts)
          part.split(':')[0]: part.split(':')[1],
      };

      final String userId = parsed['userId']!;
      final DateTime expiryDate = DateFormat('yyyy-MM-dd').parse(parsed['expiryDate']!);

      await FirestoreService().updateSubscriptionStatus(
        userId: userId,
        expiryDate: expiryDate,
      );

      setState(() {
        status = "Langganan berhasil diaktifkan untuk user $userId sampai $expiryDate";
      });
    } catch (e) {
      setState(() {
        status = "Format QR tidak valid atau gagal aktivasi: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Konfirmasi Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tempel hasil scan QR di bawah ini:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _qrController,
              maxLines: 3,
              decoration: InputDecoration(hintText: 'paymentId:...|userId:...|expiryDate:...'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyAndActivate,
              child: Text('Aktifkan Langganan'),
            ),
            SizedBox(height: 20),
            Text(status, style: TextStyle(fontSize: 14, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
