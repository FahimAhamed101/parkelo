import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/appColor/app_colors.dart';
import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';
import '../../../../base/CustomTextfield/CustomTextfield.dart';
import '../../../../base/AppButton/appButton.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  String selectedType = 'Sedan';
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  
  final List<Map<String, dynamic>> vehicleTypes = [
    {"name": "Sedan", "icon": Icons.directions_car},
    {"name": "SUV / 4x4", "icon": Icons.directions_car_filled},
    {"name": "Pickup", "icon": Icons.local_shipping},
    {"name": "Coupe", "icon": Icons.directions_car},
    {"name": "Minivan / Van", "icon": Icons.airport_shuttle},
    {"name": "Motorcycle", "icon": Icons.two_wheeler},
  ];

  @override
  void dispose() {
    licenseController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Add Vehicles"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: vehicleTypes.length,
              itemBuilder: (context, index) {
                final type = vehicleTypes[index];
                final isSelected = selectedType == type['name'];
                return GestureDetector(
                  onTap: () => setState(() => selectedType = type['name']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.Primary : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(type['icon'], color: isSelected ? AppColors.Primary : Colors.grey.shade700, size: 28),
                        const SizedBox(height: 8),
                        AppText(
                          type['name'],
                          fontSize: 11,
                          color: isSelected ? AppColors.Primary : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildLabel("VEHICLE TYPE *"),
            const SizedBox(height: 16),
            _buildLabel("LICENSE PLATE *"),
            const SizedBox(height: 8),
            CustomTextField(
              controller: licenseController,
              hintText: "Ej: A123456",
              prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            AppText("Dominican format: A123456 or AB1234", fontSize: 11, color: Colors.grey.shade500),
            const SizedBox(height: 16),
            _buildLabel("BRAND / MAKE *"),
            const SizedBox(height: 8),
            CustomTextField(
               controller: brandController,
               hintText: "Select the brand",
               suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildLabel("MODEL *"),
            const SizedBox(height: 8),
            CustomTextField(
               controller: modelController,
               hintText: "Ej: Corolla, Civic, Tucson...",
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("YEAR *"),
                      const SizedBox(height: 8),
                      CustomTextField(controller: yearController, hintText: "Ej: 2022"),
                    ],
                  )
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("COLOR *"),
                      const SizedBox(height: 8),
                      CustomTextField(controller: colorController, hintText: "Color", suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                    ],
                  )
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel("NOTES (OPTIONAL)"),
            const SizedBox(height: 8),
            CustomTextField(
               controller: notesController,
               hintText: "Ej: Has a sticker on the windshield, leather seats...",
               maxLines: 4,
            ),
            const SizedBox(height: 8),
            AppText("Special characteristics, observations for the host", fontSize: 11, color: AppColors.Primary),
            const SizedBox(height: 32),
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
    return AppText(text, fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600);
  }
}
