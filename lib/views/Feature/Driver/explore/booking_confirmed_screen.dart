import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Confirmed", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Check icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF22C55E), width: 3),
              ),
              child: const Icon(Icons.check_rounded, color: Color(0xFF22C55E), size: 44),
            ),
            const SizedBox(height: 20),

            AppText(
              "Booking confirmed!",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.DarkBlue,
            ),
            const SizedBox(height: 8),
            AppText(
              "Your space at Parking Colonial\nPremium is ready!",
              fontSize: 14,
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Map + location card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Map placeholder
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: SizedBox(
                      height: 160,
                      child: Stack(
                        children: [
                          // Map grid background
                          Positioned.fill(
                            child: CustomPaint(painter: _MapPainter()),
                          ),
                          // "See how to get there" pill
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on_outlined, color: AppColors.Primary, size: 16),
                                  const SizedBox(width: 6),
                                  AppText("See how to get there", fontSize: 13, color: AppColors.Primary, fontWeight: FontWeight.w600),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Location info row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText("Parking Colonial Premium", fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                              const SizedBox(height: 4),
                              AppText("Colonial Zone, SD", fontSize: 12, color: Colors.grey.shade500),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on, color: Colors.black87, size: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // QR + booking details card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR code
                  Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomPaint(painter: _QrPainter()),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 90,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppText("SCAN UPON ENTRY", fontSize: 8, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Details
                  Expanded(
                    child: Column(
                      children: [
                        _DetailRow(label: "Parking", value: "Parking Colonial\nPremium", valueBold: true),
                        const SizedBox(height: 12),
                        _DetailRow(label: "Duration", value: "2 hours", valueBold: true),
                        const SizedBox(height: 12),
                        _DetailRow(label: "Total", value: "RD\$379", valueColor: AppColors.Primary, valueBold: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 13, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Flexible(
          child: AppText(
            value,
            fontSize: 13,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? Colors.black87,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// Simple map grid painter
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8E9EC);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final road = Paint()..color = Colors.white..strokeWidth = 8;
    final thin = Paint()..color = Colors.white..strokeWidth = 3;

    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.4), road);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), thin);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), road);
    canvas.drawLine(Offset(size.width * 0.65, 0), Offset(size.width * 0.65, size.height), thin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// Simple QR-like pattern painter
class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.black87;
    final cell = size.width / 7;

    // Corner squares
    void drawCorner(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, cell * 3, cell * 3), p);
      canvas.drawRect(Rect.fromLTWH(x + cell * 0.5, y + cell * 0.5, cell * 2, cell * 2), Paint()..color = Colors.white);
      canvas.drawRect(Rect.fromLTWH(x + cell, y + cell, cell, cell), p);
    }

    drawCorner(0, 0);
    drawCorner(cell * 4, 0);
    drawCorner(0, cell * 4);

    // Random dots in center
    final dots = [
      [3, 0], [4, 1], [3, 2], [5, 2], [3, 3],
      [4, 4], [5, 5], [6, 4], [4, 6], [6, 6],
    ];
    for (final d in dots) {
      canvas.drawRect(Rect.fromLTWH(d[0] * cell, d[1] * cell, cell * 0.8, cell * 0.8), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
