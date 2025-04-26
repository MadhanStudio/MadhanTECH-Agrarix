import 'dart:io';
import 'package:agrarixx/screens/auth/login_screen.dart';
import 'package:agrarixx/screens/profile/edit_profile.dart';
import 'package:agrarixx/screens/trading/my_quest_screen.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      final appDir =
          await getApplicationDocumentsDirectory(); // folder permanen
      final fileName = const Uuid().v4(); // nama file unik
      final savedImage = await File(
        picked.path,
      ).copy('${appDir.path}/$fileName.jpg');

      setState(() {
        _imagePath = savedImage.path; // simpan path baru
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
    final subscriptionText =
        subscriptionStatus == 'active'
            ? 'Aktif hingga ${DateFormat.yMMMMd().format(subscriptionExpiry!)}'
            : 'Tidak aktif';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              Center(
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                  ),
                  child: Center(
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
              // ),
              SizedBox(height: 10.h),
              Text(
                widget.user.name,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),
              Container(
                width: 250.w,
                height: 30.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditProfilePage(user: widget.user),
                      ),
                    );
                  },
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: const Color(0xFF6D6D6D),
                      fontSize: 12.sp,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFF013133)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(4, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Petani Go-Digital',
                            style: TextStyle(
                              color: const Color(0xFF013133),
                              fontSize: 28.sp,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.56,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Berlangganan selama ',
                                style: TextStyle(
                                  color: const Color(0xFF013133),
                                  fontSize: 13.sp,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.26,
                                ),
                              ),
                              Text(
                                '30 hari',
                                style: TextStyle(
                                  color: const Color(0xFFF7C03F),
                                  fontSize: 13.sp,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.26,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          _buildFeatureItem(
                            'Kursus/Pelatihan yang dapat diakses kapan saja dan di mana saja',
                          ),
                          SizedBox(height: 10.h),
                          _buildFeatureItem(
                            'Prioritas bantuan secara personal selama 24/7',
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MyQuestScreen(user: widget.user),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(
                        15.r,
                      ), // Biar ripple efek ikut radius
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        margin: EdgeInsets.only(
                          left: 15.w,
                          right: 15.w,
                          bottom: 15.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Text(
                            'Rp. 29.999/30 hari - Berlangganan Sekarang',
                            style: TextStyle(
                              color: const Color(0xFF013133),
                              fontSize: 13.sp,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                width: 250.w,
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF013133)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MyQuestScreen(user: widget.user),
                      ),
                    );
                  },
                  child: Text(
                    'My Quest',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.36,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: 175.w,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF013133),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout, color: Color(0xFFFEEEDA)),
                  label: Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFEEEDA),
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

Widget _buildFeatureItem(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Color(0xFF004D40)),
        ),
        child: Icon(Icons.check, color: Color(0xFF004D40), size: 16.sp),
      ),
      SizedBox(width: 10.w),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 11.sp,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.22,
          ),
        ),
      ),
    ],
  );
}
