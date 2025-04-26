import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart';
import '../course/course_pelatihan_ahli.dart';
import '../admin/advertisement_manager.dart';
import '../trading/admin_verifikasi_quest_screen.dart';
import '../trading/admin_hpp_input_screen.dart';

class HomeAdmin extends StatelessWidget {
  final UserModel user;

  const HomeAdmin({super.key, required this.user});

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
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin Panel - ${user.name}"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () => _logout(context),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Daftar User"),
              Tab(text: "Daftar Course"),
              Tab(text: "Upload Course Ahli"),
              Tab(text: "Manajemen Iklan"),
              Tab(text: "Trading Quest"),
              Tab(text: "Hpp Input"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const UserList(),
            CourseList(user: user),
            CoursePelatihanAhliScreen(user: user),
            AdvertisementManagerScreen(),
            AdminVerifikasiQuestScreen(user: user),
            AdminHppInputScreen(),
          ],
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final imagePath = data["imagePath"];

            return ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    imagePath != null && imagePath.toString().isNotEmpty
                        ? FileImage(File(imagePath))
                        : null,
                child:
                    (imagePath == null || imagePath.toString().isEmpty)
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
              ),
              title: Text(data["name"] ?? ""),
              subtitle: Text("${data["email"]} (${data["role"]})"),
            );
          },
        );
      },
    );
  }
}

class CourseList extends StatelessWidget {
  final UserModel user;

  const CourseList({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("courses_komunitas")
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final imagePath = data["image_path"];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                leading:
                    imagePath != null && imagePath.toString().isNotEmpty
                        ? Image.file(
                          File(imagePath),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.image),
                title: Text(data["title"] ?? "-"),
                subtitle: Text("By ${data["authorName"] ?? '-'}"),
              ),
            );
          },
        );
      },
    );
  }
}
