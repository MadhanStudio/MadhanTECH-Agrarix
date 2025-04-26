import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

// Contoh menambah data
Future<void> addUser() async {
  try {
    await firestore.collection('users').add({
      'name': 'John Doe',
      'email': 'johndoe@example.com',
    });
  } catch (e) {
    print('Error: $e');
  }
}

// Contoh mengambil data
Future<void> getUsers() async {
  try {
    QuerySnapshot snapshot = await firestore.collection('users').get();
    for (var doc in snapshot.docs) {
      print(doc.data());
    }
  } catch (e) {
    print('Error: $e');
  }
}
