// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../models/user_model.dart';
// import '../auth/login_screen.dart';
// import '../course/course_pelatihan_ahli.dart';
// import '../admin/advertisement_manager.dart';
// import '../trading/admin_verifikasi_quest_screen.dart';
// import '../trading/admin_hpp_input_screen.dart';

// class HomeAdmin extends StatelessWidget {
//   final UserModel user;

//   const HomeAdmin({super.key, required this.user});

//   void _logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Admin Panel - ${user.name}"),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.logout),
//               tooltip: 'Logout',
//               onPressed: () => _logout(context),
//             ),
//           ],
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: "Daftar User"),
//               Tab(text: "Daftar Course"),
//               Tab(text: "Upload Course Ahli"),
//               Tab(text: "Manajemen Iklan"),
//               Tab(text: "Trading Quest"),
//               Tab(text: "Hpp Input"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             const UserList(),
//             CourseList(user: user),
//             CoursePelatihanAhliScreen(user: user),
//             AdvertisementManagerScreen(),
//             AdminVerifikasiQuestScreen(user: user),
//             AdminHppInputScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class UserList extends StatelessWidget {
//   const UserList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection("users").snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return const Center(child: CircularProgressIndicator());

//         final docs = snapshot.data!.docs;

//         return ListView.builder(
//           itemCount: docs.length,
//           itemBuilder: (context, index) {
//             final data = docs[index].data() as Map<String, dynamic>;
//             final imagePath = data["imagePath"];

//             return ListTile(
//               leading: CircleAvatar(
//                 radius: 24,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage:
//                     imagePath != null && imagePath.toString().isNotEmpty
//                         ? FileImage(File(imagePath))
//                         : null,
//                 child:
//                     (imagePath == null || imagePath.toString().isEmpty)
//                         ? const Icon(Icons.person, color: Colors.white)
//                         : null,
//               ),
//               title: Text(data["name"] ?? ""),
//               subtitle: Text("${data["email"]} (${data["role"]})"),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class CourseList extends StatelessWidget {
//   final UserModel user;

//   const CourseList({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream:
//           FirebaseFirestore.instance
//               .collection("courses_komunitas")
//               .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return const Center(child: CircularProgressIndicator());

//         final docs = snapshot.data!.docs;

//         return ListView.builder(
//           itemCount: docs.length,
//           itemBuilder: (context, index) {
//             final data = docs[index].data() as Map<String, dynamic>;
//             final imagePath = data["image_path"];

//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: ListTile(
//                 leading:
//                     imagePath != null && imagePath.toString().isNotEmpty
//                         ? Image.file(
//                           File(imagePath),
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         )
//                         : const Icon(Icons.image),
//                 title: Text(data["title"] ?? "-"),
//                 subtitle: Text("By ${data["authorName"] ?? '-'}"),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
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
        body: Column(
          children: [
            // Header section with dark teal background
            Container(
              color: const Color(0xFF053B3F),
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  // Logo and logout row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App logo
                      Image.asset(
                        'assets/images/agrarix_logo.png', // Replace with your app logo
                        height: 40,
                        width: 40,
                      ),
                      // Logout button
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        tooltip: 'Logout',
                        onPressed: () => _logout(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Admin panel text and user name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin Panel',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Color(0xFFF3BC40), // Golden yellow
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Curved transition to white section
            Container(
              height: 30,
              decoration: const BoxDecoration(color: Color(0xFF053B3F)),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Custom TabBar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TabBar(
                isScrollable: true,
                labelColor: const Color(0xFF053B3F),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFFF3BC40),
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: "Daftar User"),
                  Tab(text: "Daftar Course"),
                  Tab(text: "Upload Course Ahli"),
                  Tab(text: "Manajemen Iklan"),
                  Tab(text: "Trading Quest"),
                  Tab(text: "Hpp Input"),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: Container(
                color: Colors.white,
                child: TabBarView(
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
            ),
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
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF053B3F)),
          );

        final docs = snapshot.data!.docs;

        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Pengguna',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF053B3F),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final imagePath = data["imagePath"];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(
                            0xFF053B3F,
                          ).withOpacity(0.1),
                          backgroundImage:
                              imagePath != null &&
                                      imagePath.toString().isNotEmpty
                                  ? FileImage(File(imagePath))
                                  : null,
                          child:
                              (imagePath == null ||
                                      imagePath.toString().isEmpty)
                                  ? const Icon(
                                    Icons.person,
                                    color: Color(0xFF053B3F),
                                  )
                                  : null,
                        ),
                        title: Text(
                          data["name"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF053B3F),
                          ),
                        ),
                        subtitle: Text(
                          "${data["email"]} (${data["role"]})",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF3BC40),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF053B3F)),
          );

        final docs = snapshot.data!.docs;

        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Course',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF053B3F),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final imagePath = data["image_path"];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          // Course image
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                            ),
                            child:
                                imagePath != null &&
                                        imagePath.toString().isNotEmpty
                                    ? Image.file(
                                      File(imagePath),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                    : Container(
                                      width: 100,
                                      height: 100,
                                      color: const Color(
                                        0xFF053B3F,
                                      ).withOpacity(0.1),
                                      child: const Icon(
                                        Icons.image,
                                        color: Color(0xFF053B3F),
                                        size: 40,
                                      ),
                                    ),
                          ),
                          // Course info
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data["title"] ?? "-",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF053B3F),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 14,
                                        color: Color(0xFFF3BC40),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "By ${data["authorName"] ?? '-'}",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF053B3F),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Text(
                                          'View Details',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
