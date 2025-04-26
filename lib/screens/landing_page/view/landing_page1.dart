import 'package:agrarixx/screens/landing_page/view/landing_page2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class landingPage1 extends StatefulWidget {
  const landingPage1({super.key});

  @override
  State<landingPage1> createState() => _landingPage1State();
}

class _landingPage1State extends State<landingPage1> {
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
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5.w,
                        left: 30.w,
                        right: 30.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dapatkan Informasi Harga Pasar Secara Aktual dan Murah',
                              style: TextStyle(
                                color: const Color(0xFFF7C03F),
                                fontSize: 40.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => const landingPage2(),
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
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.r),
                                  border: Border.all(
                                    color: const Color(0xFFFFB72B),
                                    width: 2.w,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Selanjutnya',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: const Color(0xFFFFB72B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: const Color(0xFFFFB72B),
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(200.r),
                          ),
                          child: Container(
                            width: 280.w,
                            height: 280.h,
                            child: Image.asset(
                              'assets/images/landingPage1.png',
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade300,
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 50.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
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
