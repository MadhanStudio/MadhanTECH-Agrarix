// import 'dart:io';
// import 'package:flutter/material.dart';
// import '../../models/post_model.dart';
// import '../../models/user_model.dart';
// import '../../services/post_service.dart';
// import 'create_post_screen.dart';
// import 'comment_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SocialScreen extends StatefulWidget {
//   const SocialScreen({Key? key, required this.user}) : super(key: key);
//   final UserModel user;

//   @override
//   State<SocialScreen> createState() => _SocialScreenState();
// }

// class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
//   List<PostModel> _allPosts = [];
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _loadPosts();
//   }

//   Future<void> _loadPosts() async {
//     final posts = await PostService().getAllPosts();
//     setState(() => _allPosts = posts);
//   }

//   Future<void> _deletePost(String postId) async {
//     await PostService().deletePost(postId);
//     _loadPosts();
//   }

//   void _toggleLike(PostModel post) async {
//     await PostService().toggleLike(post.id, widget.user.uid);
//     _loadPosts();
//   }

//   void _editPost(PostModel post) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CreatePostScreen(user: widget.user, existingPost: post)),
//     ).then((_) => _loadPosts());
//   }

// Widget _buildPostCard(PostModel post, {bool isMyPost = false}) {
//   return FutureBuilder<DocumentSnapshot>(
//     future: FirebaseFirestore.instance.collection("users").doc(post.userId).get(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       final userData = snapshot.data!.data() as Map<String, dynamic>?;
//       final imagePath = userData?["imagePath"];

//       ImageProvider? profileImageProvider;
//       if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
//         profileImageProvider = FileImage(File(imagePath));
//       }

//       return Card(
//         margin: const EdgeInsets.all(8),
//         child: ListTile(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => CommentScreen(post: post, user: widget.user),
//               ),
//             ).then((_) => _loadPosts());
//           },
//           leading: CircleAvatar(
//             backgroundColor: Colors.grey[300],
//             backgroundImage: profileImageProvider,
//             child: profileImageProvider == null
//                 ? const Icon(Icons.person, color: Colors.white)
//                 : null,
//           ),
//           title: Text(post.username),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(post.content),
//               if (post.imagePath != null && File(post.imagePath!).existsSync())
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Image.file(File(post.imagePath!), height: 150),
//                 ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       post.likes.contains(widget.user.uid)
//                           ? Icons.favorite
//                           : Icons.favorite_border,
//                       color: Colors.red,
//                     ),
//                     onPressed: () => _toggleLike(post),
//                   ),
//                   Text('${post.likes.length} suka'),
//                   const Spacer(),
//                   if (isMyPost) ...[
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () => _editPost(post),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () => _deletePost(post.id),
//                     ),
//                   ],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }



