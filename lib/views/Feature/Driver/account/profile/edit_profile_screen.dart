import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.Primary),
              title: AppText("Take a photo", fontSize: 14, fontWeight: FontWeight.w500),
              onTap: () async {
                Navigator.pop(context);
                final xFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                if (xFile != null) setState(() => _pickedImage = File(xFile.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.Primary),
              title: AppText("Choose from gallery", fontSize: 14, fontWeight: FontWeight.w500),
              onTap: () async {
                Navigator.pop(context);
                final xFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                if (xFile != null) setState(() => _pickedImage = File(xFile.path));
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

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
            // Avatar with picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!) as ImageProvider
                            : const NetworkImage(
                                "https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=200&auto=format&fit=crop"),
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
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildLabel("Full Name"),
            const SizedBox(height: 8),
            CustomTextField(
              controller: nameController,
              hintText: "Full Name",
              prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            _buildLabel("Email"),
            const SizedBox(height: 8),
            // Email is read-only
            CustomTextField(
              controller: emailController,
              hintText: "Email",
              prefixIcon: const Icon(Icons.mail_outline, color: Colors.grey),
              enabled: false,
              filColor: Colors.grey.shade100,
              borderColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 4),
            AppText("Email cannot be changed", fontSize: 11, color: Colors.grey.shade500),
            const SizedBox(height: 16),

            _buildLabel("Phone"),
            const SizedBox(height: 8),
            CustomTextField(
              controller: phoneController,
              hintText: "Phone",
              prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _buildLabel("Vehicle License Plate"),
            const SizedBox(height: 8),
            CustomTextField(
              controller: licenseController,
              hintText: "Vehicle License Plate",
              prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            AppButton(text: "Save Changes", onTap: () => Get.back()),
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
