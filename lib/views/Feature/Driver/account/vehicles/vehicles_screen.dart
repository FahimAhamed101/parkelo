import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../helpers/route.dart';
import '../../../../../utils/appColor/app_colors.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

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
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _VehiclesHeader(
                onDone: () => Get.back(),
                onProfile: () => Get.back(),
                onPayments: () => Get.toNamed(AppRoutes.paymentScreen),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 28),
              sliver: SliverToBoxAdapter(child: VehicleListContent()),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleListContent extends StatelessWidget {
  const VehicleListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DashboardCard(
          topAccentColor: AppColors.blue,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.blueLt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderMd),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Toyota Corolla',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2020 - White',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.textSub,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A123456',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.blue,
                        fontSize: 12,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  _SmallActionButton(
                    label: 'Edit',
                    icon: Icons.edit_rounded,
                    color: AppColors.blue,
                    backgroundColor: AppColors.blueLt,
                    onTap: () => Get.toNamed(AppRoutes.editVehicleScreen),
                  ),
                  const SizedBox(height: 8),
                  _SmallActionButton(
                    label: 'Delete',
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.danger,
                    backgroundColor: AppColors.dangerBg,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.addVehicleScreen),
            icon: const Icon(Icons.add_rounded, size: 22),
            label: Text(
              'Add vehicle',
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VehiclesHeader extends StatelessWidget {
  const _VehiclesHeader({
    required this.onDone,
    required this.onProfile,
    required this.onPayments,
  });

  final VoidCallback onDone;
  final VoidCallback onProfile;
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
                  const _Avatar(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Carlos Marte',
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
                          '+1 (809) 555-1234',
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
                    onPressed: onDone,
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
                      'Done',
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
            _VehicleTabs(onProfile: onProfile, onPayments: onPayments),
          ],
        ),
      ),
    );
  }
}

class _VehicleTabs extends StatelessWidget {
  const _VehicleTabs({required this.onProfile, required this.onPayments});

  final VoidCallback onProfile;
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
                _TabButton(label: 'Profile', onTap: onProfile),
                _TabButton(label: 'Vehicles', isSelected: true, onTap: () {}),
                _TabButton(label: 'Payments', onTap: onPayments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 27,
        width: 76,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.22)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.topAccentColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? topAccentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (topAccentColor != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(height: 3, color: topAccentColor),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

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
        'C',
        style: GoogleFonts.nunito(
          color: AppColors.bg,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
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
