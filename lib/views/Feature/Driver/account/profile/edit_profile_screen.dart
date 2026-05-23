import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/AppColor/app_colors.dart';
import '../../../../base/AppButton/appButton.dart';
import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';
import '../../../../base/CustomTextfield/CustomTextfield.dart';



class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController(text: "Shahin Alam");
  final TextEditingController emailController = TextEditingController(text: "alice@example.com");
  final TextEditingController phoneController = TextEditingController(text: "+1 (555) 123-4567");
  final TextEditingController licenseController = TextEditingController(text: "e.g.A4545");

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage("https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=200&auto=format&fit=crop"),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.Primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 14),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            _buildLabel("Full Name"),
            const SizedBox(height: 8),
            CustomTextField(controller: nameController, hintText: "Full Name", prefixIcon: const Icon(Icons.person_outline, color: Colors.grey)),
            const SizedBox(height: 16),
            
            _buildLabel("Email"),
            const SizedBox(height: 8),
            CustomTextField(controller: emailController, hintText: "Email", prefixIcon: const Icon(Icons.mail_outline, color: Colors.grey)),
            const SizedBox(height: 16),
            
            _buildLabel("Phone"),
            const SizedBox(height: 8),
            CustomTextField(controller: phoneController, hintText: "Phone", prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey)),
            const SizedBox(height: 16),
            
            _buildLabel("Vehicle License Plate"),
            const SizedBox(height: 8),
            CustomTextField(controller: licenseController, hintText: "Vehicle License Plate", prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey)),
            const SizedBox(height: 32),
            
            AppButton(
              text: "Save Changes",
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
