import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';

class CheckoutScreen extends StatelessWidget {
  final int totalSeconds;

  const CheckoutScreen({super.key, required this.totalSeconds});

  String get _formattedTime {
    final h = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    const double booking = 300;
    const double itbis = 54;
    const double serviceFee = 25;
    const double total = booking + itbis + serviceFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Successful Check-out!", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Blue summary card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0052AD),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                children: [
                  // Check icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    "Successful Check-out!",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    "Total time in parking",
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    _formattedTime,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Billing breakdown card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _BillRow(label: "Booking (2h)", value: "RD\$${booking.toInt()}"),
                  const SizedBox(height: 12),
                  _BillRow(label: "ITBIS 18%", value: "RD\$${itbis.toInt()}"),
                  const SizedBox(height: 12),
                  _BillRow(label: "Service fee", value: "RD\$${serviceFee.toInt()}"),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText("Total charged", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      AppText(
                        "RD\$${total.toInt()}",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.Primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Done button
            GestureDetector(
              onTap: () => Get.back(result: true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.Primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: AppText("Done", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;

  const _BillRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, fontSize: 13, color: Colors.grey.shade600),
        AppText(value, fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
      ],
    );
  }
}
