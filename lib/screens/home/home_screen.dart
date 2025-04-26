import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'home_admin.dart';
import 'home_user.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return user.role == "admin" ? HomeAdmin(user: user) : HomeUser(user: user);
  }
}
