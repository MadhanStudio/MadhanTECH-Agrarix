// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'quest_detail_screen.dart';

// class QuestListByBarang extends StatelessWidget {
//   final String barangLabel;

//   const QuestListByBarang({required this.barangLabel});

//   // Function untuk membuka URL
//   void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Tidak bisa membuka URL: $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     return StreamBuilder<QuerySnapshot>(
//       stream:
//           FirebaseFirestore.instance
//               .collection('quests')
//               .where('status', isEqualTo: 'approved')
//               .where('barang', isEqualTo: barangLabel)
//               .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData)
//           return Center(child: CircularProgressIndicator());

//         final docs = snapshot.data!.docs;

//         // Filter untuk tidak menampilkan quest milik sendiri
//         final filteredDocs =
//             docs.where((doc) {
//               return doc['ownerId'] != currentUser!.uid;
//             }).toList();

//         if (filteredDocs.isEmpty) {
//           return Center(child: Text("Belum ada quest untuk $barangLabel"));
//         }

//         return ListView.builder(
//           itemCount: filteredDocs.length,
//           itemBuilder: (context, index) {
//             final data = filteredDocs[index].data() as Map<String, dynamic>;
//             final id = filteredDocs[index].id;

//             return ListTile(
//               title: Text('${data['nama']}'), // Misal title-nya barang
//               // Removed redundant Text widget causing the error
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       _launchURL(data['lokasi']);
//                     },
//                     child: Text(
//                       'Lihat Lokasi',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text('Kontak: ${data['kontak']}'),
//                   Text('Tekan untuk detail lebih lanjut'),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (_) => QuestDetailScreen(questId: id, questData: data),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'quest_detail_screen.dart';

class QuestListByBarang extends StatelessWidget {
  final String barangLabel;

  const QuestListByBarang({required this.barangLabel});

  // Function untuk membuka URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak bisa membuka URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        color: const Color(0xFF053B3F), // Dark teal background
        child: Column(
          children: [
            // Header section with location
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/agrarix_logo.png', // Make sure to add this asset
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(height: 10),
                  // Location text
                  // const Text(
                  //   'Lokasi saat ini',
                  //   style: TextStyle(color: Colors.white, fontSize: 16),
                  // ),
                  // const SizedBox(height: 5),
                  // // City name
                  // const Text(
                  //   'Malang, Indonesia',
                  //   style: TextStyle(
                  //     color: Color(0xFFF3BC40), // Golden yellow
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),

            // Commodity info card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5), // Light gray
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Commodity type
                      Text(
                        'Komoditas Pilihan: $barangLabel',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Government purchase price
                      const Text(
                        'Harga Pembelian Pemerintah:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      // Price
                      const Text(
                        'Rp. 8.000/kg',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF053B3F), // Dark teal
                        ),
                      ),
                    ],
                  ),
                  // Commodity image
                  Image.asset(
                    'assets/logo/${barangLabel.toLowerCase()}.png', // Dynamic based on commodity
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
            ),

            // Wave-like shape divider
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

            // Commodity offers section
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Penawaran Komoditas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF053B3F),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Firestore data
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('quests')
                                .where('status', isEqualTo: 'approved')
                                .where('barang', isEqualTo: barangLabel)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final docs = snapshot.data!.docs;
                          final filteredDocs =
                              docs.where((doc) {
                                return doc['ownerId'] != currentUser!.uid;
                              }).toList();

                          if (filteredDocs.isEmpty) {
                            return Center(
                              child: Text(
                                "Belum ada penawaran untuk $barangLabel",
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: filteredDocs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  filteredDocs[index].data()
                                      as Map<String, dynamic>;
                              final id = filteredDocs[index].id;

                              return CommodityOfferCard(
                                username: data['nama'] ?? 'Pengguna',
                                location: 'lokasi',
                                price: 'Rp. ${data['harga']}/kg',
                                amount: '${data['jumlah']} kg',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => QuestDetailScreen(
                                            questId: id,
                                            questData: data,
                                          ),
                                    ),
                                  );
                                },
                                onLocationTap: () {
                                  _launchURL(data['lokasi']);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
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

class CommodityOfferCard extends StatelessWidget {
  final String username;
  final String location;
  final String price;
  final String amount;
  final VoidCallback onTap;
  final VoidCallback onLocationTap;

  const CommodityOfferCard({
    Key? key,
    required this.username,
    required this.location,
    required this.price,
    required this.amount,
    required this.onTap,
    required this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Price and amount row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Harga Penawaran:',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF053B3F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Permintaan:',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            amount,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // User and location row
                Row(
                  children: [
                    // User profile
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          username.isNotEmpty ? username[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: onLocationTap,
                            child: Text(
                              location,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
