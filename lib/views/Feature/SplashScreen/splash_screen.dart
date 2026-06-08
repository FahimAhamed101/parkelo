import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/appColor/app_colors.dart';
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
    return Scaffold(
      backgroundColor: AppColors.blueNav,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/parkealoAppIcon1.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
