import 'package:flutter/material.dart';

import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';




class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Contact Us"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildContactCard(Icons.chat_bubble_outline, "Support chat"),
            const SizedBox(height: 16),
            _buildContactCard(Icons.call_outlined, "Call"),
            const SizedBox(height: 16),
            _buildContactCard(Icons.mail_outline, "Email"),
            const SizedBox(height: 16),
            _buildContactCard(Icons.shopping_cart_outlined, "Make a claim"),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700, size: 22),
          const SizedBox(width: 16),
          AppText(title, fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
        ],
      ),
    );
  }
}
