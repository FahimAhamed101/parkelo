import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkealo/hostPages/screens/alerts_page.dart';
import 'package:parkealo/hostPages/screens/homepage.dart';
import 'package:parkealo/hostPages/screens/parking_spaces_page.dart';
import 'package:parkealo/hostPages/screens/prices_page.dart';
import 'package:parkealo/hostPages/screens/services_page.dart';

import '../../../../utils/AppColor/app_colors.dart';
import '../../../../utils/appIcons/app_icons.dart';

class HostBottomNavScreen extends StatefulWidget {
  final int initialIndex;

  const HostBottomNavScreen({super.key, this.initialIndex = 0});

  @override
  State<HostBottomNavScreen> createState() => _HostBottomNavScreenState();
}

class _HostBottomNavScreenState extends State<HostBottomNavScreen> {
  late int selectedIndex;

  final List<Widget> _pages = const [
    HostDashboardPage(),
    ParkingSpacesPage(),
    ServicesPage(),
    PricesBySectionPage(),
    AlertsPage(),
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
    final navHeight = 72.h.clamp(64.0, 78.0).toDouble();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: navHeight,
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
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            selectedItemColor: AppColors.DarkBlue,
            unselectedItemColor: AppColors.DarkGray,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            selectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 10,
              height: 1.1,
              color: AppColors.DarkBlue,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 10,
              height: 1.1,
              color: const Color(0xFF4D4D4D),
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor: Colors.transparent,
            onTap: navigationItemTap,
            items: [
              _navItem(AppIcons.explore, AppIcons.explore, 'Home'),
              _navItem(AppIcons.parking, AppIcons.parking, 'Parking'),
              _navItem(AppIcons.services, AppIcons.services, 'Services'),
              _navItem(AppIcons.prices, AppIcons.prices, 'Prices'),
              _navItem(AppIcons.notification, AppIcons.notification, 'Alerts'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
    String unselected,
    String selected,
    String label,
  ) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        unselected,
        height: 21,
        width: 21,
        colorFilter: const ColorFilter.mode(
          AppColors.DarkGray,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        selected,
        height: 22,
        width: 22,
        colorFilter: const ColorFilter.mode(
          AppColors.DarkBlue,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
