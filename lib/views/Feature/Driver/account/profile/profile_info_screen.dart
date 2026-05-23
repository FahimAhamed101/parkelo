import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../helpers/route.dart';
import '../../../../../utils/AppColor/app_colors.dart';
import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';

class ProfileInfoScreen extends StatelessWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: CustomAppBar(
        title: "Profile Info",
        action: GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.editProfileScreen),
          child: const Padding(
             padding: EdgeInsets.all(12),
             child: Icon(Icons.manage_accounts_outlined, color: Colors.white, size: 24),
          )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
            const SizedBox(height: 12),
            AppText("Shahin Alam", fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.Primary),
              ),
              child: AppText("Verified", fontSize: 12, color: AppColors.Primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            
            _buildInfoCard(
              "Personal Information",
              [
                _buildInfoRow(Icons.person_outline, "Full Name", "Rokey Mahmud"),
              ]
            ),
            const SizedBox(height: 16),
            
            _buildInfoCard(
              "Contact Information",
              [
                _buildInfoRow(Icons.mail_outline, "Email", "alice@example.com"),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.phone_outlined, "Phone", "+1 (555) 123-4567"),
              ]
            ),
            const SizedBox(height: 16),
            
            _buildInfoCard(
              "Identification",
              [
                _buildInfoRow(Icons.badge_outlined, "Vehicle License Plate", "e.g.A4545"),
              ]
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, fontSize: 14, fontWeight: FontWeight.bold),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(label, fontSize: 11, color: Colors.grey.shade500),
              const SizedBox(height: 4),
              AppText(value, fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
            ],
          ),
        )
      ],
    );
  }
}
