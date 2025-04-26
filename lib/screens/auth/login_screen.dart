// import 'package:flutter/material.dart';
// import '../../models/user_model.dart';
// import '../../services/auth_service.dart';
// import 'register_screen.dart';
// import '../home/home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _authService = AuthService();

//   String email = "";
//   String password = "";

//   bool isLoading = false;

//   void login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => isLoading = true);
//       UserModel? user = await _authService.login(email, password);
//       setState(() => isLoading = false);

//       if (user != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Login berhasil sebagai ${user.role}")),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => HomeScreen(user: user),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Login gagal! Email/Password salah.")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: "Email"),
//                       onChanged: (val) => email = val,
//                       validator: (val) =>
//                           val!.isEmpty ? "Email tidak boleh kosong" : null,
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: "Password"),
//                       obscureText: true,
//                       onChanged: (val) => password = val,
//                       validator: (val) => val!.length < 6
//                           ? "Minimal 6 karakter"
//                           : null,
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: login,
//                       child: const Text("Login"),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => const RegisterScreen()),
//                         );
//                       },
//                       child: const Text("Belum punya akun? Register"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';
import '../home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambahkan ini untuk reset password

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String email = "";
  String password = "";

  bool isLoading = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      UserModel? user = await _authService.login(email, password);
      setState(() => isLoading = false);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login berhasil sebagai ${user.role}")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(user: user),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login gagal! Email/Password salah.")),
        );
      }
    }
  }

  void forgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController emailController = TextEditingController();
        return AlertDialog(
          title: Text('Reset Password'),
          content: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Masukkan Email Anda',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Link reset password telah dikirim ke email!')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal mengirim email reset password.')),
                    );
                  }
                }
              },
              child: Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Email"),
                      onChanged: (val) => email = val,
                      validator: (val) =>
                          val!.isEmpty ? "Email tidak boleh kosong" : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      validator: (val) => val!.length < 6
                          ? "Minimal 6 karakter"
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: forgotPassword,
                        child: const Text("Lupa Password?"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: login,
                      child: const Text("Login"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text("Belum punya akun? Register"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
