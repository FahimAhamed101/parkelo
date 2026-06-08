import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'widgets/auth_shell.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(initialTab: AuthTab.signUp);
  }
}
