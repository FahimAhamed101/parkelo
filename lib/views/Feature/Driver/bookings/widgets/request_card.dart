import 'package:flutter/material.dart';
import '../../../../../utils/appColor/app_colors.dart';
import '../../../../base/AppText/appText.dart';

class RequestCardModel {
  final String title;
  final String dateTime;
  final String licensePlate;
  final String statusLabel;
  final Color statusColor;
  final Color statusBgColor;
  final String approvalLabel;
  final Color approvalColor;
  final Color approvalBgColor;
  final String message;
  final IconData messageIcon;

  const RequestCardModel({
    required this.title,
    required this.dateTime,
    required this.licensePlate,
    required this.statusLabel,
    required this.statusColor,
    required this.statusBgColor,
    required this.approvalLabel,
    required this.approvalColor,
    required this.approvalBgColor,
    required this.message,
    required this.messageIcon,
  });
}

class RequestCard extends StatelessWidget {
  final RequestCardModel data;
  final VoidCallback? onMessageHost;

  const RequestCard({super.key, required this.data, this.onMessageHost});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue gradient header
          Container(
            height: 90,
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
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + badges
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText(
                        data.title,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _Badge(
                          label: data.statusLabel,
                          color: data.statusColor,
                          bgColor: data.statusBgColor,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        _Badge(
                          label: data.approvalLabel,
                          color: data.approvalColor,
                          bgColor: data.approvalBgColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppText(data.dateTime, fontSize: 12, color: Colors.grey.shade600),
                const SizedBox(height: 2),
                AppText(
                  "License Plate: ${data.licensePlate}",
                  fontSize: 12,
                  color: AppColors.Primary,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 12),

                // Info message box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(data.messageIcon, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppText(
                          data.message,
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Message host button
                GestureDetector(
                  onTap: onMessageHost,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.Primary, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      "Message host",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.Primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  final FontWeight fontWeight;

  const _Badge({
    required this.label,
    required this.color,
    required this.bgColor,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(label, fontSize: 11, fontWeight: fontWeight, color: color),
    );
  }
}
