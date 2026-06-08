import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import 'booking_flow_models.dart';
import 'widgets/driver_flow_nav_bar.dart';

class BookingConfirmedScreen extends StatefulWidget {
  const BookingConfirmedScreen({super.key});

  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen> {
  late BookingDraft _draft;

  static final Uri _googleMapsUri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=18.4697,-69.8870',
  );
  static final Uri _appleMapsUri = Uri.parse(
    'http://maps.apple.com/?daddr=18.4697,-69.8870',
  );
  static final Uri _wazeUri = Uri.parse(
    'https://waze.com/ul?ll=18.4697,-69.8870&navigate=yes',
  );

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _draft = BookingDraft.fromMap(args is Map<String, dynamic> ? args : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const DriverFlowNavBar(selectedIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 54, 16, 20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.green, width: 2),
                color: AppColors.greenLt,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.green,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            AppText(
              'Booking confirmed!',
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
            const SizedBox(height: 8),
            AppText(
              'Your space at ${_draft.parkingName} is\nready for check-in.',
              fontSize: 14,
              color: AppColors.textSub,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: SizedBox(
                      height: 160,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(painter: _MapPainter()),
                          ),
                          const Positioned(
                            left: 58,
                            top: 22,
                            child: _MapLocationPin(),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: _showMapsOptions,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.near_me_rounded,
                                      color: AppColors.blue,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    AppText(
                                      'See how to get there',
                                      fontSize: 13,
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                _draft.parkingName,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                _draft.location,
                                fontSize: 12,
                                color: AppColors.textSub,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.text,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomPaint(painter: _QrPainter()),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 90,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        'SCAN ON ENTRY',
                        fontSize: 8,
                        color: AppColors.textFaint,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _DetailRow(
                          label: 'Parking',
                          value: _draft.parkingName,
                          valueBold: true,
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Duration',
                          value: _draft.durationLabel,
                          valueBold: true,
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Total',
                          value: 'RD\$${_draft.total}',
                          valueBold: true,
                          valueColor: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMapsOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderMd,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  'Open with...',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  '${_draft.parkingName} - ${_draft.location}',
                  fontSize: 11,
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _MapAppTile(
                icon: Icons.map_outlined,
                title: 'Google Maps',
                subtitle: 'Open in Google Maps',
                onTap: () => _launchMap(_googleMapsUri, sheetContext),
              ),
              const SizedBox(height: 10),
              _MapAppTile(
                icon: Icons.navigation_outlined,
                title: 'Apple Maps',
                subtitle: 'Open in Apple Maps',
                onTap: () => _launchMap(_appleMapsUri, sheetContext),
              ),
              const SizedBox(height: 10),
              _MapAppTile(
                icon: Icons.alt_route_rounded,
                title: 'Waze',
                subtitle: 'Open in Waze',
                onTap: () => _launchMap(_wazeUri, sheetContext),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pop(sheetContext),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    'Cancel',
                    fontSize: 13,
                    color: AppColors.textSub,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchMap(Uri uri, BuildContext sheetContext) async {
    Navigator.pop(sheetContext);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the selected navigation app.'),
        ),
      );
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: AppText(label, fontSize: 13, color: AppColors.textSub)),
        Expanded(
          child: AppText(
            value,
            fontSize: 13,
            fontWeight: valueBold ? FontWeight.w900 : FontWeight.w700,
            color: valueColor ?? AppColors.text,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFEAF1F9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 8;
    final thin = Paint()
      ..color = const Color(0xFFD2DEEF)
      ..strokeWidth = 2.5;

    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      thin,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, 0),
      Offset(size.width * 0.65, size.height),
      thin,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black87;
    final cell = size.width / 7;

    void drawCorner(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, cell * 3, cell * 3), paint);
      canvas.drawRect(
        Rect.fromLTWH(x + cell * 0.5, y + cell * 0.5, cell * 2, cell * 2),
        Paint()..color = Colors.white,
      );
      canvas.drawRect(Rect.fromLTWH(x + cell, y + cell, cell, cell), paint);
    }

    drawCorner(0, 0);
    drawCorner(cell * 4, 0);
    drawCorner(0, cell * 4);

    final dots = [
      [3, 0],
      [4, 1],
      [3, 2],
      [5, 2],
      [3, 3],
      [4, 4],
      [5, 5],
      [6, 4],
      [4, 6],
      [6, 6],
    ];
    for (final dot in dots) {
      canvas.drawRect(
        Rect.fromLTWH(dot[0] * cell, dot[1] * cell, cell * 0.8, cell * 0.8),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapLocationPin extends StatelessWidget {
  const _MapLocationPin();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 32,
            color: AppColors.blue,
          ),
          Positioned(
            top: 6,
            child: Text(
              'P',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapAppTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MapAppTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.blue, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title, fontSize: 14, fontWeight: FontWeight.w900),
                  const SizedBox(height: 2),
                  AppText(
                    subtitle,
                    fontSize: 11,
                    color: AppColors.textSub,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textFaint,
            ),
          ],
        ),
      ),
    );
  }
}
