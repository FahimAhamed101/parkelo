import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/AppColor/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.13;
    return Container(
      width: double.infinity,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF0F3377),
            Color(0xFF174FB5),
          ],
          stops: [-0.0157, 1.0118],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Conditionally show back button
              showBackButton
                  ? InkWell(
                onTap: onBackTap ?? () => Get.back(),
                borderRadius: BorderRadius.circular(12,), // optional for ripple
                child: Padding(
                  padding: const EdgeInsets.all(12,), // increases touch area
                  child: SvgPicture.asset(
                    "assets/icons/backIcon.svg",
                    color: AppColors.bgPrimary,
                  ),
                ),
              )
                  : const SizedBox(width: 48), // match the tappable width

              // Title in center
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    color: AppColors.bgPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Spacer for balance
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height *
        0.15,
  );
}