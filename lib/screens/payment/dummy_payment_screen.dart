import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';

class DummyPaymentScreen extends StatelessWidget {
  final UserModel user;

  DummyPaymentScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final DateTime expiryDate = DateTime.now().add(Duration(days: 30));
    final String formattedDate = DateFormat('yyyy-MM-dd').format(expiryDate);

    final String qrData =
        'paymentId:DUMMY123|userId:${user.uid}|expiryDate:$formattedDate';

    return Scaffold(
      appBar: AppBar(title: Text('Pembayaran Langganan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Silakan Scan QR Code untuk Langganan',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            QrImageView(data: qrData, version: QrVersions.auto, size: 250.0),
            SizedBox(height: 20),
            Text(
              'Valid Sampai: $formattedDate',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
