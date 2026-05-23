import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/AppColor/app_colors.dart';
import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';


class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool allNotifications = true;
  bool bookingNotifications = true;
  bool reminderNotifications = true;
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Account settings"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText("Notifications", fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                          Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Column(
                        children: [
                          _buildToggleRow("All", allNotifications, (val) {
                            setState(() {
                              allNotifications = val;
                              if (val) {
                                bookingNotifications = true;
                                reminderNotifications = true;
                              } else {
                                bookingNotifications = false;
                                reminderNotifications = false;
                              }
                            });
                          }),
                          const SizedBox(height: 12),
                          _buildToggleRow("Booking", bookingNotifications, (val) {
                            setState(() {
                              bookingNotifications = val;
                              if (!val) allNotifications = false;
                              if (bookingNotifications && reminderNotifications) allNotifications = true;
                            });
                          }),
                          const SizedBox(height: 12),
                          _buildToggleRow("Reminder", reminderNotifications, (val) {
                            setState(() {
                              reminderNotifications = val;
                              if (!val) allNotifications = false;
                              if (bookingNotifications && reminderNotifications) allNotifications = true;
                            });
                          }),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(title, fontSize: 13, color: AppColors.Primary, fontWeight: FontWeight.w500),
        SizedBox(
          height: 24,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.Primary,
            inactiveTrackColor: Colors.grey.shade300,
            inactiveThumbColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
