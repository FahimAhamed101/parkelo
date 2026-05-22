import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/appColor/app_colors.dart';
import '../../base/AppButton/appButton.dart';
import '../../base/AppText/appText.dart';
import '../../base/CustomTextfield/CustomTextfield.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
                        "Set a new password",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 6),
                      AppText(
                        "Please set a new password for your account to continue",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 40),

                      AppText(
                        "New Password",
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'New Password',
                        controller: newPasswordController,
                        filColor: AppColors.bgPrimary,
                        borderColor: AppColors.Primary,
                        prefixIcon: "assets/icons/lock.svg",
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),

                      AppText(
                        "Confirm Password",
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: 'Confirm Password',
                        controller: confirmPasswordController,
                        filColor: AppColors.bgPrimary,
                        borderColor: AppColors.Primary,
                        prefixIcon: "assets/icons/lock.svg",
                        isPassword: true,
                      ),
                      const SizedBox(height: 32),

                      AppButton(
                        text: "Update Password",
                        onTap: () {
                          // Update password and route back to login
                          Get.offAllNamed(AppRoutes.loginScreen);
                        },
                      ),
                      const SizedBox(height: 30),
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
