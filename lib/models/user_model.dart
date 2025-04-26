// class UserModel {
//   final String uid;
//   final String name;
//   final String email;
//   final String role;
//   final String imagePath; // tambahkan ini

//   UserModel({
//     required this.uid,
//     required this.name,
//     required this.email,
//     required this.role,
//     required this.imagePath,
//   });

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'],
//       name: map['name'],
//       email: map['email'],
//       role: map['role'],
//       imagePath: map['imagePath'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'name': name,
//       'email': email,
//       'role': role,
//       'imagePath': imagePath,
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String imagePath;
  final String subscriptionStatus; // 'active' atau 'inactive'
  final DateTime? subscriptionExpiry;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.imagePath,
    this.subscriptionStatus = 'inactive',
    this.subscriptionExpiry,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    // Pastikan untuk memeriksa apakah map['subscriptionExpiry'] adalah Timestamp atau String
    DateTime? expiryDate;
    
    if (map['subscriptionExpiry'] != null) {
      if (map['subscriptionExpiry'] is Timestamp) {
        // Jika subscriptionExpiry adalah Timestamp
        expiryDate = (map['subscriptionExpiry'] as Timestamp).toDate();
      } else if (map['subscriptionExpiry'] is String) {
        // Jika subscriptionExpiry adalah String yang berupa tanggal
        expiryDate = DateTime.tryParse(map['subscriptionExpiry']);
      }
    }

    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
      imagePath: map['imagePath'] ?? '',
      subscriptionStatus: map['subscriptionStatus'] ?? 'inactive',
      subscriptionExpiry: expiryDate,  // Menggunakan DateTime jika valid
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'imagePath': imagePath,
      'subscriptionStatus': subscriptionStatus,
      'subscriptionExpiry': subscriptionExpiry,
    };
  }
}
