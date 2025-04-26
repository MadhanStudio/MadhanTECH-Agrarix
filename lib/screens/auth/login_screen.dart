import 'package:agrarixx/screens/navbar/navbar.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';
import '../home/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _emailError = false;
  bool _passwordError = false;
  bool _formComplete = false;
  bool _isScreenUtilInit = false;

  String email = "";
  String password = "";

  bool isLoading = false;
  bool _isPasswordVisible = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      UserModel? user = await _authService.login(email, password);
      setState(() => isLoading = false);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login berhasil sebagai ${user.role}")),
        );

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => Navbar(user: user, barangLabel: 'Default Label')),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login gagal! Email/Password salah.")),
        );
      }
    }
  }

  void _validateForm() {
    setState(() {
      _formComplete =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;

      if (_emailController.text.isNotEmpty) {
        _emailError = false;
      }
      if (_passwordController.text.isNotEmpty) {
        _passwordError = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isScreenUtilInit) {
      ScreenUtil.init(context);
      _isScreenUtilInit = true;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Enter your email and\nPassword to login',
                          style: TextStyle(
                            color: const Color(0xFF121926),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.40,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'email',
                          style: TextStyle(
                            color: const Color(0xFF121926),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.40,
                          ),
                        ),
                        SizedBox(height: 8),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Input your email here',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                onChanged: (val) {
                                  email = val;
                                  _validateForm();
                                },

                                validator:
                                    (val) =>
                                        val!.isEmpty
                                            ? "Email tidak boleh kosong"
                                            : null,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // button
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Forgot email?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF0A3D31),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    color: const Color(0xFF121926),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    height: 1.40,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Input your password here',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey.shade600,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (val) {
                                  password = val;
                                  _validateForm();
                                },

                                validator:
                                    (val) =>
                                        val!.length < 6
                                            ? "Minimal 6 karakter"
                                            : null,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF0A3D31),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: login,
                                  child: const Text("Login"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        _formComplete
                                            ? const Color(0xFF0A3D31)
                                            : const Color(0xFFD6D1FA),
                                    foregroundColor:
                                        _formComplete
                                            ? Colors.white
                                            : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t Have Account yet ? ',
                                    style: TextStyle(
                                      color: const Color(0xFF0F1728),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.40,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: const Color(0xFF0F1728),
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        height: 1.40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
