import '../social/social_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart';
import '../course/course_screen.dart';
import '../profile/profile_screen.dart';
import '../messages/direct_message_screen.dart';
import '../trading/upload_quest_screen.dart';
import '../trading/approved_quest_list_screen.dart';
import '../trading/my_quest_screen.dart';

class HomeUser extends StatelessWidget {
  final UserModel user;

  const HomeUser({super.key, required this.user});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda Petani"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.school),
              label: const Text("Lihat Course Komunitas"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseScreen(user: user),
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("Lihat Profil"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: user),
                  ),
                );
              },
            ),

            // 🔥 Tambahan tombol navigasi Social Media
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text("Social Media"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SocialScreen(user: user),
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text("Upload Trading Quest"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadQuestScreen(user: user),
                  ),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text("List Trading Quest"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ApprovedListQuestScreen()),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text("My Trading Quest"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyQuestScreen(user: user)),
                );
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text("Direct Message"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DirectMessageScreen(user: user),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
