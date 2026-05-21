import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/appColor/app_colors.dart';
import '../Ios_effect/iosTapEffect.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double borderRadius;
  final bool isLoading;
  final bool showAdd;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = AppColors.Primary,
    this.borderRadius = 12,
    this.isLoading = false,
    this.showAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return IosTapEffect(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: const Color(0xFF0081E7),
            width: 1,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius > 0 ? borderRadius - 1 : 0),
            border: Border(
              top: BorderSide(
                color: Color(0xFFE1EFFE),
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CupertinoActivityIndicator(
                      radius: 12,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showAdd) ...[
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE1EFFE),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}