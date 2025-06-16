import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../messages/chat_detail_screen.dart';
import '../../models/user_model.dart';

class QuestDetailScreen extends StatefulWidget {
  final String questId;
  final Map<String, dynamic> questData;

  const QuestDetailScreen({
    required this.questId, // questId from the document
    required this.questData, // data from the document
    Key? key,
  }) : super(key: key);

  @override
  _QuestDetailScreenState createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  bool _isLoading = false;

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
      final targetUserModel = await getUserModelByUid(widget.questData['ownerId']);

      // Menyiapkan pesan otomatis dengan data quest
      String autoMessage =
          "Saya tertarik dengan Permintaan Anda. Berikut adalah detail permintaan:\n"
          "Barang: ${widget.questData['barang'] ?? 'N/A'}\n"
          "Lokasi: ${widget.questData['lokasi'] ?? 'N/A'}\n"
          "Harga: Rp ${widget.questData['harga'] ?? 0}/kg\n"
          "Jumlah: ${widget.questData['jumlah'] ?? 0} kg\n"
          "Kontak: ${widget.questData['kontak'] ?? 'N/A'}\n\n"
          "Apakah Anda bisa memberikan penjelasan lebih lanjut?";

      // Menambahkan pesan otomatis ke dalam chat
      if (!mounted) return;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal membuka chat. Pastikan pengguna tujuan ada.")));
      }
    }
  }

  Future<void> _acceptQuest(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('quests')
          .doc(widget.questId)
          .update({
        'status': 'diterima',
        'diterimaOleh': user.uid,
        'diterimaTimestamp': Timestamp.now(), // Optional: track when it was accepted
      });
      if (mounted) {
        // Optionally show a success message before navigating, or just navigate.
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Permintaan berhasil diterima!")),
        // );
      }
    } catch (e) {
      print("Error accepting quest: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menerima permintaan: $e")),
        );
      }
      rethrow; // Rethrow to prevent navigation if acceptance fails
    }
  }

  Widget _buildDetailItem(BuildContext context,
      {required IconData icon,
      required String label,
      required String value
      // bool isLink = false, // Parameter not used
      /* VoidCallback? onLinkTap */}) { // Parameter not used
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColorDark, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safe access to questData with default values
    final String nama = widget.questData['nama'] ?? 'Tidak diketahui';
    final String barang = widget.questData['barang'] ?? 'N/A';
    final String lokasi = widget.questData['lokasi'] ?? 'N/A';
    final String kontak = widget.questData['kontak'] ?? 'N/A';
    final dynamic harga = widget.questData['harga']; // Keep as dynamic for now or parse safely
    final dynamic jumlah = widget.questData['jumlah'];

    final String hargaDisplay = harga != null ? "Rp $harga/kg" : "N/A";
    final String jumlahDisplay = jumlah != null ? "$jumlah kg" : "N/A";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Permintaan",
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: const Color(0xFF053B3F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Penawaran",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF053B3F),
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(context, icon: Icons.person_outline, label: "Nama Penjual", value: nama),
                    const Divider(),
                    _buildDetailItem(context, icon: Icons.eco_outlined, label: "Barang", value: barang),
                    const Divider(),
                    _buildDetailItem(context, icon: Icons.location_on_outlined, label: "Lokasi", value: lokasi),
                    const Divider(),
                    _buildDetailItem(context, icon: Icons.phone_outlined, label: "Kontak", value: kontak),
                    const Divider(),
                    _buildDetailItem(context, icon: Icons.attach_money_outlined, label: "Harga Penawaran", value: hargaDisplay),
                    const Divider(),
                    _buildDetailItem(context, icon: Icons.shopping_bag_outlined, label: "Jumlah Permintaan", value: jumlahDisplay),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isLoading 
                    ? Container(
                        width: 24, 
                        height: 24, 
                        padding: const EdgeInsets.all(2.0), 
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)
                      ) 
                    : const Icon(Icons.check_circle_outline),
                label: Text(_isLoading ? "Memproses..." : "Terima & Chat Penjual", style: const TextStyle(fontSize: 16)),
                onPressed: _isLoading
                    ? null // Disable button when loading
                    : () async {
                        if (mounted) setState(() => _isLoading = true);
                        try {
                          await _acceptQuest(context);
                          // _navigateToChat is called after successful acceptance
                          // No need to call it again here if _acceptQuest handles navigation or if it's chained
                          _navigateToChat(context); 
                        } catch (e) {
                          // Error is already handled in _acceptQuest or _navigateToChat
                          print("Operation failed on button press: $e");
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF053B3F), // Primary button color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Bottom padding
          ],
        ),
      ),
    );
  }
}
