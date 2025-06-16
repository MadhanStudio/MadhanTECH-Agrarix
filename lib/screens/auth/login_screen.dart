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
  // _emailError and _passwordError are not needed as TextFormField validator handles UI errors.
  bool _formComplete = false;
  // _isScreenUtilInit and manual ScreenUtil.init call are generally not needed if ScreenUtilInit is used at app root.

  bool isLoading = false;
  bool _isPasswordVisible = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      UserModel? user = await _authService.login(
          _emailController.text.trim(), _passwordController.text.trim());
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
      _formComplete = _emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading // Show loading indicator if isLoading is true
              ? Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFF0A3D31), // Theme color for loader
                  ),
                )
              : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50.h), // Adjusted spacing
                        // App Logo
                        Center(
                          child: Image.asset(
                            'assets/images/agrarix_logo.png', // Ensure you have this asset
                            height: 80.h,
                          ),
                        ),
                        SizedBox(height: 40.h), // Adjusted spacing
                        // Title Text
                        Text(
                          'Selamat Datang Kembali!',
                          style: TextStyle(
                            color: const Color(0xFF121926),
                            fontSize: 24.sp, // Slightly larger title
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Masukkan email dan password untuk masuk.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.40,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Email', // Capitalized for consistency
                          style: TextStyle(
                            color: const Color(0xFF121926),
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600, // Slightly bolder label
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
                                  hintText: 'Masukkan email Anda',
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
                                // onChanged callback is handled by the listener in initState

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
                                  child: const Text( // Added const
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
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600, // Slightly bolder label
                                    height: 1.40,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan password Anda',
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
                                // onChanged callback is handled by the listener in initState

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
                                  child: const Text( // Added const
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
                                  child: Text("Masuk", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
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
                                    style: const TextStyle( // Added const
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
                                      style: const TextStyle( // Added const
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
