import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helpers/route.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';

class ConfirmPayScreen extends StatelessWidget {
  const ConfirmPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Confirm and pay", showBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Reservation card
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText("Your Reservation", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        const SizedBox(height: 16),
                        _Row(label: "Date", value: "Today · 10:30 – 12:30"),
                        const SizedBox(height: 12),
                        _Row(label: "Duration", value: "2 hours"),
                        const SizedBox(height: 12),
                        _Row(label: "Space", value: "Assigned upon arrival"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment summary card
                  _Card(
                    child: Column(
                      children: [
                        _Row(label: "Subtotal", value: "RD\$300"),
                        const SizedBox(height: 12),
                        _Row(label: "ITBIS 18%", value: "RD\$54"),
                        const SizedBox(height: 12),
                        _Row(label: "Service fee", value: "RD\$25"),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0xFFE5E7EB)),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText("Total", fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.DarkBlue),
                            AppText("RD\$379", fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.DarkBlue),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confirm button
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).padding.bottom + 16),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.bookingConfirmedScreen),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.Primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: AppText("Confirm Reservation", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, fontSize: 14, color: Colors.grey.shade600),
        AppText(value, fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.DarkBlue),
      ],
    );
  }
}
