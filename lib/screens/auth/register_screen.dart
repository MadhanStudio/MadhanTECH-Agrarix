import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String name = "";
  String email = "";
  String password = "";
  String role = "user"; // atau "admin"

  bool isLoading = false;

  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      UserModel? user = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      setState(() => isLoading = false);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Register berhasil sebagai ${user.role}")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Register gagal!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Nama"),
                        onChanged: (val) => name = val,
                        validator:
                            (val) =>
                                val!.isEmpty ? "Nama tidak boleh kosong" : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Email"),
                        onChanged: (val) => email = val,
                        validator:
                            (val) =>
                                val!.isEmpty
                                    ? "Email tidak boleh kosong"
                                    : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        obscureText: true,
                        onChanged: (val) => password = val,
                        validator:
                            (val) =>
                                val!.length < 6 ? "Minimal 6 karakter" : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: role,
                        items: const [
                          DropdownMenuItem(value: "user", child: Text("User")),
                          DropdownMenuItem(
                            value: "admin",
                            child: Text("Admin"),
                          ),
                        ],
                        onChanged: (val) => role = val!,
                        decoration: const InputDecoration(labelText: "Role"),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: register,
                        child: const Text("Register"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Sudah punya akun? Login"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
