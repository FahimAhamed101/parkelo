import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import 'booking_flow_models.dart';
import 'widgets/driver_flow_nav_bar.dart';

class ParkingDetailsScreen extends StatefulWidget {
  const ParkingDetailsScreen({super.key});

  @override
  State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  static const List<String> _arrivalTimes = [
    '7:00 AM',
    '7:30 AM',
    '8:00 AM',
    '8:30 AM',
  ];
  static const List<int> _durations = [1, 2, 4, 6, 8, 12];

  late BookingDraft _draft;
  late bool _fromFavorites;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _fromFavorites =
        args is Map<String, dynamic> && args['fromFavorites'] == true;
    _draft = BookingDraft.fromMap(args is Map<String, dynamic> ? args : null);
  }

  bool get _isToday {
    final now = DateTime.now();
    return _draft.date.year == now.year &&
        _draft.date.month == now.month &&
        _draft.date.day == now.day;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _draft.date,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.blue,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _draft = _draft.copyWith(date: picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const DriverFlowNavBar(selectedIndex: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 14),
                  _buildManagedByCard(),
                  const SizedBox(height: 14),
                  _buildAvailableService(),
                  const SizedBox(height: 20),
                  AppText(
                    'When are you arriving?',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: 14),
                  _buildDateSelector(),
                  const SizedBox(height: 14),
                  _sectionLabel('Arrival time'),
                  const SizedBox(height: 8),
                  _buildTimeSelector(),
                  const SizedBox(height: 14),
                  _sectionLabel('Duration'),
                  const SizedBox(height: 8),
                  _buildDurationSelector(),
                  const SizedBox(height: 20),
                  _buildSwitches(),
                  if (_draft.insuranceEnabled) ...[
                    const SizedBox(height: 14),
                    _buildProtectionBanner(),
                  ],
                  const SizedBox(height: 20),
                  _buildPriceSummary(),
                  const SizedBox(height: 18),
                  _buildBottomBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Stack(
      children: [
        Container(
          height: 248,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.gradPrivate),
          child: Stack(
            children: [
              Positioned(
                left: -40,
                top: 80,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                right: -30,
                bottom: 18,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _HeroParkingPin(),
                      SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _HeroMetaChip(label: 'Metro L1 - 200m'),
                          _HeroMetaChip(label: 'OMSA - 50m'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 14,
          child: _circleTopButton(
            onTap: () => Get.back(),
            icon: Icons.arrow_back_ios_new_rounded,
          ),
        ),
        if (!_fromFavorites)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 14,
            child: _circleTopButton(
              onTap: () {},
              icon: Icons.favorite_border_rounded,
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppText(
                _draft.parkingName,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Icon(Icons.star_rounded, color: AppColors.text, size: 17),
            const SizedBox(width: 4),
            AppText(
              _draft.rating.toStringAsFixed(2),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppText(_draft.zoneLabel, fontSize: 12, color: AppColors.textSub),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTag('Public', AppColors.greenLt, AppColors.green),
            const SizedBox(width: 8),
            _buildTag('24/7', AppColors.blueLt, AppColors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.25)),
      ),
      child: AppText(
        text,
        fontSize: 11,
        color: textColor,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildManagedByCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadow,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.blueLt,
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Managed by Parkealo',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
                const SizedBox(height: 4),
                AppText(
                  '${_draft.reviews} reviews - Verified',
                  fontSize: 11,
                  color: AppColors.textSub,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.greenLt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.greenMid),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 14,
                ),
                const SizedBox(width: 4),
                AppText(
                  'Verified',
                  fontSize: 11,
                  color: AppColors.green,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableService() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppText(
            'Available services',
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ServicePill(icon: Icons.roofing_outlined, label: 'Covered'),
              _ServicePill(
                icon: Icons.electric_car_outlined,
                label: 'Charge EV',
              ),
              _ServicePill(icon: Icons.videocam_outlined, label: 'Cameras'),
              _ServicePill(icon: Icons.security_outlined, label: 'Valet'),
              _ServicePill(icon: Icons.access_time_rounded, label: '24/7'),
              _ServicePill(
                icon: Icons.lock_outline_rounded,
                label: 'Ctrl. access',
              ),
              _ServicePill(
                icon: Icons.person_outline_rounded,
                label: 'Personal',
              ),
              _ServicePill(
                icon: Icons.block_outlined,
                label: 'Private',
                muted: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Date'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                if (_isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueLt,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AppText(
                      'TODAY',
                      fontSize: 11,
                      color: AppColors.blue,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                if (_isToday) const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    _isToday ? 'Today' : _draft.fullDateLabel,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textFaint,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _arrivalTimes.map((time) {
        final isSelected = _draft.arrivalTime == time;
        return GestureDetector(
          onTap: () {
            setState(() {
              _draft = _draft.copyWith(arrivalTime: time);
            });
          },
          child: Container(
            width: 75,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.blue : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: AppText(
              time,
              fontSize: 11,
              color: isSelected ? AppColors.blue : AppColors.text,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDurationSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _durations.map((duration) {
        final isSelected = _draft.durationHours == duration;
        final label = duration == 12 ? 'All day' : '${duration}h';
        return GestureDetector(
          onTap: () {
            setState(() {
              _draft = _draft.copyWith(durationHours: duration);
            });
          },
          child: Container(
            width: 51,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.green : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: AppText(
              label,
              fontSize: label == 'All day' ? 10 : 11,
              color: isSelected ? AppColors.green : AppColors.text,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwitches() {
    return Column(
      children: [
        _buildSwitchRow(
          'Book for another person',
          'Enter the license plate of the vehicle to park.',
          _draft.bookForAnotherPerson,
          (value) {
            setState(() {
              _draft = _draft.copyWith(bookForAnotherPerson: value);
            });
          },
        ),
        const SizedBox(height: 16),
        _buildSwitchRow(
          'Insurance - RD\$25',
          'Protects up to RD\$3,000 in vehicle damages during the reservation.',
          _draft.insuranceEnabled,
          (value) {
            setState(() {
              _draft = _draft.copyWith(insuranceEnabled: value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildSwitchRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(title, fontSize: 13, fontWeight: FontWeight.w900),
              const SizedBox(height: 4),
              AppText(subtitle, fontSize: 11, color: AppColors.textSub),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _AdvancedSwitch(value: value, onChanged: onChanged),
      ],
    );
  }

  Widget _buildProtectionBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.greenLt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greenMid),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              'Active protection during your ${_draft.durationHours}h stay',
              fontSize: 11,
              color: AppColors.green,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Price summary', fontSize: 14, fontWeight: FontWeight.w900),
        const SizedBox(height: 12),
        _buildPriceRow(
          'RD\$${_draft.pricePerHour} x ${_draft.durationHours} hours',
          'RD\$${_draft.subtotal}',
        ),
        if (_draft.insuranceEnabled) ...[
          const SizedBox(height: 8),
          _buildPriceRow('Insurance', 'RD\$${_draft.insuranceFee}'),
        ],
        const SizedBox(height: 8),
        _buildPriceRow('ITBIS (18%)', 'RD\$${_draft.tax}'),
        const SizedBox(height: 8),
        _buildPriceRow('Service fee', 'RD\$${_draft.serviceFee}'),
        const SizedBox(height: 14),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              'Estimated total - ${_draft.durationHours}h',
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.green,
            ),
            AppText(
              'RD\$${_draft.total}',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, fontSize: 12, color: AppColors.textSub),
        AppText(
          amount,
          fontSize: 12,
          color: AppColors.text,
          fontWeight: FontWeight.w800,
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'RD\$${_draft.pricePerHour}',
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
            AppText(
              '/ hour',
              fontSize: 12,
              color: AppColors.textSub,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        GestureDetector(
          onTap: _showSecurityReminder,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: AppText(
              'Book',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  void _showSecurityReminder() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
              const SizedBox(height: 18),
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blueLt,
                  border: Border.all(color: AppColors.blueMid),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.blue,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              AppText(
                'Security reminder',
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
              const SizedBox(height: 10),
              Text(
                'Do not leave valuables inside your vehicle. Parkealo is not responsible for losses or damage during the reservation.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSub,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _sheetButton(
                      label: 'Cancel',
                      onTap: () => Navigator.pop(sheetContext),
                      isPrimary: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _sheetButton(
                      label: 'Understood',
                      onTap: () {
                        Navigator.pop(sheetContext);
                        Get.toNamed(
                          AppRoutes.confirmPayScreen,
                          arguments: _draft.toMap(),
                        );
                      },
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sheetButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.green : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPrimary ? AppColors.green : AppColors.borderMd,
          ),
        ),
        child: AppText(
          label,
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: isPrimary ? Colors.white : AppColors.text,
        ),
      ),
    );
  }

  Widget _circleTopButton({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return AppText(
      label.toUpperCase(),
      fontSize: 11,
      fontWeight: FontWeight.w900,
      color: AppColors.textSub,
    );
  }
}

class _AdvancedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AdvancedSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? AppColors.green : AppColors.borderMd,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroParkingPin extends StatelessWidget {
  const _HeroParkingPin();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 108,
            color: AppColors.blueSky.withValues(alpha: 0.98),
          ),
          Positioned(
            top: 18,
            child: Text(
              'P',
              style: GoogleFonts.nunito(
                fontSize: 42,
                height: 1,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const Positioned(
            bottom: 28,
            child: Icon(
              Icons.directions_car_filled_rounded,
              size: 22,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetaChip extends StatelessWidget {
  final String label;

  const _HeroMetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ServicePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool muted;

  const _ServicePill({
    required this.icon,
    required this.label,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = muted ? AppColors.surface2 : AppColors.greenLt;
    final border = muted ? AppColors.border : AppColors.greenMid;
    final color = muted ? AppColors.textFaint : AppColors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