//   @override
//   Widget build(BuildContext context) {
//     final myPosts = _allPosts.where((p) => p.userId == widget.user.uid).toList();
//     final communityPosts = _allPosts;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Beranda"),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: "Postingan Komunitas"),
//             Tab(text: "Postinganku"),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => CreatePostScreen(user: widget.user)),
//           ).then((_) => _loadPosts());
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           RefreshIndicator(
//             onRefresh: _loadPosts,
//             child: ListView.builder(
//               itemCount: communityPosts.length,
//               itemBuilder: (context, index) {
//                 final post = communityPosts[index];
//                 return _buildPostCard(post);
//               },
//             ),
//           ),
//           RefreshIndicator(
//             onRefresh: _loadPosts,
//             child: ListView.builder(
//               itemCount: myPosts.length,
//               itemBuilder: (context, index) {
//                 final post = myPosts[index];
//                 return _buildPostCard(post, isMyPost: true);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import '../../models/post_model.dart';
// import '../../models/user_model.dart';
// import '../../models/advertisement_model.dart';
// import '../../services/post_service.dart';
// import 'create_post_screen.dart';
// import 'comment_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SocialScreen extends StatefulWidget {
//   const SocialScreen({Key? key, required this.user}) : super(key: key);
//   final UserModel user;

//   @override
//   State<SocialScreen> createState() => _SocialScreenState();
// }

// class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
//   List<PostModel> _allPosts = [];
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _loadPosts();
//   }

//   Future<void> _loadPosts() async {
//     final posts = await PostService().getAllPosts();
//     setState(() => _allPosts = posts);
//   }

//   Future<void> _deletePost(String postId) async {
//     await PostService().deletePost(postId);
//     _loadPosts();
//   }

//   Future<AdvertisementModel?> _loadAd() async {
//     final adSnapshot = await FirebaseFirestore.instance.collection("advertisements").limit(1).get();
//     if (adSnapshot.docs.isNotEmpty) {
//       return AdvertisementModel.fromMap(
//         adSnapshot.docs.first.id,
//         adSnapshot.docs.first.data() as Map<String, dynamic>,
//       );
//     }
//     return null;
//   }

//   void _toggleLike(PostModel post) async {
//     await PostService().toggleLike(post.id, widget.user.uid);
//     _loadPosts();
//   }

//   void _editPost(PostModel post) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CreatePostScreen(user: widget.user, existingPost: post)),
//     ).then((_) => _loadPosts());
//   }

//   Widget _buildPostCard(PostModel post, {bool isMyPost = false}) {
//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance.collection("users").doc(post.userId).get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final userData = snapshot.data!.data() as Map<String, dynamic>?;
//         final imagePath = userData?["imagePath"];

//         ImageProvider? profileImageProvider;
//         if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
//           profileImageProvider = FileImage(File(imagePath));
//         }

//         return Card(
//           margin: const EdgeInsets.all(8),
//           child: ListTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CommentScreen(post: post, user: widget.user),
//                 ),
//               ).then((_) => _loadPosts());
//             },
//             leading: CircleAvatar(
//               backgroundColor: Colors.grey[300],
//               backgroundImage: profileImageProvider,
//               child: profileImageProvider == null
//                   ? const Icon(Icons.person, color: Colors.white)
//                   : null,
//             ),
//             title: Text(post.username),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(post.content),
//                 if (post.imagePath != null && File(post.imagePath!).existsSync())
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: Image.file(File(post.imagePath!), height: 150),
//                   ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         post.likes.contains(widget.user.uid)
//                             ? Icons.favorite
//                             : Icons.favorite_border,
//                         color: Colors.red,
//                       ),
//                       onPressed: () => _toggleLike(post),
//                     ),
//                     Text('${post.likes.length} suka'),
//                     const Spacer(),
//                     if (isMyPost) ...[
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () => _editPost(post),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => _deletePost(post.id),
//                       ),
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAdCard() {
//   return FutureBuilder<AdvertisementModel?>(
//     future: _loadAd(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const SizedBox.shrink();
//       }

//       final ad = snapshot.data;
//       if (ad == null) return const SizedBox.shrink();

//       final adImageExists = ad.imagePath != null && File(ad.imagePath!).existsSync();

//       return Card(
//         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         color: Colors.amber[100],
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   const Icon(Icons.campaign, color: Colors.orange),
//                   const SizedBox(width: 8),
//                   Expanded(child: Text(ad.title, style: const TextStyle(fontWeight: FontWeight.bold))),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Text(ad.description),
//               if (adImageExists)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Image.file(
//                     File(ad.imagePath!),
//                     height: 150,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }


//   @override
//   Widget build(BuildContext context) {
//     final myPosts = _allPosts.where((p) => p.userId == widget.user.uid).toList();
//     final communityPosts = _allPosts;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Beranda"),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: "Postingan Komunitas"),
//             Tab(text: "Postinganku"),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => CreatePostScreen(user: widget.user)),
//           ).then((_) => _loadPosts());
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Postingan Komunitas (dengan iklan)
//           RefreshIndicator(
//             onRefresh: _loadPosts,
//             child: ListView.builder(
//               itemCount: communityPosts.length + (communityPosts.length ~/ 3), // tambah jumlah iklan
//               itemBuilder: (context, index) {
//                 // Hitung jumlah iklan sebelum index ini
//                 int adsBefore = index ~/ 4; // setiap 4 index, 1 iklan (3 post + 1 iklan)
//                 int postIndex = index - adsBefore;

//                 if ((index + 1) % 4 == 0) {
//                   // Setiap 4 item, tempatkan iklan
//                   return _buildAdCard();
//                 }

//                 if (postIndex >= communityPosts.length) return const SizedBox(); // safety

//                 final post = communityPosts[postIndex];
//                 return _buildPostCard(post);
//               },
//             ),

//           ),
//           // Postingan Saya (tanpa iklan)
//           RefreshIndicator(
//             onRefresh: _loadPosts,
//             child: ListView.builder(
//               itemCount: myPosts.length,
//               itemBuilder: (context, index) {
//                 final post = myPosts[index];
//                 return _buildPostCard(post, isMyPost: true);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommentScreen(post: post, user: widget.user),
                ),
              ).then((_) => _loadPosts());
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: profileImageProvider,
              child: profileImageProvider == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            title: Text(post.username),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('yyyy-MM-dd HH:mm').format(post.timestamp)),
                Text(post.content),
                if (post.imagePath != null && File(post.imagePath!).existsSync())
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Image.file(File(post.imagePath!), height: 150),
                  ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.likes.contains(widget.user.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => _toggleLike(post),
                    ),
                    Text('${post.likes.length} suka'),
                    const Spacer(),
                    if (isMyPost) ...[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editPost(post),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePost(post.id),
                      ),
                    ],
                  ],
                ),
              ],
            ),
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
            Row(
              children: const [
                Icon(Icons.campaign, color: Colors.orange),
                SizedBox(width: 8),
                Text("Iklan", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(ad.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(ad.description),
            if (ad.imagePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(ad.imagePath!), height: 150, fit: BoxFit.cover),
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
        title: const Text("Beranda"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Postingan Komunitas"),
            Tab(text: "Postinganku"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePostScreen(user: widget.user)),
          ).then((_) => _loadPosts());
        },
        child: const Icon(Icons.add),
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
