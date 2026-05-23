import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkealo/views/Feature/Driver/account/account_screen.dart';
import 'package:parkealo/views/Feature/Driver/bookings/bookings_screen.dart';
import 'package:parkealo/views/Feature/Driver/explore/explore_screen.dart';
import 'package:parkealo/views/Feature/Driver/favorites/favorites_screen.dart';
import '../../../../utils/AppColor/app_colors.dart';
import '../../../../utils/appIcons/app_icons.dart';


class BottomNavScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNavScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void navigationItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ExploreScreen(),
    BookingsScreen(),
    FavoritesScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.r),
            topRight: Radius.circular(0.r),
          ),
          border: const Border(
            top: BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.12,
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          selectedItemColor: AppColors.DarkBlue,
          unselectedItemColor: AppColors.DarkGray,
          selectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: AppColors.DarkBlue,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Color(0xFF4D4D4D)
          ),
          showSelectedLabels: true,
          backgroundColor: Colors.transparent,
          onTap: navigationItemTap,
          items: [
            _navItem(AppIcons.explore,  AppIcons.explore, "Explore", 0),
            _navItem(AppIcons.bookings, AppIcons.bookings,  "Bookings",    1),
            _navItem(AppIcons.favorites, AppIcons.favorites, "Favorites", 2),
            _navItem(AppIcons.account,  AppIcons.account, "Account",  3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      String unselected,
      String selected,
      String label,
      int index,
      ) {
    final bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        unselected,
        height: 22,
        width: 22,
        colorFilter: const ColorFilter.mode(
          AppColors.DarkGray,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        selected,
        height: 23,
        width: 23,
        colorFilter:const  ColorFilter.mode(
          AppColors.DarkBlue,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}