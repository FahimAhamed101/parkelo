import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/appColor/app_colors.dart';
import '../../base/AppButton/appButton.dart';
import '../../base/AppText/appText.dart';
import '../../base/CustomTextfield/CustomTextfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1E45),
              Color(0xFF293A5C),
            ],
            stops: [0.0176, 0.9555],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.1),
                      AppText(
                        "Forgot Password?",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 6),
                      AppText(
                        "Don’t worry! Enter your registered email.",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 40),

                      AppText(
                        "Enter your email",
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Enter your email',
                        controller: emailController,
                        filColor: AppColors.bgPrimary,
                        borderColor: AppColors.Primary,
                        prefixIcon: "assets/icons/emailIcon.svg",
                      ),
                      const SizedBox(height: 32),

                      AppButton(
                        text: "Send Reset Code",
                        onTap: () {
                          Get.toNamed(AppRoutes.verificationCodeScreen);
                        },
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  "Remembered your password? ",
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: AppText(
                                    "Login",
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {},
                              child: AppText(
                                "Need Help?",
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
