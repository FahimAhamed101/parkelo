import 'package:flutter/material.dart';

import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';



class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Terms & Condition"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText("Terms & Condition", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            const SizedBox(height: 24),
            AppText("Welcome to Parkealo App !", fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            const SizedBox(height: 8),
            AppText("Terms of use — Parkealo", fontSize: 12, color: Colors.grey.shade600),
            const SizedBox(height: 4),
            AppText("By using Parkealo, you agree that:", fontSize: 12, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            _buildNumberedItem("1.", "You are responsible for the vehicle and its documents."),
            _buildNumberedItem("2.", "Parkealo acts as an intermediary between the user and the host."),
            _buildNumberedItem("3.", "Confirmed reservations generate an immediate charge."),
            _buildNumberedItem("4.", "Parkealo is not responsible for damages not covered by the contracted insurance."),
            _buildNumberedItem("5.", "Failure to comply with the rules may result in account suspension."),
            _buildNumberedItem("6.", "Refunds are subject to review according to the dispute policy."),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberedItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(number, fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(text, fontSize: 13, color: Colors.black87),
          )
        ],
      ),
    );
  }
}
