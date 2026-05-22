import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';
import '../../../utils/appColor/app_colors.dart';
import '../../base/AppButton/appButton.dart';
import '../../base/AppText/appText.dart';
import '../../base/CustomTextfield/CustomTextfield.dart';
import '../../base/OrDivider/ordivider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool acceptTerms = false;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                AppText(
                  "Create Account",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
                const SizedBox(height: 6),
                AppText(
                  "Sign up to get started",
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
                const SizedBox(height: 40),

                AppText(
                  "Full Name",
                  fontSize: 14,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter your full name',
                  controller: nameController,
                  filColor: AppColors.bgPrimary,
                  borderColor: AppColors.Primary,
                  prefixIcon: "assets/icons/personIcon.svg",
                ),
                const SizedBox(height: 20),

                AppText(
                  "E-mail",
                  fontSize: 14,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter your E-mail',
                  controller: emailController,
                  filColor: AppColors.bgPrimary,
                  borderColor: AppColors.Primary,
                  prefixIcon: "assets/icons/emailIcon.svg",
                ),
                const SizedBox(height: 20),

                AppText(
                  "Password",
                  fontSize: 14,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter your password',
                  controller: passwordController,
                  filColor: AppColors.bgPrimary,
                  borderColor: AppColors.Primary,
                  prefixIcon: "assets/icons/lock.svg",
                  isPassword: true,
                ),
                const SizedBox(height: 20),

                AppText(
                  "Confirm Password",
                  fontSize: 14,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Confirm your password',
                  controller: confirmPasswordController,
                  filColor: AppColors.bgPrimary,
                  borderColor: AppColors.Primary,
                  prefixIcon: "assets/icons/lock.svg",
                  isPassword: true,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          acceptTerms = !acceptTerms;
                        });
                      },
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: acceptTerms ? Colors.white : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: acceptTerms
                            ? const Center(
                                child: Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      "I accept the ",
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: AppText(
                        "Terms & Conditions",
                        fontSize: 12,
                        color: const Color(0xFFFF5C5C).withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                AppButton(
                  text: "Sign Up",
                  onTap: (){
                    Get.toNamed(AppRoutes.emailVerificationScreen);
                  },
                ),
                const SizedBox(height: 30),

                const OrDivider(
                  text: "Or Continue With",
                  lineColor: AppColors.textColor,
                  textColor: AppColors.textColor,
                  fontSize: 12,
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Button
                    Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0B0E12).withOpacity(0.20),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: IconButton(
                          onPressed: (){},
                          icon:SvgPicture.asset("assets/icons/googleIcon.svg", width: 24, height: 24),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                    ),
                    const SizedBox(width: 10),

                    // Apple Button
                    Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0B0E12).withOpacity(0.20),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: IconButton(
                          onPressed: (){},
                          icon:SvgPicture.asset("assets/icons/appleIcon.svg", width: 28, height: 28),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                    ),
                    const SizedBox(width: 10),

                    // Facebook Button
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0B0E12).withOpacity(0.20),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: IconButton(
                        onPressed: (){},
                        icon:SvgPicture.asset("assets/icons/fbIcon.svg", width: 28, height: 28),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Already have an account? ",
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w400,
                      ),
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: AppText(
                          "Login",
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
