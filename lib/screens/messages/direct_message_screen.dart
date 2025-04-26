import 'package:flutter/material.dart';
import 'search_user_screen.dart';
import 'chat_list_screen.dart';
import '../../models/user_model.dart'; // pastikan path sesuai struktur project kamu

class DirectMessageScreen extends StatefulWidget {
  final UserModel user;

  DirectMessageScreen({required this.user});

  @override
  _DirectMessageScreenState createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Message'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.search), text: 'Cari Pengguna'),
            Tab(icon: Icon(Icons.chat), text: 'Direct Message'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SearchUserScreen(
            user: widget.user,
          ), // Pass the UserModel object instead of the UID string
          ChatListScreen(currentUser: widget.user),
        ],
      ),
    );
  }
}
