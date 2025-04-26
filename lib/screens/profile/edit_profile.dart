import 'dart:io';
import 'package:agrarixx/screens/auth/login_screen.dart';
import 'package:agrarixx/screens/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final UserModel user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String? _imagePath;
  String subscriptionStatus = 'inactive';
  DateTime? subscriptionExpiry;
  bool _isScreenUtilInit = false;

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
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = const Uuid().v4();
      final savedImage = await File(
        picked.path,
      ).copy('${appDir.path}/$fileName.jpg');

      setState(() {
        _imagePath = savedImage.path;
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

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
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
                  final Uri uri = Uri.parse(
                    "https://play.google.com/store/apps/details?id=com.example.app",
                  );
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: const Text('Bayar'),
              ),
            ],
          ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isScreenUtilInit) {
      ScreenUtil.init(context);
      _isScreenUtilInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade50,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
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
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: Color(0xFF004D40),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              ProfileTextField(
                controller: _nameController,
                icon: Icons.person_outline,
                hintText: 'Full Name',
              ),
              SizedBox(height: 16.h),
              ProfileTextField(
                controller: _emailController,
                icon: Icons.email_outlined,
                hintText: 'Email',
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Perubahan'),
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                    ), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final TextInputType keyboardType;

  const ProfileTextField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.grey, size: 20.sp),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
      ),
    );
  }
}
