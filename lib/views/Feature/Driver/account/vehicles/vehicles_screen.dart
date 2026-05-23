import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../helpers/route.dart';
import '../../../../../utils/AppColor/app_colors.dart';
import '../../../../base/AppButton/appButton.dart';
import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';


class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4), // Base background color
      appBar: const CustomAppBar(title: "Vehicles"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.Primary.withOpacity(0.3), width: 1.5),
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
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.LightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.directions_car, color: AppColors.Primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText("Toyota Corolla", fontSize: 16, fontWeight: FontWeight.bold),
                        const SizedBox(height: 2),
                        AppText("2020 · White", fontSize: 12, color: Colors.grey.shade600),
                        const SizedBox(height: 4),
                        AppText("A123456", fontSize: 14, color: AppColors.Primary, fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _buildActionButton("Edit", Icons.edit, AppColors.Primary, AppColors.LightBlue, () => Get.toNamed(AppRoutes.editVehicleScreen)),
                      const SizedBox(height: 8),
                      _buildActionButton("Delete", Icons.delete_outline, AppColors.Red, AppColors.LightRed, () {}),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: "+ Add",
              onTap: () => Get.toNamed(AppRoutes.addVehicleScreen),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            AppText(text, fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}
