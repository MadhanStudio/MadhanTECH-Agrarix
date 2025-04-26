import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    String role = "user", // default
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          role: role,
          imagePath: "", // Provide a default or appropriate value for imagePath
        );

        await _firestore.collection("users").doc(user.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      print("Error in register: $e");
    }
    return null;
  }

  // Login
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection("users").doc(user.uid).get();
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error in login: $e");
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
