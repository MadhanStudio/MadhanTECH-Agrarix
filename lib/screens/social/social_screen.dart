import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../models/advertisement_model.dart';
import '../../services/post_service.dart';
import 'create_post_screen.dart';
import 'comment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../messages/direct_message_screen.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
  List<PostModel> _allPosts = [];
  List<AdvertisementModel> _ads = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadPosts(),
      _loadAllAds(),
    ]);
  }

  Future<void> _loadPosts() async {
    final posts = await PostService().getAllPosts();
    setState(() => _allPosts = posts);
  }

  Future<void> _loadAllAds() async {
    final adSnapshot = await FirebaseFirestore.instance.collection("advertisements").get();
    setState(() {
      _ads = adSnapshot.docs
          .map((doc) => AdvertisementModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _deletePost(String postId) async {
    await PostService().deletePost(postId);
    _loadPosts();
  }

  void _toggleLike(PostModel post) async {
    await PostService().toggleLike(post.id, widget.user.uid);
    _loadPosts();
  }

  void _editPost(PostModel post) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatePostScreen(user: widget.user, existingPost: post)),
    ).then((_) => _loadPosts());
  }

  Widget _buildPostCard(PostModel post, {bool isMyPost = false}) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("users").doc(post.userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        final imagePath = userData?["imagePath"];

        ImageProvider? profileImageProvider;
        if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
          profileImageProvider = FileImage(File(imagePath));
        }

        bool isLiked = post.likes.contains(widget.user.uid);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade50,
                      backgroundImage: profileImageProvider,
                      child: profileImageProvider == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (isMyPost) ...[
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _editPost(post),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () => _deletePost(post.id),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (post.imagePath != null && File(post.imagePath!).existsSync())
                Container(
                  width: double.infinity,
                  height: 400,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.file(
                      File(post.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleLike(post),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 24,
                        color: isLiked ? Colors.red : const Color(0xFF013133),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommentScreen(post: post, user: widget.user),
                          ),
                        ).then((_) => _loadPosts());
                      },
                      child: const Icon(
                        Icons.comment,
                        size: 24,
                        color: Color(0xFF013133),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${post.likes.length} suka',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildAdCard(AdvertisementModel ad) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.yellow[100],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Bagian iklan teks + icon
    Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.black), // Border hitam
      //   borderRadius: BorderRadius.circular(8),  // Sudut agak bulat
      // ),
      padding: const EdgeInsets.all(8),
      child: const Row(
        children: const [
          Icon(Icons.campaign, color: Colors.orange),
          SizedBox(width: 8),
          Text(
            "Iklan",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),

    const SizedBox(height: 6),
    Text(ad.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    const SizedBox(height: 4),
    Text(ad.description),

    // Bagian gambar iklan
    if (ad.imagePath != null)
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black), // Border hitam di gambar
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Image.file(
                File(ad.imagePath!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
  ],
),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myPosts = _allPosts.where((p) => p.userId == widget.user.uid).toList();
    final communityPosts = _allPosts;

  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,

      title: const Text("Media Social"),

      actions: [
        IconButton(
          icon: const Icon(Icons.add_to_photos_outlined,
                  color: Colors.black, size: 24),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreatePostScreen(user: widget.user)),
            ).then((_) => _loadPosts());
          },
        ),
        IconButton(
              icon: Icon(Icons.send, color: Colors.black, size: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DirectMessageScreen(user: widget.user),
                  ),
                );
              },
            ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: "Beranda"),
          Tab(text: "Postinganku"),
        ],
      ),
    ),
    body: TabBarView(
      controller: _tabController,
      children: [
        // Postingan Komunitas (dengan iklan rotasi)
        RefreshIndicator(
          onRefresh: _loadInitialData,
          child: ListView.builder(
            itemCount: communityPosts.length + (communityPosts.length ~/ 3),
            itemBuilder: (context, index) {
              int adsBefore = index ~/ 4;
              int postIndex = index - adsBefore;

              // Tampilkan iklan setiap 4 item
              if ((index + 1) % 4 == 0 && _ads.isNotEmpty) {
                final adIndex = adsBefore % _ads.length;
                final ad = _ads[adIndex];
                return _buildAdCard(ad);
              }

              if (postIndex >= communityPosts.length) return const SizedBox();

              final post = communityPosts[postIndex];
              return _buildPostCard(post);
            },
          ),
        ),
        // Postingan Saya (tanpa iklan)
        RefreshIndicator(
          onRefresh: _loadPosts,
          child: ListView.builder(
            itemCount: myPosts.length,
            itemBuilder: (context, index) {
              final post = myPosts[index];
              return _buildPostCard(post, isMyPost: true);
            },
          ),
        ),
      ],
    ),
  );

  }
}
