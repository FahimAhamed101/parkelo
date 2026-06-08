import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/appColor/app_colors.dart';
import '../../../../../utils/appIcons/app_icons.dart';
import '../../bottom_nav/bottom_nav.dart';

class DriverFlowNavBar extends StatelessWidget {
  final int selectedIndex;

  const DriverFlowNavBar({super.key, this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: AppColors.bg,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: AppColors.bottomNavShadow,
        ),
        child: Row(
          children: [
            _item(icon: AppIcons.explore, label: 'Explore', index: 0),
            _item(icon: AppIcons.bookings, label: 'Bookings', index: 1),
            _item(icon: AppIcons.favorites, label: 'Favorites', index: 2),
            _item(icon: AppIcons.home, label: 'Host', index: 3),
            _item(icon: AppIcons.account, label: 'Account', index: 4),
            _item(
              label: 'Admin',
              index: 5,
              materialIcon: Icons.settings_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    String? icon,
    IconData? materialIcon,
    required String label,
    required int index,
  }) {
    final isSelected = index == selectedIndex;
    final labelColor = isSelected ? AppColors.blue : AppColors.textFaint;
    final iconColor = isSelected ? Colors.white : AppColors.blue;

    Widget iconWidget;
    if (materialIcon != null) {
      iconWidget = Icon(materialIcon, size: 18, color: iconColor);
    } else {
      iconWidget = SvgPicture.asset(
        icon!,
        height: 18,
        width: 18,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    }

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.offAll(() => BottomNavScreen(initialIndex: index)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
              ),
              child: iconWidget,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 8,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: isSelected ? 18 : 0,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.gradGreenBar : null,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
