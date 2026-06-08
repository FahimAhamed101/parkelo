import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helpers/route.dart';
import '../../../utils/appColor/app_colors.dart';
import 'controllers/auth_controller.dart';
import 'widgets/auth_shell.dart';

class LoginScreen extends StatefulWidget {
  final AuthTab initialTab;

  const LoginScreen({super.key, this.initialTab = AuthTab.signIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthTab selectedTab;

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController signUpNameController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPhoneController = TextEditingController();
  final TextEditingController signUpVehicleController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool rememberMe = true;
  bool acceptTerms = false;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpNameController.dispose();
    signUpEmailController.dispose();
    signUpPhoneController.dispose();
    signUpVehicleController.dispose();
    signUpPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void changeTab(AuthTab tab) {
    if (selectedTab == tab) return;
    setState(() {
      selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.instance;

    return AuthPageScaffold(
      selectedTab: selectedTab,
      onTabChanged: changeTab,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: selectedTab == AuthTab.signIn
              ? _SignInForm(
                  key: const ValueKey(AuthTab.signIn),
                  emailController: loginEmailController,
                  passwordController: loginPasswordController,
                  rememberMe: rememberMe,
                  authController: authController,
                  onRememberChanged: (value) {
                    setState(() {
                      rememberMe = value;
                    });
                  },
                )
              : _SignUpForm(
                  key: const ValueKey(AuthTab.signUp),
                  nameController: signUpNameController,
                  emailController: signUpEmailController,
                  phoneController: signUpPhoneController,
                  vehicleController: signUpVehicleController,
                  passwordController: signUpPasswordController,
                  confirmPasswordController: confirmPasswordController,
                  acceptTerms: acceptTerms,
                  authController: authController,
                  onTermsChanged: (value) {
                    setState(() {
                      acceptTerms = value;
                    });
                  },
                ),
        ),
      ],
    );
  }
}

class _SignInForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final AuthController authController;
  final ValueChanged<bool> onRememberChanged;

  const _SignInForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.authController,
    required this.onRememberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthFieldLabel('EMAIL ADDRESS'),
        const SizedBox(height: 8),
        AuthInput(
          hintText: 'email@example.com',
          controller: emailController,
          prefixIcon: 'assets/icons/emailIcon.svg',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const AuthFieldLabel('PASSWORD'),
        const SizedBox(height: 8),
        AuthInput(
          hintText: '********',
          controller: passwordController,
          prefixIcon: 'assets/icons/lock.svg',
          isPassword: true,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AuthCheckRow(
                value: rememberMe,
                label: 'Remember me',
                onChanged: onRememberChanged,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.forgotPasswordScreen);
              },
              child: Text(
                'Forgot password?',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Obx(
          () => AuthPrimaryButton(
            text: 'Sign In',
            isLoading: authController.isLoading.value,
            onTap: () {
              authController.signIn(
                identifier: emailController.text,
                password: passwordController.text,
                rememberMe: rememberMe,
              );
            },
          ),
        ),
        const SizedBox(height: 22),
        const AuthDivider(text: 'OR CONTINUE WITH'),
        const SizedBox(height: 20),
        const AuthSocialButtons(),
      ],
    );
  }
}

class _SignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController vehicleController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool acceptTerms;
  final AuthController authController;
  final ValueChanged<bool> onTermsChanged;

  const _SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.vehicleController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.acceptTerms,
    required this.authController,
    required this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthFieldLabel('FULL NAME'),
        const SizedBox(height: 8),
        AuthInput(
          hintText: 'Your name',
          controller: nameController,
          prefixIcon: 'assets/icons/personIcon.svg',
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
        const AuthFieldLabel('EMAIL ADDRESS'),
        const SizedBox(height: 8),
        AuthInput(
          hintText: 'email@example.com',
          controller: emailController,
          prefixIcon: 'assets/icons/emailIcon.svg',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const AuthFieldLabel('PHONE NUMBER'),
        const SizedBox(height: 8),
        AuthInput(
          hintText: '+1 (809) 555-1234',
          controller: phoneController,
          prefixIcon: 'assets/icons/phoneIcon.svg',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        const AuthFieldLabel('VEHICLE LICENSE PLATE'),
        const SizedBox(height: 8),
        AuthInput(
          hintText: 'A123456',
          controller: vehicleController,
          prefixIcon: 'assets/icons/parking.svg',
        ),
        const SizedBox(height: 16),
        const AuthFieldLabel('PASSWORD'),
        const SizedBox(height: 8),
        AuthInput(
          hintText: '********',
          controller: passwordController,
          prefixIcon: 'assets/icons/lock.svg',
          isPassword: true,
        ),
        const SizedBox(height: 16),
        const AuthFieldLabel('CONFIRM PASSWORD'),
        const SizedBox(height: 8),
        AuthInput(
          hintText: '********',
          controller: confirmPasswordController,
          prefixIcon: 'assets/icons/lock.svg',
          isPassword: true,
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: AuthCheckRow(
                value: acceptTerms,
                label: '',
                onChanged: onTermsChanged,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text.rich(
                  TextSpan(
                    text: 'I accept the ',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSub,
                    ),
                    children: [
                      TextSpan(
                        text: 'terms and conditions',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Obx(
          () => AuthPrimaryButton(
            text: 'Sign Up',
            isLoading: authController.isLoading.value,
            onTap: () {
              authController.signUp(
                fullName: nameController.text,
                email: emailController.text,
                phoneNumber: phoneController.text,
                vehiclePlate: vehicleController.text,
                password: passwordController.text,
                confirmPassword: confirmPasswordController.text,
                termsAccepted: acceptTerms,
              );
            },
          ),
        ),
        const SizedBox(height: 22),
        const AuthDivider(text: 'OR CONTINUE WITH'),
        const SizedBox(height: 20),
        const AuthSocialButtons(),
      ],
    );
  }
}
