import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/AppButton/appButton.dart';
import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';
import '../../../../base/CustomTextfield/CustomTextfield.dart';


class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "payment"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText("Please enter payment information", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            const SizedBox(height: 24),
            
            _buildLabel("Name on Card"),
            const SizedBox(height: 8),
            CustomTextField(controller: TextEditingController(), hintText: "Name on card"),
            const SizedBox(height: 16),
            
            _buildLabel("Card Number"),
            const SizedBox(height: 8),
            CustomTextField(controller: TextEditingController(), hintText: "1234  5678  9101  1121"),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Expiration Date"),
                      const SizedBox(height: 8),
                      CustomTextField(controller: TextEditingController(), hintText: "MM/YY"),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("CVC"),
                      const SizedBox(height: 8),
                      CustomTextField(controller: TextEditingController(), hintText: "123"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildLabel("Country"),
            const SizedBox(height: 8),
            CustomTextField(
               controller: TextEditingController(text: "Bangladesh"), 
               suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)
            ),
            const SizedBox(height: 16),
            
            _buildLabel("Street Name And Number"),
            const SizedBox(height: 8),
            CustomTextField(controller: TextEditingController(), hintText: "Street Name And Number"),
            const SizedBox(height: 16),
            
            _buildLabel("Additional Address Details (optional)"),
            const SizedBox(height: 8),
            CustomTextField(controller: TextEditingController(), hintText: "Additional Address Details (optional)"),
            const SizedBox(height: 16),
            
            _buildLabel("City/Town"),
            const SizedBox(height: 8),
            CustomTextField(controller: TextEditingController(), hintText: "City"),
            const SizedBox(height: 16),
            
            _buildLabel("Postcode"),
            const SizedBox(height: 8),
            CustomTextField(controller: TextEditingController(), hintText: "10000"),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.admin_panel_settings, color: Color(0xFF4A8CA6), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText("Your information is secure", fontSize: 13, fontWeight: FontWeight.bold),
                        const SizedBox(height: 4),
                        AppText("We use bank-level encryption and Stripe to protect your payment information", fontSize: 11, color: Colors.grey.shade700),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            AppButton(
              text: "Add Save",
              onTap: () => Get.back(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return AppText(text, fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800);
  }
}
