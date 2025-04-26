import 'package:agrarixx/models/user_model.dart';
import 'package:agrarixx/screens/home/home_screen.dart';
import 'package:agrarixx/screens/profile/profile_screen.dart';
import 'package:agrarixx/screens/social/social_screen.dart';
import 'package:agrarixx/screens/trading/my_quest_screen.dart';
import 'package:agrarixx/screens/trading/quest_list_by_barang.dart';
import 'package:agrarixx/screens/trading/approved_quest_list_screen.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agrarixx/screens/course/course_screen.dart';

class Navbar extends StatefulWidget {
  final UserModel user;
  final String barangLabel; // tambah ini

  Navbar({Key? key, required this.user, required this.barangLabel}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  late List<Widget> pages;

@override
  void initState() {
    super.initState();
    pages = [ // ✅
      ApprovedListQuestScreen(user: widget.user),
      CourseScreen(user: widget.user),
      SocialScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];
  }


  final List<IconData> icons = [
    Icons.home,
    Icons.space_dashboard,
    Icons.chat_bubble,
    Icons.account_circle,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            bool isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 25 : 0,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xff003333) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  icons[index],
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
