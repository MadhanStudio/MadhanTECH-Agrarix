import 'package:agrarixx/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/auth_service.dart'; // pastikan ini ada
import '../../models/user_model.dart';     // pastikan ini ada

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool isLoading = false;
  bool agreeTerms = false;

  void register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to Terms of Service')),
      );
      return;
    }
    
    setState(() => isLoading = true);

    UserModel? user = await _authService.register(
      name: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: "user", // default role user
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register gagal!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Text(
                        'Register your account now\nand Join with us!',
                        style: TextStyle(
                          color: const Color(0xFF121926),
                          fontSize: 20.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.40,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildLabel('Username'),
                      _buildTextField(controller: _usernameController, hint: 'Input your username here'),
                      SizedBox(height: 20.h),
                      _buildLabel('Email'),
                      _buildTextField(controller: _emailController, hint: 'Ex : user@example.com', keyboardType: TextInputType.emailAddress),
                      SizedBox(height: 20.h),
                      _buildLabel('Password'),
                      _buildTextField(controller: _passwordController, hint: 'Input your password here', isObscure: true),
                      SizedBox(height: 20.h),
                      _buildLabel('Confirm Password'),
                      _buildTextField(controller: _confirmPasswordController, hint: 'Confirm your password', isObscure: true),
                      SizedBox(height: 20.h),
                      CheckboxListTile(
                        value: agreeTerms,
                        onChanged: (val) => setState(() => agreeTerms = val!),
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I Agree with the ',
                                style: TextStyle(
                                  color: const Color(0xFF121926),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Terms of Service & Conditions',
                                style: TextStyle(
                                  color: const Color(0xFF013133),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A3D31),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: const Color(0xFF0F1728),
                              fontSize: 12.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              'Login here',
                              style: TextStyle(
                                color: const Color(0xFF0A3D31),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFF121926),
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        height: 1.40,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        fillColor: Colors.grey.shade100,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'This field cannot be empty';
        }
        if (controller == _confirmPasswordController && val != _passwordController.text) {
          return 'Password confirmation does not match';
        }
        return null;
      },
    );
  }
}
