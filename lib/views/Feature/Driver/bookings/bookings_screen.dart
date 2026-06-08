import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/appColor/app_colors.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String selectedFilter = 'All';
  bool isCheckedIn = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                  gradient: AppColors.gradGreenBar,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'My\nreservations',
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          height: 1.18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: [
                          _buildFilterChip('All', Icons.tune_rounded),
                          const SizedBox(width: 6),
                          _buildFilterChip('Quick', Icons.bolt_rounded),
                          const SizedBox(width: 6),
                          _buildFilterChip('Pending', Icons.hourglass_empty),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildActiveTab(),
                    _buildSimpleList('No requests yet'),
                    _buildSimpleList('No reservation history yet'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blueLt : AppColors.bg,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: label == 'Quick'
                  ? AppColors.orange
                  : isSelected
                  ? AppColors.blue
                  : AppColors.textSub,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.blue : AppColors.textSub,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: TabBar(
        indicatorColor: AppColors.blue,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.blue,
        unselectedLabelColor: AppColors.textFaint,
        labelStyle: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        tabs: const [
          Tab(text: 'Active'),
          Tab(text: 'Requests'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 20),
      children: [
        Row(children: [_buildModePill(), const Spacer(), _buildChatButton()]),
        const SizedBox(height: 8),
        isCheckedIn
            ? _CheckedInReservationCard(
                onCheckOut: () {
                  setState(() {
                    isCheckedIn = false;
                  });
                },
              )
            : _PendingReservationCard(
                onOccupiedTap: _showOccupiedBottomSheet,
                onScanTap: () async {
                  final result = await Get.toNamed(AppRoutes.scanningScreen);
                  if (result == true) {
                    setState(() {
                      isCheckedIn = true;
                    });
                  }
                },
              ),
      ],
    );
  }

  Widget _buildModePill() {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: AppColors.greenLt,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.greenMid),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 13, color: AppColors.green),
          const SizedBox(width: 5),
          Text(
            'Automatic',
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.blueMid),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 15,
            color: AppColors.blue,
          ),
          const SizedBox(width: 6),
          Text(
            'Chat',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleList(String text) {
    return Center(
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textSub,
        ),
      ),
    );
  }

  void _showOccupiedBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          decoration: const BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderMd,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Parking space occupied',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This space is currently occupied. You can wait for it to clear or contact support through chat.',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSub,
                ),
              ),
              const SizedBox(height: 18),
              _WarningActionButton(
                text: 'Got it',
                color: AppColors.blue,
                textColor: Colors.white,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PendingReservationCard extends StatelessWidget {
  final VoidCallback onOccupiedTap;
  final VoidCallback onScanTap;

  const _PendingReservationCard({
    required this.onOccupiedTap,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadowMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(17, 13, 16, 12),
            decoration: const BoxDecoration(gradient: AppColors.gradPrivate),
            child: Row(
              children: [
                const _ReservationPinLogo(),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parking Colonial\nPremium',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Today - 10:30 - 12:30',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 118,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.34),
                    ),
                  ),
                  child: Text(
                    'Pending check-in',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 3,
            decoration: const BoxDecoration(gradient: AppColors.gradGreenBar),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _DetailBlock('License Plate', 'A123456')),
                    _DetailBlock(
                      'Booking',
                      'RD\$150 x 2h',
                      alignEnd: true,
                      valueColor: AppColors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _WarningActionButton(
                  text: 'Parking occupied',
                  color: AppColors.warnBg,
                  textColor: AppColors.warn,
                  borderColor: AppColors.warnBd,
                  icon: Icons.warning_amber_rounded,
                  onTap: onOccupiedTap,
                ),
                const SizedBox(height: 9),
                _WarningActionButton(
                  text: 'Scan QR - Check-in',
                  color: AppColors.green,
                  textColor: Colors.white,
                  icon: Icons.qr_code_2_rounded,
                  onTap: onScanTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckedInReservationCard extends StatelessWidget {
  final VoidCallback onCheckOut;

  const _CheckedInReservationCard({required this.onCheckOut});

  @override
  Widget build(BuildContext context) {
    return _PendingReservationCard(onOccupiedTap: () {}, onScanTap: onCheckOut);
  }
}

class _DetailBlock extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;
  final Color? valueColor;

  const _DetailBlock(
    this.label,
    this.value, {
    this.alignEnd = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textFaint,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: valueColor ?? AppColors.text,
          ),
        ),
      ],
    );
  }
}

class _WarningActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final IconData? icon;
  final VoidCallback onTap;

  const _WarningActionButton({
    required this.text,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 46,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservationPinLogo extends StatelessWidget {
  const _ReservationPinLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 29,
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 38,
            color: AppColors.blueSky.withValues(alpha: 0.95),
          ),
          Positioned(
            top: 5,
            child: Text(
              'P',
              style: GoogleFonts.nunito(
                fontSize: 15,
                height: 1,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const Positioned(
            bottom: 11,
            child: Icon(
              Icons.directions_car_filled_rounded,
              size: 9,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
