// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../models/user_model.dart';

// class ProfileScreen extends StatefulWidget {
//   final UserModel user;

//   const ProfileScreen({super.key, required this.user});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   String? _imagePath;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.user.name);
//     _emailController = TextEditingController(text: widget.user.email);
//     _imagePath = widget.user.imagePath;
//   }

//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _imagePath = picked.path;
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     final updatedUser = {
//       'name': _nameController.text.trim(),
//       'email': _emailController.text.trim(),
//       'imagePath': _imagePath,
//     };

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.user.uid)
//         .update(updatedUser);

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profil Saya')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage:
//                       (_imagePath != null &&
//                               _imagePath!.isNotEmpty &&
//                               File(_imagePath!).existsSync())
//                           ? FileImage(File(_imagePath!))
//                           : null,
//                   child:
//                       (_imagePath == null ||
//                               _imagePath!.isEmpty ||
//                               !File(_imagePath!).existsSync())
//                           ? const Icon(
//                             Icons.person,
//                             size: 60,
//                             color: Colors.white,
//                           )
//                           : null,
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 4,
//                   child: GestureDetector(
//                     onTap: _pickImage,
//                     child: const CircleAvatar(
//                       backgroundColor: Colors.blue,
//                       child: Icon(Icons.edit, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Nama',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.save),
//               label: const Text('Simpan Perubahan'),
//               onPressed: _saveProfile,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../models/user_model.dart';
// import 'package:intl/intl.dart'; // Untuk format tanggal

// class ProfileScreen extends StatefulWidget {
//   final UserModel user;

//   const ProfileScreen({super.key, required this.user});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   String? _imagePath;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.user.name);
//     _emailController = TextEditingController(text: widget.user.email);
//     _imagePath = widget.user.imagePath; // asumsi path lokal juga bisa dari Firestore (opsional)
//   }

//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         _imagePath = picked.path;
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     final updatedUser = {
//       'displayName': _nameController.text.trim(),
//       'email': _emailController.text.trim(),
//       'photoUrl': _imagePath,
//     };

//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.user.uid)
//         .update(updatedUser);

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final subscriptionStatus = widget.user.subscriptionStatus ?? 'inactive';
//     final subscriptionExpiry = widget.user.subscriptionExpiry != null
//         ? DateFormat.yMMMMd().format(widget.user.subscriptionExpiry!)
//         : 'Tidak tersedia';

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profil Saya')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage:
//                       (_imagePath != null &&
//                               _imagePath!.isNotEmpty &&
//                               File(_imagePath!).existsSync())
//                           ? FileImage(File(_imagePath!))
//                           : null,
//                   child: (_imagePath == null ||
//                           _imagePath!.isEmpty ||
//                           !File(_imagePath!).existsSync())
//                       ? const Icon(
//                           Icons.person,
//                           size: 60,
//                           color: Colors.white,
//                         )
//                       : null,
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 4,
//                   child: GestureDetector(
//                     onTap: _pickImage,
//                     child: const CircleAvatar(
//                       backgroundColor: Colors.blue,
//                       child: Icon(Icons.edit, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Nama',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 30),
//             const Divider(),
//             const SizedBox(height: 10),
//             ListTile(
//               leading: const Icon(Icons.verified_user),
//               title: const Text('Status Langganan'),
//               subtitle: Text(subscriptionStatus == 'active'
//                   ? 'Aktif hingga $subscriptionExpiry'
//                   : 'Tidak aktif'),
//               trailing: Icon(
//                 subscriptionStatus == 'active'
//                     ? Icons.check_circle
//                     : Icons.cancel,
//                 color:
//                     subscriptionStatus == 'active' ? Colors.green : Colors.red,
//               ),
//             ),

//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.save),
//               label: const Text('Simpan Perubahan'),
//               onPressed: _saveProfile,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String? _imagePath;
  String subscriptionStatus = 'inactive';
  DateTime? subscriptionExpiry;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _imagePath = widget.user.imagePath;
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .get();

    setState(() {
      subscriptionStatus = userDoc.data()?['subscriptionStatus'] ?? 'inactive';
      final expiryTimestamp = userDoc.data()?['subscriptionExpiry'];
      subscriptionExpiry =
          expiryTimestamp != null
              ? (expiryTimestamp as Timestamp).toDate()
              : null;
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    final updatedUser = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'imagePath': _imagePath,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update(updatedUser);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
  }

  Future<void> _activateSubscription() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final expiryDate = DateTime.now().add(const Duration(days: 30));

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'subscriptionStatus': 'active',
      'subscriptionExpiry': Timestamp.fromDate(expiryDate),
    });

    setState(() {
      subscriptionStatus = 'active';
      subscriptionExpiry = expiryDate;
    });
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Berlangganan Course Pelatihan Ahli'),
            content: const Text(
              'Dengan berlangganan seharga Rp0 (dummy), kamu bisa mengakses semua course pelatihan ahli selama 30 hari.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _activateSubscription();
                  Navigator.pop(ctx);
                  final Uri uri = Uri.parse("https://play.google.com/store/apps/details?id=com.example.app");
                  await launchUrl(uri, mode: LaunchMode.externalApplication);

                },
                child: const Text('Bayar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionText =
        subscriptionStatus == 'active'
            ? 'Aktif hingga ${DateFormat.yMMMMd().format(subscriptionExpiry!)}'
            : 'Tidak aktif';

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      (_imagePath != null &&
                              _imagePath!.isNotEmpty &&
                              File(_imagePath!).existsSync())
                          ? FileImage(File(_imagePath!))
                          : null,
                  child:
                      (_imagePath == null ||
                              _imagePath!.isEmpty ||
                              !File(_imagePath!).existsSync())
                          ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                          : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Status Langganan'),
              subtitle: Text(subscriptionText),
              trailing: Icon(
                subscriptionStatus == 'active'
                    ? Icons.check_circle
                    : Icons.cancel,
                color:
                    subscriptionStatus == 'active' ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Simpan Perubahan'),
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.workspace_premium),
              label: const Text('Langganan Premium'),
              onPressed:
                  subscriptionStatus == 'active'
                      ? null
                      : _showSubscriptionDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
