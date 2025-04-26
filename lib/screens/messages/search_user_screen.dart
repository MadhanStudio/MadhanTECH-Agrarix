import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../messages/chat_detail_screen.dart';
import 'dart:io';

class SearchUserScreen extends StatefulWidget {
  final UserModel user;

  const SearchUserScreen({required this.user, Key? key}) : super(key: key);

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  String _searchQuery = '';
  final TextEditingController _controller = TextEditingController();
  List<UserModel> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch() async {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .get();

    final users =
        snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .where((u) => u.uid != widget.user.uid)
            .toList();

    setState(() {
      _searchQuery = query;
      _searchResults = users;
      _isLoading = false;
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _searchQuery = '';
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Search Bar + Tombol Search
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Cari nama pengguna...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon:
                        _controller.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _performSearch, child: Text('Search')),
            ],
          ),
        ),

        // 🔄 Loading atau hasil pencarian
        Expanded(
          child:
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                  ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'Masukkan nama untuk mencari.'
                          : 'Tidak ada pengguna ditemukan.',
                    ),
                  )
                  : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              user.imagePath.isNotEmpty
                                  ? (user.imagePath.startsWith('http')
                                      ? NetworkImage(user.imagePath)
                                      : FileImage(File(user.imagePath))
                                          as ImageProvider)
                                  : null,
                          child:
                              user.imagePath.isEmpty
                                  ? Icon(Icons.person)
                                  : null,
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChatDetailScreen(
                                    currentUser: widget.user,
                                    targetUser: user,
                                    initialMessage:
                                        '', // Provide an appropriate initial message here
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
