import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../Authentication/controllers/auth_controller.dart';
import '../../Authentication/models/auth_user.dart';
import 'vehicles/vehicles_screen.dart';

enum _AccountTab { profile, vehicles }

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  _AccountTab _selectedTab = _AccountTab.profile;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController.instance;
    _authController.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.blueNav,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.bg,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Obx(() {
          final user = _authController.user.value;
          final profile = _authController.profile.value;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _AccountHeader(
                  selectedTab: _selectedTab,
                  user: user,
                  onProfile: () => setState(() {
                    _selectedTab = _AccountTab.profile;
                  }),
                  onVehicles: () => setState(() {
                    _selectedTab = _AccountTab.vehicles;
                  }),
                  onPayments: () => Get.toNamed(AppRoutes.paymentScreen),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                sliver: SliverToBoxAdapter(
                  child: _selectedTab == _AccountTab.profile
                      ? _ProfileCard(
                          user: user,
                          profile: profile,
                          isLoading: _authController.isLoading.value,
                          onLogout: () => _showLogoutDialog(context),
                        )
                      : const VehicleListContent(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Obx(
        () => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of this account?',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSub,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          actions: [
            TextButton(
              onPressed: _authController.isLoading.value
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.nunito(
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            FilledButton(
              onPressed: _authController.isLoading.value
                  ? null
                  : _authController.logout,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                _authController.isLoading.value ? 'Logging out...' : 'Logout',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    required this.selectedTab,
    required this.user,
    required this.onProfile,
    required this.onVehicles,
    required this.onPayments,
  });

  final _AccountTab selectedTab;
  final AuthUser? user;
  final VoidCallback onProfile;
  final VoidCallback onVehicles;
  final VoidCallback onPayments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Row(
                children: [
                  _Avatar(initials: user?.initials ?? 'P'),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? 'Parkealo User',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: 19,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                            color: AppColors.bg,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.phoneNumber ?? 'No phone number',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blueMid,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: selectedTab == _AccountTab.profile
                        ? () => Get.toNamed(AppRoutes.editProfileScreen)
                        : onProfile,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(50, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      backgroundColor: AppColors.blueSky.withValues(
                        alpha: 0.55,
                      ),
                      foregroundColor: AppColors.bg,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      selectedTab == _AccountTab.profile ? 'Edit' : 'Done',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _ProfileTabs(
              selectedTab: selectedTab,
              onProfile: onProfile,
              onVehicles: onVehicles,
              onPayments: onPayments,
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greenAcct,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF55D58C), width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueNav.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        initials,
        style: GoogleFonts.nunito(
          color: AppColors.bg,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  const _ProfileTabs({
    required this.selectedTab,
    required this.onProfile,
    required this.onVehicles,
    required this.onPayments,
  });

  final _AccountTab selectedTab;
  final VoidCallback onProfile;
  final VoidCallback onVehicles;
  final VoidCallback onPayments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: const [
                _HeaderBlock(width: 22, height: 22, bottom: 0),
                Spacer(),
                _HeaderBlock(width: 18, height: 18, bottom: 2),
                Spacer(),
                _HeaderBlock(width: 18, height: 26, bottom: 0),
                Spacer(),
                _HeaderBlock(width: 18, height: 46, bottom: 0),
              ],
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                _TabButton(
                  label: 'Profile',
                  isSelected: selectedTab == _AccountTab.profile,
                  onTap: onProfile,
                ),
                _TabButton(
                  label: 'Vehicles',
                  isSelected: selectedTab == _AccountTab.vehicles,
                  onTap: onVehicles,
                ),
                _TabButton(label: 'Payments', onTap: onPayments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock({
    required this.width,
    required this.height,
    required this.bottom,
  });

  final double width;
  final double height;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(bottom: bottom),
        decoration: BoxDecoration(
          color: AppColors.blueSky.withValues(alpha: 0.22),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: isSelected ? AppColors.bg : AppColors.blueMid,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.gradGreenBar : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.user,
    required this.profile,
    required this.isLoading,
    required this.onLogout,
  });

  final AuthUser? user;
  final AccountProfile? profile;
  final bool isLoading;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadowMd,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal information',
              style: GoogleFonts.nunito(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _ReadOnlyField(
              label: 'Full name',
              value: profile?.fullName.isNotEmpty == true
                  ? profile!.fullName
                  : user?.fullName ?? 'Parkealo User',
            ),
            const SizedBox(height: 13),
            _ReadOnlyField(
              label: 'Phone',
              value: user?.phoneNumber ?? 'No phone number',
            ),
            const SizedBox(height: 13),
            _LicensePlateField(
              label:
                  profile?.licensePlateLabel ??
                  user?.vehiclePlate ??
                  'No license plate registered',
              registered:
                  profile?.licensePlateRegistered ?? user?.vehiclePlate != null,
            ),
            const SizedBox(height: 13),
            _ReadOnlyField(
              label: 'Email address',
              value: user?.email ?? 'No email address',
              trailing: _VerifiedBadge(
                label: profile?.emailVerifiedLabel ?? 'Not verified',
              ),
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.border),
            _AccountActionRow(
              icon: Icons.card_giftcard_rounded,
              iconColor: AppColors.orange,
              title: 'Refer friends',
              onTap: () => Get.toNamed(AppRoutes.inviteFriendScreen),
            ),
            _AccountActionRow(
              icon: Icons.settings_rounded,
              iconColor: AppColors.purple,
              title: 'Settings',
              onTap: () => Get.toNamed(AppRoutes.accountSettingsScreen),
            ),
            _AccountActionRow(
              icon: Icons.notifications_rounded,
              iconColor: AppColors.amber,
              title: 'Notifications',
              onTap: () => Get.toNamed(AppRoutes.notificationScreen),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: isLoading ? null : onLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.dangerBd),
                  backgroundColor: AppColors.dangerBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isLoading ? 'Logging out...' : 'Logout',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 7),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 10), trailing!],
            ],
          ),
        ),
      ],
    );
  }
}

class _LicensePlateField extends StatelessWidget {
  const _LicensePlateField({required this.label, required this.registered});

  final String label;
  final bool registered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Vehicle license plate'),
        const SizedBox(height: 7),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.borderMd),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.credit_card_rounded,
                size: 18,
                color: AppColors.textFaint,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: registered ? AppColors.text : AppColors.textFaint,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Automatically used when booking with another vehicle',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            color: AppColors.textFaint,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.nunito(
        color: AppColors.textSub,
        fontSize: 12,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greenLt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.greenMid),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          color: AppColors.green,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AccountActionRow extends StatelessWidget {
  const _AccountActionRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 47,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            SizedBox(width: 34, child: Icon(icon, color: iconColor, size: 19)),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textFaint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
