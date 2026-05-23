import 'package:flutter/material.dart';

import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';


class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Privacy Policy"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText("Privacy & Policy", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.6),
                children: const [
                  TextSpan(text: "Parkealo collects: name, email, vehicle license plate, location (only during active bookings) and transaction history. This data is used exclusively to: process bookings, improve the service and comply with legal requirements. We never sell your information. You can request the deletion of your data by sending an email to:\n"),
                  TextSpan(text: "privacidad@parkealo.com", style: TextStyle(decoration: TextDecoration.underline, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
