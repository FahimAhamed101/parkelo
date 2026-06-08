import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/appColor/app_colors.dart';

enum HostPanelTab { panel, parking, services, prices, alerts }

class HostPanelScaffold extends StatelessWidget {
  const HostPanelScaffold({
    super.key,
    required this.selectedTab,
    required this.child,
    this.backgroundColor = const Color(0xFFF3F7FC),
  });

  final HostPanelTab selectedTab;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            HostPanelHeader(selectedTab: selectedTab),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class HostPanelHeader extends StatelessWidget {
  const HostPanelHeader({super.key, required this.selectedTab});

  final HostPanelTab selectedTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1F59B8), Color(0xFF08934C)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 12, 11),
              child: Row(
                children: [
                  const _HostLogo(),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panel Host',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: AppColors.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Parking Colonial Premium',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: AppColors.textSub,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _HeaderButton(
                    icon: Icons.grid_view_rounded,
                    backgroundColor: const Color(0xFFE8F8F0),
                    foregroundColor: const Color(0xFF08934C),
                    onTap: () => Get.offAllNamed('/host_bottom_nav'),
                  ),
                  const SizedBox(width: 9),
                  _HeaderButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    backgroundColor: const Color(0xFFF7FAFF),
                    foregroundColor: AppColors.blue,
                    badgeCount: 3,
                    onTap: () =>
                        Get.offAllNamed('/host_bottom_nav', arguments: 4),
                  ),
                ],
              ),
            ),
            HostPanelTabs(selectedTab: selectedTab),
            const Divider(height: 1, color: Color(0xFFE5EBF5)),
          ],
        ),
      ),
    );
  }
}

class HostPanelTabs extends StatelessWidget {
  const HostPanelTabs({super.key, required this.selectedTab});

  final HostPanelTab selectedTab;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('Panel', HostPanelTab.panel, 0),
      ('Parking', HostPanelTab.parking, 1),
      ('Services', HostPanelTab.services, 2),
      ('Prices', HostPanelTab.prices, 3),
      ('Alerts', HostPanelTab.alerts, 4),
    ];

    return SizedBox(
      height: 39,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _HeaderTab(
                label: tab.$1,
                selected: tab.$2 == selectedTab,
                onTap: () {
                  Get.offAllNamed('/host_bottom_nav', arguments: tab.$3);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _HostLogo extends StatelessWidget {
  const _HostLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF164AA1), Color(0xFF1F66D1)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.location_on_rounded, color: Color(0xFF39B5FF), size: 29),
          Positioned(
            top: 8,
            child: Text(
              'P',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.badgeCount,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: 39,
            height: 39,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD5E5F7)),
            ),
            child: Icon(icon, color: foregroundColor, size: 21),
          ),
        ),
        if (badgeCount != null)
          Positioned(
            right: -3,
            top: -4,
            child: Container(
              width: 15,
              height: 15,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFE11D48),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badgeCount',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: selected ? AppColors.blue : AppColors.textFaint,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2,
            width: selected ? 52 : 0,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF08934C) : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}
