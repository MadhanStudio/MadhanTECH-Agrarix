import 'package:agrarixx/screens/auth/login_screen.dart';
import 'package:agrarixx/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class landingPage3 extends StatefulWidget {
  const landingPage3({super.key});

  @override
  State<landingPage3> createState() => _landingPage3State();
}

class _landingPage3State extends State<landingPage3> {
  bool _isScreenUtilInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isScreenUtilInit) {
      ScreenUtil.init(context);
      _isScreenUtilInit = true;
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: null,
        backgroundColor: Color(0xFF013133),
        body: Container(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset('assets/images/landingPageLogo.png')],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          Text(
                            'Bertani Cerdas di Era Digital',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFF7C03F),
                              fontSize: 32.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Jual hasil panen, cek harga pasar, gabung komunitas, dan terus belajar bersama Aagrarrix.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFF7C03F),
                              fontSize: 16.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.40,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const RegisterPage(),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF7C03F),
                              foregroundColor: Colors.black,
                              minimumSize: Size(177.w, 40.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                color: const Color(0xFF013133),
                                fontSize: 24.sp,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const LoginScreen(),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white, width: 1.w),
                              minimumSize: Size(177.w, 40.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                color: const Color(0xFFF7C03F),
                                fontSize: 24.sp,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(140.r),
                      topRight: Radius.circular(140.r),
                    ),
                    child: Image.asset(
                      'assets/images/landingPage3.png',
                      width: double.infinity,
                      height: 280.h,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Container(height: 250.h),
                    ),
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
