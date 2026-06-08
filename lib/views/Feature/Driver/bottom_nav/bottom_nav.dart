import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkealo/hostPages/screens/homepage.dart';
import 'package:parkealo/views/Feature/Driver/account/account_screen.dart';
import 'package:parkealo/views/Feature/Driver/admin/admin_screen.dart';
import 'package:parkealo/views/Feature/Driver/bookings/bookings_screen.dart';
import 'package:parkealo/views/Feature/Driver/explore/explore_screen.dart';
import 'package:parkealo/views/Feature/Driver/favorites/favorites_screen.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../../utils/appIcons/app_icons.dart';

class BottomNavScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNavScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int selectedIndex;

  final List<Widget> _pages = const [
    ExploreScreen(),
    BookingsScreen(),
    FavoritesScreen(),
    HostDashboardPage(),
    AccountScreen(),
    AdminScreen(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  void navigationItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navHeight = 66.h.clamp(64.0, 68.0).toDouble();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: navHeight,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.r),
              topRight: Radius.circular(0.r),
            ),
            border: const Border(
              top: BorderSide(color: AppColors.border, width: 1),
            ),
            boxShadow: AppColors.bottomNavShadow,
          ),
          child: Row(
            children: [
              _navItem(icon: AppIcons.explore, label: "Explore", index: 0),
              _navItem(icon: AppIcons.bookings, label: "Bookings", index: 1),
              _navItem(icon: AppIcons.favorites, label: "Favorites", index: 2),
              _navItem(icon: AppIcons.home, label: "Host", index: 3),
              _navItem(icon: AppIcons.account, label: "Account", index: 4),
              _navItem(
                materialIcon: Icons.settings_outlined,
                label: "Admin",
                index: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    String? icon,
    IconData? materialIcon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    final labelColor = isSelected ? AppColors.blue : AppColors.textFaint;
    final iconColor = isSelected ? Colors.white : AppColors.blue;

    Widget iconWidget;
    if (materialIcon != null) {
      iconWidget = Icon(materialIcon, size: 19.r, color: iconColor);
    } else {
      iconWidget = SvgPicture.asset(
        icon!,
        height: 19.r,
        width: 19.r,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    }

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => navigationItemTap(index),
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 28.r,
                width: 28.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(7.r),
                ),
                child: iconWidget,
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 8.sp,
                  height: 1,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  color: labelColor,
                ),
              ),
              SizedBox(height: 5.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 3.h,
                width: isSelected ? 18.w : 0,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.gradGreenBar : null,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
