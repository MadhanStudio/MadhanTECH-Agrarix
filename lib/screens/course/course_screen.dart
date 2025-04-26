import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'course_komunitas.dart';
import 'course_pelatihan_ahli.dart';

class CourseScreen extends StatelessWidget {
  final UserModel user;

  const CourseScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Menu Course"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Course Komunitas"),
              Tab(text: "Course Pelatihan Ahli"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CourseKomunitasScreen(user: user),
            CoursePelatihanAhliScreen(user: user),
          ],
        ),
      ),
    );
  }
}
