import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/appColor/app_colors.dart';

enum _AdminTab { global, users, finance, parkings }

enum _DateRange { today, sevenDays, month, year }

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  _AdminTab _selectedTab = _AdminTab.global;
  _DateRange _selectedRange = _DateRange.today;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.blueNav,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.bg,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            _AdminHeader(
              selectedTab: _selectedTab,
              onTabChanged: (tab) => setState(() => _selectedTab = tab),
            ),
            _RangeSelector(
              selectedRange: _selectedRange,
              onRangeChanged: (range) => setState(() => _selectedRange = range),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _TabContent(
                    key: ValueKey(_selectedTab),
                    tab: _selectedTab,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({required this.selectedTab, required this.onTabChanged});

  final _AdminTab selectedTab;
  final ValueChanged<_AdminTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Row(
                children: [
                  const _ParkealoMark(),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Parkealo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.bg,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const _AdminBadge(),
                  const SizedBox(width: 10),
                  const _OnlinePill(),
                ],
              ),
            ),
            _AdminTabs(selectedTab: selectedTab, onTabChanged: onTabChanged),
          ],
        ),
      ),
    );
  }
}

class _ParkealoMark extends StatelessWidget {
  const _ParkealoMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 30,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: Color(0xFF5AC8FA),
            size: 30,
          ),
          Positioned(
            top: 4,
            child: Text(
              'P',
              style: GoogleFonts.nunito(
                color: AppColors.bg,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
          Positioned(
            bottom: 7,
            child: Container(
              width: 14,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                color: AppColors.blueSky,
                size: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminBadge extends StatelessWidget {
  const _AdminBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.blueSky.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'ADMIN',
        style: GoogleFonts.nunito(
          color: AppColors.bg,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _OnlinePill extends StatelessWidget {
  const _OnlinePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.greenAcct.withValues(alpha: 0.85)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            '1,290 online',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: AppColors.lightGreen,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminTabs extends StatelessWidget {
  const _AdminTabs({required this.selectedTab, required this.onTabChanged});

  final _AdminTab selectedTab;
  final ValueChanged<_AdminTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_AdminTab.global, Icons.bar_chart_rounded, 'Global'),
      (_AdminTab.users, Icons.group_rounded, 'Users'),
      (_AdminTab.finance, Icons.savings_rounded, 'Finance'),
      (_AdminTab.parkings, Icons.local_parking_rounded, 'Parking'),
    ];

    return SizedBox(
      height: 42,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _AdminTabButton(
                tab: tab.$1,
                icon: tab.$2,
                label: tab.$3,
                isSelected: selectedTab == tab.$1,
                onTap: () => onTabChanged(tab.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class _AdminTabButton extends StatelessWidget {
  const _AdminTabButton({
    required this.tab,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final _AdminTab tab;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 13,
                    color: isSelected ? AppColors.bg : AppColors.blueMid,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    maxLines: 1,
                    style: GoogleFonts.nunito(
                      color: isSelected ? AppColors.bg : AppColors.blueMid,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 11),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.gradGreenBar : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({
    required this.selectedRange,
    required this.onRangeChanged,
  });

  final _DateRange selectedRange;
  final ValueChanged<_DateRange> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final ranges = [
      (_DateRange.today, 'Today'),
      (_DateRange.sevenDays, '7 days'),
      (_DateRange.month, 'Month'),
      (_DateRange.year, 'Year'),
    ];

    return Container(
      height: 52,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < ranges.length; i++) ...[
            Expanded(
              child: _RangeButton(
                label: ranges[i].$2,
                isSelected: selectedRange == ranges[i].$1,
                onTap: () => onRangeChanged(ranges[i].$1),
              ),
            ),
            if (i != ranges.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _RangeButton extends StatelessWidget {
  const _RangeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        foregroundColor: AppColors.blue,
        backgroundColor: isSelected ? AppColors.blueLt : AppColors.bg,
        side: BorderSide(
          color: isSelected ? AppColors.blue : AppColors.borderMd,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: AppColors.blue,
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({super.key, required this.tab});

  final _AdminTab tab;

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      _AdminTab.global => const _GlobalPanel(),
      _AdminTab.users => const _UsersPanel(),
      _AdminTab.finance => const _FinancePanel(),
      _AdminTab.parkings => const _ParkingsPanel(),
    };
  }
}

class _GlobalPanel extends StatelessWidget {
  const _GlobalPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _MetricGrid(
          metrics: [
            _MetricData(
              value: '1,284',
              label: 'Active users',
              helper: '+47 new',
              icon: Icons.group_rounded,
              accent: AppColors.green,
            ),
            _MetricData(
              value: '312',
              label: 'Bookings',
              helper: 'completed',
              icon: Icons.local_parking_rounded,
              accent: AppColors.blue,
            ),
            _MetricData(
              value: 'RD\$187,450',
              label: 'Platform revenue',
              icon: Icons.savings_rounded,
              accent: AppColors.warn,
            ),
            _MetricData(
              value: 'RD\$28,117',
              label: 'Total commissions',
              icon: Icons.stacked_bar_chart_rounded,
              accent: AppColors.blueNav,
            ),
            _MetricData(
              value: 'RD\$600',
              label: 'Average ticket',
              icon: Icons.confirmation_number_rounded,
              accent: AppColors.green,
            ),
            _MetricData(
              value: '73%',
              label: 'Average occupancy',
              helper: 'across all parking',
              icon: Icons.pin_drop_rounded,
              accent: AppColors.blue,
            ),
          ],
        ),
        SizedBox(height: 16),
        _ParkingStatusCard(),
        SizedBox(height: 16),
        _ReservedTypeCard(),
        SizedBox(height: 16),
        _RegisteredParkingCard(),
      ],
    );
  }
}

class _UsersPanel extends StatelessWidget {
  const _UsersPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _MetricGrid(
          metrics: [
            _MetricData(
              value: '1,284',
              label: 'Total users',
              icon: Icons.group_rounded,
              accent: AppColors.green,
            ),
            _MetricData(
              value: '47',
              label: 'New registrations',
              helper: 'this period',
              icon: Icons.auto_awesome_rounded,
              accent: AppColors.blue,
            ),
          ],
        ),
        SizedBox(height: 16),
        _SimpleBarChartCard(
          title: 'User growth (7 days)',
          values: [62, 69, 80, 74, 85, 92, 98],
          labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          color: AppColors.blue,
        ),
        SizedBox(height: 16),
        _HourlyActivityCard(),
        SizedBox(height: 16),
        _RetentionCard(),
        SizedBox(height: 16),
        _DevicesCard(),
      ],
    );
  }
}

class _FinancePanel extends StatelessWidget {
  const _FinancePanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _MetricGrid(
          metrics: [
            _MetricData(
              value: 'RD\$187,450',
              label: 'Gross revenue',
              icon: Icons.savings_rounded,
              accent: AppColors.green,
            ),
            _MetricData(
              value: 'RD\$28,117',
              label: 'Commission earned',
              helper: '15% commission',
              icon: Icons.stacked_bar_chart_rounded,
              accent: AppColors.blue,
            ),
            _MetricData(
              value: 'RD\$7,800',
              label: 'Service fees',
              icon: Icons.confirmation_number_rounded,
              accent: AppColors.warn,
            ),
            _MetricData(
              value: 'RD\$4,250',
              label: 'Overtime charged',
              icon: Icons.timer_rounded,
              accent: AppColors.danger,
            ),
          ],
        ),
        SizedBox(height: 16),
        _SimpleBarChartCard(
          title: 'Revenue by day (RD\$)',
          values: [64, 76, 70, 86, 80, 95, 84],
          labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          color: AppColors.green,
        ),
        SizedBox(height: 16),
        _DepositsCard(),
        SizedBox(height: 16),
        _PaymentMethodsCard(),
      ],
    );
  }
}

class _ParkingsPanel extends StatelessWidget {
  const _ParkingsPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ActiveZonesCard(),
        SizedBox(height: 16),
        _MostOccupiedCard(),
        SizedBox(height: 16),
        _BusyHoursCard(),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<_MetricData> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final itemWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: 14,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: itemWidth,
                child: _MetricCard(data: metric),
              ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _MetricData data;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      topAccentColor: data.accent,
      child: SizedBox(
        height: 58,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.value,
                      maxLines: 1,
                      style: GoogleFonts.nunito(
                        color: data.accent,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    data.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: AppColors.textSub,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (data.helper != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      data.helper!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: data.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(data.icon, color: data.accent, size: 22),
          ],
        ),
      ),
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.value,
    required this.label,
    required this.icon,
    required this.accent,
    this.helper,
  });

  final String value;
  final String label;
  final String? helper;
  final IconData icon;
  final Color accent;
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.topAccentColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? topAccentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (topAccentColor != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(height: 3, color: topAccentColor),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle, this.leadingIcon});

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, color: AppColors.orange, size: 18),
          const SizedBox(width: 7),
        ],
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(width: 10),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _ParkingStatusCard extends StatelessWidget {
  const _ParkingStatusCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Parking status', subtitle: '47 registered'),
          SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _StatusPill(
                  value: '42',
                  label: 'Active',
                  icon: Icons.check_box_rounded,
                  color: AppColors.green,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatusPill(
                  value: '3',
                  label: 'In review',
                  icon: Icons.pause_rounded,
                  color: AppColors.warn,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _StatusPill(
                  value: '2',
                  label: 'Suspended',
                  icon: Icons.block_rounded,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.38)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 10),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReservedTypeCard extends StatelessWidget {
  const _ReservedTypeCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Reserved parking type'),
          SizedBox(height: 18),
          _StackedBar(
            segments: [
              _SegmentData(value: 68, color: AppColors.blue),
              _SegmentData(value: 32, color: AppColors.green),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _LegendItem(color: AppColors.blue, label: 'Public 68%'),
              Spacer(),
              _LegendItem(color: AppColors.green, label: 'Private 32%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StackedBar extends StatelessWidget {
  const _StackedBar({required this.segments});

  final List<_SegmentData> segments;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 14,
        child: Row(
          children: [
            for (final segment in segments)
              Expanded(
                flex: segment.value,
                child: Container(color: segment.color),
              ),
          ],
        ),
      ),
    );
  }
}

class _SegmentData {
  const _SegmentData({required this.value, required this.color});

  final int value;
  final Color color;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.nunito(
            color: AppColors.textSub,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RegisteredParkingCard extends StatelessWidget {
  const _RegisteredParkingCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Registered parking'),
          SizedBox(height: 16),
          _ParkingAdminRow(
            name: 'Parking Colonial Premium',
            zone: 'Colonial Zone, SD',
          ),
          _ParkingAdminRow(
            name: 'Bella Vista Parking',
            zone: 'Bella Vista, SD',
          ),
          _ParkingAdminRow(
            name: 'VIP Piantini - Private House',
            zone: 'Piantini, SD',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ParkingAdminRow extends StatelessWidget {
  const _ParkingAdminRow({
    required this.name,
    required this.zone,
    this.isLast = false,
  });

  final String name;
  final String zone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  zone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.textSub,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 32,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                backgroundColor: AppColors.dangerBg,
                side: const BorderSide(color: AppColors.dangerBd),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Text(
                'Suspend',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleBarChartCard extends StatelessWidget {
  const _SimpleBarChartCard({
    required this.title,
    required this.values,
    required this.labels,
    required this.color,
  });

  final String title;
  final List<int> values;
  final List<String> labels;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title),
          const SizedBox(height: 22),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < values.length; i++) ...[
                  Expanded(
                    child: _BarColumn(
                      value: values[i],
                      maxValue: maxValue,
                      label: labels[i],
                      color: color,
                    ),
                  ),
                  if (i != values.length - 1) const SizedBox(width: 4),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    required this.value,
    required this.maxValue,
    required this.label,
    required this.color,
  });

  final int value;
  final int maxValue;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final normalized = maxValue == 0 ? 0.0 : value / maxValue;
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: normalized.clamp(0.08, 1.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: GoogleFonts.nunito(
            color: AppColors.textFaint,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HourlyActivityCard extends StatelessWidget {
  const _HourlyActivityCard();

  @override
  Widget build(BuildContext context) {
    const values = [
      6,
      0,
      0,
      18,
      31,
      70,
      56,
      42,
      48,
      75,
      62,
      50,
      45,
      55,
      68,
      74,
      63,
      48,
      32,
      24,
      7,
    ];
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Activity by hour'),
          const SizedBox(height: 18),
          SizedBox(
            height: 92,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final value in values) ...[
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: (value / 75).clamp(0.04, 1),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in ['12am', '4am', '8am', '12pm', '4pm', '8pm'])
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    color: AppColors.textFaint,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.greenLt,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Peak time: 5:00 PM - 7:00 PM. Max peak at 6pm with 504 users',
              style: GoogleFonts.nunito(
                color: AppColors.green,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RetentionCard extends StatelessWidget {
  const _RetentionCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'User retention'),
          SizedBox(height: 18),
          _PercentRow(
            label: 'Use the app more than once',
            value: '84%',
            color: AppColors.green,
          ),
          _PercentRow(
            label: 'Book at least once per week',
            value: '61%',
            color: AppColors.blue,
          ),
          _PercentRow(
            label: 'Used chat with a host',
            value: '38%',
            color: AppColors.warn,
          ),
          _PercentRow(
            label: 'Extended time',
            value: '22%',
            color: AppColors.blueNav,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _PercentRow extends StatelessWidget {
  const _PercentRow({
    required this.label,
    required this.value,
    required this.color,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: AppColors.textSub,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DevicesCard extends StatelessWidget {
  const _DevicesCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Devices'),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _DeviceTile(
                  icon: Icons.phone_iphone_rounded,
                  value: '58%',
                  label: 'iOS',
                  color: AppColors.blue,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _DeviceTile(
                  icon: Icons.smart_toy_rounded,
                  value: '36%',
                  label: 'Android',
                  color: AppColors.green,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _DeviceTile(
                  icon: Icons.laptop_mac_rounded,
                  value: '6%',
                  label: 'Web',
                  color: AppColors.textSub,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 9),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: AppColors.textFaint,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DepositsCard extends StatelessWidget {
  const _DepositsCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Host deposits'),
          SizedBox(height: 18),
          _DepositRow(
            host: 'J. Martinez',
            parking: 'Colonial Premium',
            amount: 'RD\$45,200',
            pending: 'Pending: RD\$8,400',
            commission: 'Commission: RD\$6,780',
          ),
          _DepositRow(
            host: 'M. Garcia',
            parking: 'Bella Vista',
            amount: 'RD\$30,600',
            pending: 'Pending: RD\$5,100',
            commission: 'Commission: RD\$4,590',
          ),
          _DepositRow(
            host: 'R. Perez',
            parking: 'VIP Piantini',
            amount: 'RD\$27,400',
            pending: 'Pending: RD\$3,200',
            commission: 'Commission: RD\$4,110',
          ),
          _DepositRow(
            host: 'A. Rodriguez',
            parking: 'Naco Center',
            amount: 'RD\$19,800',
            pending: 'Pending: RD\$2,600',
            commission: 'Commission: RD\$2,970',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _DepositRow extends StatelessWidget {
  const _DepositRow({
    required this.host,
    required this.parking,
    required this.amount,
    required this.pending,
    required this.commission,
    this.isLast = false,
  });

  final String host;
  final String parking;
  final String amount;
  final String pending;
  final String commission;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  host,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  parking,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.textSub,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blueLt,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    commission,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: AppColors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                maxLines: 1,
                style: GoogleFonts.nunito(
                  color: AppColors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                pending,
                maxLines: 1,
                style: GoogleFonts.nunito(
                  color: AppColors.textFaint,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodsCard extends StatelessWidget {
  const _PaymentMethodsCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Payment methods'),
          SizedBox(height: 18),
          _StackedBar(
            segments: [
              _SegmentData(value: 62, color: AppColors.blue),
              _SegmentData(value: 28, color: AppColors.warn),
              _SegmentData(value: 10, color: AppColors.green),
            ],
          ),
          SizedBox(height: 14),
          _PaymentMethodRow(color: AppColors.blue, label: 'Card', value: '62%'),
          _PaymentMethodRow(color: AppColors.warn, label: 'Cash', value: '28%'),
          _PaymentMethodRow(
            color: AppColors.green,
            label: 'Wallet',
            value: '10%',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({
    required this.color,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final Color color;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _LegendItem(color: color, label: label),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveZonesCard extends StatelessWidget {
  const _ActiveZonesCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Most active zones',
            leadingIcon: Icons.local_fire_department_rounded,
          ),
          SizedBox(height: 18),
          _ZoneRow(
            zone: 'Zone Colonial',
            percent: '28% of total',
            value: '312 bookings',
            bar: 84,
            color: AppColors.danger,
          ),
          _ZoneRow(
            zone: 'Piantini',
            percent: '24% of total',
            value: '274 bookings',
            bar: 74,
            color: AppColors.warn,
          ),
          _ZoneRow(
            zone: 'Bella Vista',
            percent: '17% of total',
            value: '198 bookings',
            bar: 55,
            color: AppColors.blue,
          ),
          _ZoneRow(
            zone: 'Naco',
            percent: '14% of total',
            value: '164 bookings',
            bar: 43,
            color: AppColors.blue,
          ),
          _ZoneRow(
            zone: 'Gazcue',
            percent: '9% of total',
            value: '98 bookings',
            bar: 27,
            color: AppColors.blue,
          ),
          _ZoneRow(
            zone: 'Arroyo Hondo',
            percent: '6% of total',
            value: '66 bookings',
            bar: 20,
            color: AppColors.blue,
          ),
          _ZoneRow(
            zone: 'Other',
            percent: '2% of total',
            value: '24 bookings',
            bar: 8,
            color: AppColors.blue,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ZoneRow extends StatelessWidget {
  const _ZoneRow({
    required this.zone,
    required this.percent,
    required this.value,
    required this.bar,
    required this.color,
    this.isLast = false,
  });

  final String zone;
  final String percent;
  final String value;
  final int bar;
  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: bar / 100,
                minHeight: 5,
                color: color,
                backgroundColor: AppColors.surface2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  percent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.textFaint,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            maxLines: 1,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MostOccupiedCard extends StatelessWidget {
  const _MostOccupiedCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Most occupied parking'),
          SizedBox(height: 14),
          _OccupiedRow(
            name: 'Parking Colonial Premium',
            zone: 'Colonial Zone - 89 bookings',
            amount: 'RD\$53,400',
            occupancy: 'Occ. 91%',
            progress: 0.91,
            color: AppColors.danger,
          ),
          _OccupiedRow(
            name: 'Bella Vista Parking',
            zone: 'Bella Vista - 61 bookings',
            amount: 'RD\$36,600',
            occupancy: 'Occ. 78%',
            progress: 0.78,
            color: AppColors.warn,
          ),
          _OccupiedRow(
            name: 'VIP Piantini',
            zone: 'Piantini - 54 bookings',
            amount: 'RD\$32,400',
            occupancy: 'Occ. 85%',
            progress: 0.85,
            color: AppColors.danger,
          ),
          _OccupiedRow(
            name: 'Parking Naco Center',
            zone: 'Naco - 48 bookings',
            amount: 'RD\$28,800',
            occupancy: 'Occ. 72%',
            progress: 0.72,
            color: AppColors.warn,
          ),
          _OccupiedRow(
            name: 'CEDIMAT Medical Center',
            zone: 'Gazcue - 38 bookings',
            amount: 'RD\$22,800',
            occupancy: 'Occ. 61%',
            progress: 0.61,
            color: AppColors.green,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _OccupiedRow extends StatelessWidget {
  const _OccupiedRow({
    required this.name,
    required this.zone,
    required this.amount,
    required this.occupancy,
    required this.progress,
    required this.color,
    this.isLast = false,
  });

  final String name;
  final String zone;
  final String amount;
  final String occupancy;
  final double progress;
  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      zone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.textSub,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    maxLines: 1,
                    style: GoogleFonts.nunito(
                      color: AppColors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    occupancy,
                    maxLines: 1,
                    style: GoogleFonts.nunito(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              color: color,
              backgroundColor: AppColors.surface2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BusyHoursCard extends StatelessWidget {
  const _BusyHoursCard();

  @override
  Widget build(BuildContext context) {
    return const _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Most booked hours of the day'),
          SizedBox(height: 18),
          _HourRow(
            time: '8:00 AM',
            value: '342',
            progress: 0.88,
            hot: true,
            color: AppColors.danger,
          ),
          _HourRow(
            time: '6:00 PM',
            value: '318',
            progress: 0.82,
            hot: true,
            color: AppColors.danger,
          ),
          _HourRow(
            time: '9:00 AM',
            value: '290',
            progress: 0.79,
            color: AppColors.blue,
          ),
          _HourRow(
            time: '5:00 PM',
            value: '278',
            progress: 0.72,
            color: AppColors.blue,
          ),
          _HourRow(
            time: '12:00 PM',
            value: '234',
            progress: 0.61,
            color: AppColors.blue,
          ),
          _HourRow(
            time: '7:00 PM',
            value: '198',
            progress: 0.51,
            color: AppColors.blue,
          ),
          _HourRow(
            time: '10:00 AM',
            value: '187',
            progress: 0.48,
            color: AppColors.blue,
          ),
        ],
      ),
    );
  }
}

class _HourRow extends StatelessWidget {
  const _HourRow({
    required this.time,
    required this.value,
    required this.progress,
    required this.color,
    this.hot = false,
  });

  final String time;
  final String value;
  final double progress;
  final Color color;
  final bool hot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            child: Text(
              time,
              maxLines: 1,
              style: GoogleFonts.nunito(
                color: AppColors.textSub,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                color: color,
                backgroundColor: AppColors.surface2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.nunito(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (hot) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.orange,
                    size: 15,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
