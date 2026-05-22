import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../helpers/route.dart';
import '../../../utils/appColor/app_colors.dart';
import '../../base/AppButton/appButton.dart';
import '../../base/AppText/appText.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});

  final TextEditingController otpController = TextEditingController();

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
                        "Email Verification",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 6),
                      AppText(
                        "We've sent a 6-digit code to your email",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 40),

                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        textStyle: const TextStyle(color: Colors.white),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 50,
                          fieldWidth: 45,
                          activeFillColor: Colors.transparent,
                          inactiveFillColor: Colors.transparent,
                          selectedFillColor: Colors.transparent,
                          activeColor: AppColors.Primary,
                          inactiveColor: Colors.white.withOpacity(0.5),
                          selectedColor: Colors.white,
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: InkWell(
                          onTap: () {
                            // Paste code logic
                          },
                          child: AppText(
                            "Paste Code",
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      AppButton(
                        text: "Verify",
                        onTap: () {
                          Get.offAllNamed(AppRoutes.loginScreen);
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
                                  "Didn't receive the code? ",
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                InkWell(
                                  onTap: () {
                                    // Resend logic
                                  },
                                  child: AppText(
                                    "Resend",
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                Get.offAllNamed(AppRoutes.loginScreen);
                              },
                              child: AppText(
                                "Back to Login",
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
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
