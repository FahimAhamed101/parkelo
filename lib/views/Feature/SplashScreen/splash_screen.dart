import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base/AppText/appText.dart';
import '../../../helpers/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.loginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B1E45),
                  Color(0xFF293A5C),
                ],
              ),
            ),
          ),

          // Decorative Circles
          Positioned(
            top: size.height * 0.10,
            right: -150,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF414C62).withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.14,
            left: -100,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF414C62).withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.05,
            left: -160,
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF414C62).withValues(alpha: 0.2),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(
                    'assets/images/parkealoAppIcon.png',
                    width: size.width * 0.55,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: size.height * 0.035),

                  AppText(
                    "Find, Reserve & Park \nSeamlessly in the city".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
