import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../helpers/route.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _switchController = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _switchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Airy,
      appBar: const CustomAppBar(title: "Account"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// App Logo
            Center(
              child: Image.asset(
                "assets/images/parkealoAppIcon.png",
                height: 100,
                width: 200,
              ),
            ),
            const SizedBox(height: 16),

            /// App Info Card
            _buildSectionCard(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Parkealo",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.Black,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        "Version 1.0.0 (Build 100)",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.DarkGray,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        "© 2026 parkealo SRL. Santo Domingo, RD",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.DarkGray,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Vehicles & Payment
            _buildSectionCard(
              children: [
                _buildMenuTile(
                  icon: "assets/icons/vechicles.svg",
                  title: "Vehicles",
                  onTap: () => Get.toNamed(AppRoutes.vehiclesScreen),
                ),
                _buildMenuTile(
                  icon: "assets/icons/payment.svg",
                  title: "Payment",
                  onTap: () => Get.toNamed(AppRoutes.paymentScreen),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Account Information
            _buildSectionCard(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 4),
                  child: AppText(
                    "Account Information",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.Black,
                  ),
                ),
                _buildMenuTile(
                  icon: "assets/icons/profile.svg",
                  title: "Profile Info",
                  onTap: () => Get.toNamed(AppRoutes.profileInfoScreen),
                ),

                _buildSwitchTile(
                  icon: "assets/icons/switch.svg",
                  title: "Switch to Host",
                  onTap: () {
                    _switchController.value = true;
                    Get.toNamed(AppRoutes.switchToHostScreen);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Policy Center
            _buildSectionCard(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 4),
                  child: AppText(
                    "Policy Center",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.Black,
                  ),
                ),
                _buildMenuTile(
                  icon: "assets/icons/privacyIcon.svg",
                  title: "Privacy Policy",
                  onTap: () => Get.toNamed(AppRoutes.privacyPolicyScreen),
                ),

                _buildMenuTile(
                  icon: "assets/icons/terms&condition.svg",
                  title: "Terms & Condition",
                  onTap: () => Get.toNamed(AppRoutes.termsConditionScreen),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Settings
            _buildSectionCard(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 12, bottom: 4),
                  child: AppText(
                    "Settings",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.Black,
                  ),
                ),
                _buildMenuTile(
                  icon: "assets/icons/refferIcon.svg",
                  title: "Refer Friend",
                  onTap: () => Get.toNamed(AppRoutes.inviteFriendScreen),
                ),

                _buildMenuTile(
                  icon: "assets/icons/notificationIcon.svg",
                  title: "Notification",
                  onTap: () => Get.toNamed(AppRoutes.accountSettingsScreen),
                ),

                _buildMenuTile(
                  icon: "assets/icons/helpIcon.svg",
                  title: "Help & Support",
                  onTap: () => Get.toNamed(AppRoutes.helpSupportScreen),
                ),

                _buildMenuTile(
                  icon: "assets/icons/logout.svg",
                  title: "Log Out",
                  onTap: () => _showLogoutDialog(context),
                ),

                _buildMenuTile(
                  icon: "assets/icons/deleteIcon.svg",
                  title: "Delete Account",
                  titleColor: AppColors.Red,
                  onTap: () => _showDeleteDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Reusable section card wrapper
  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// Reusable menu tile with SVG icon
  Widget _buildMenuTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 08),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              height: 22,
              colorFilter: titleColor != null
                  ? ColorFilter.mode(titleColor, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                title,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF585858),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.DarkGray,
            ),
          ],
        ),
      ),
    );
  }

  /// Switch tile for "Switch to Host"
  Widget _buildSwitchTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 22, height: 22),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                title,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF585858),
              ),
            ),
            IgnorePointer(
              child: AdvancedSwitch(
                controller: _switchController,
                activeColor: AppColors.Primary,
                inactiveColor: AppColors.LightGray,
                width: 48,
                height: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- Logout Confirmation Dialog --------------------
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/icons/logout.svg",
                  width: 28,
                  height: 28,
                ),
              ),
              const SizedBox(height: 12),
              AppText(
                "Log Out",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.Black,
              ),
              const SizedBox(height: 12),
              AppText(
                "Are you sure you want to log out of this account?",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.DarkGray,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.Black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.loginScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.White,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- Delete Confirmation Dialog --------------------
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/icons/delete-02.svg",
                  width: 28,
                  height: 28,
                ),
              ),
              const SizedBox(height: 12),
              AppText(
                "Delete Account",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.Black,
              ),
              const SizedBox(height: 12),
              AppText(
                "Are you sure to delete this account?",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.DarkGray,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.Black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle delete account logic
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.White,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
