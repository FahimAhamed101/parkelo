import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/appColor/app_colors.dart';
import '../services/host_api_client.dart';
import '../services/host_publish_flow_service.dart';
import '../widgets/host_panel_chrome.dart';

class HostDashboardPage extends StatefulWidget {
  const HostDashboardPage({super.key});

  @override
  State<HostDashboardPage> createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<HostDashboardPage> {
  late Future<Map<String, dynamic>> _summaryFuture;
  late Future<Map<String, dynamic>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = HostApiClient.instance.fetchSummary();
    _dashboardFuture = HostApiClient.instance.fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return HostPanelScaffold(
      selectedTab: HostPanelTab.panel,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _summaryFuture,
        builder: (context, summarySnapshot) {
          final parkings =
              (summarySnapshot.data?['parkings'] as List<dynamic>? ?? const [])
                  .cast<dynamic>();
          final hasLocalSubmittedDraft =
              HostPublishFlowService.instance.submitNotice != null &&
              HostPublishFlowService.instance.parking != null;
          final hasParking = parkings.isNotEmpty || hasLocalSubmittedDraft;

          if (!hasParking) {
            return RefreshIndicator(
              color: AppColors.blue,
              onRefresh: _refreshAll,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(24, 47, 24, 30),
                children: const [
                  _WelcomeHero(),
                  SizedBox(height: 25),
                  _WelcomeCopy(),
                  SizedBox(height: 36),
                  _AddParkingCard(),
                  SizedBox(height: 16),
                  _FeatureRow(),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.blue,
            onRefresh: _refreshAll,
            child: FutureBuilder<Map<String, dynamic>>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                final panelData =
                    snapshot.data?['panel'] as Map<String, dynamic>? ??
                    _fallbackPanel();

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatsGrid(panel: panelData),
                      const SizedBox(height: 14),
                      _ReservationModeCard(panel: panelData),
                      const SizedBox(height: 14),
                      _ActionCard(
                        title: 'Add parking',
                        subtitle: 'Publish a new space in Parkealo',
                        icon: Icons.add_rounded,
                        onTap: () =>
                            Navigator.pushNamed(context, '/publish-parking'),
                      ),
                      const SizedBox(height: 14),
                      _PeakHourChart(panel: panelData),
                      const SizedBox(height: 14),
                      _InviteCard(panel: panelData),
                      if (snapshot.hasError) ...[
                        const SizedBox(height: 14),
                        _InlineBanner(
                          title: 'Offline mode',
                          subtitle:
                              'Showing demo data because the host API could not be reached.',
                          color: Color(0xFFFFF2CC),
                          borderColor: Color(0xFFF0D080),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshAll() async {
    setState(() {
      _summaryFuture = HostApiClient.instance.fetchSummary();
      _dashboardFuture = HostApiClient.instance.fetchDashboard();
    });
    await Future.wait([_summaryFuture, _dashboardFuture]);
  }

  Map<String, dynamic> _fallbackPanel() {
    return {
      'subtitle': 'Parking Colonial Premium',
      'primaryParking': {
        'id': 'demo-parking-1',
        'name': 'Parking Colonial Premium',
        'code': 'HOST-JM3K9',
      },
      'stats': {
        'incomeTodayLabel': 'RD\$4,200',
        'occupancy': {'label': '8 / 12'},
        'bookingsToday': 14,
        'rating': 4.87,
      },
      'reservationMode': {
        'mode': 'automatic',
        'active': true,
        'description':
            'Reservations are confirmed automatically. The user receives the information immediately.',
      },
      'peakHourChart': [
        {'label': '6am', 'bookings': 1},
        {'label': '9am', 'bookings': 4},
        {'label': '12pm', 'bookings': 3},
        {'label': '3pm', 'bookings': 5},
        {'label': '6pm', 'bookings': 4},
        {'label': '9pm', 'bookings': 1},
      ],
      'invite': {
        'code': 'HOST-JM3K9',
        'rewardAmount': 500,
        'message':
            'Invite other hosts and earn a reward for each first parking published.',
      },
    };
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue, AppColors.blueSky],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.15),
            blurRadius: 34,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_parking_rounded,
        color: Colors.white,
        size: 58,
      ),
    );
  }
}

class _WelcomeCopy extends StatelessWidget {
  const _WelcomeCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to Parkealo',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: AppColors.text,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            'Publish your first parking and start receiving bookings today. The process takes less than 5 minutes.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddParkingCard extends StatelessWidget {
  const _AddParkingCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, '/publish-parking'),
        child: Ink(
          height: 114,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 20, 19, 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.blue, AppColors.blueSky],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.blue.withValues(alpha: 0.14),
                blurRadius: 26,
                offset: const Offset(0, 13),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add my\nparking',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Publish spaces and start earning',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.86),
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _FeatureItem(
            icon: Icons.local_parking_rounded,
            label: 'Up to 30 spaces per section',
            color: AppColors.blue,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _FeatureItem(
            icon: Icons.bolt_rounded,
            label: 'Automatic confirmation',
            color: Color(0xFFFF7A1A),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _FeatureItem(
            icon: Icons.credit_card_rounded,
            label: 'Withdrawals in 24h',
            color: AppColors.blueSky,
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 91),
      padding: const EdgeInsets.fromLTRB(7, 15, 7, 10),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.17,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.panel});

  final Map<String, dynamic> panel;

  @override
  Widget build(BuildContext context) {
    final stats = panel['stats'] as Map<String, dynamic>? ?? const {};
    final occupancy = stats['occupancy'] as Map<String, dynamic>? ?? const {};

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.95,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatCard(
          title: stats['incomeTodayLabel'] as String? ?? 'RD\$0',
          subtitle: 'Income today',
          accentColor: const Color(0xFF15934A),
          onTap: () => Get.toNamed('/withdrawals'),
        ),
        _StatCard(
          title: occupancy['label'] as String? ?? '0 / 0',
          subtitle: 'Occupancy',
          accentColor: const Color(0xFF1F59B8),
        ),
        _StatCard(
          title: '${stats['bookingsToday'] ?? 0}',
          subtitle: 'Bookings today',
          accentColor: const Color(0xFFB8860B),
        ),
        _StatCard(
          title: '${stats['rating'] ?? 0}',
          subtitle: 'Rating',
          accentColor: const Color(0xFF213B87),
          trailing: const Icon(Icons.star_rounded, color: Color(0xFFF59E0B)),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5EBF5)),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: accentColor,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: AppColors.textSub,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.blue,
                    size: 18,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservationModeCard extends StatelessWidget {
  const _ReservationModeCard({required this.panel});

  final Map<String, dynamic> panel;

  @override
  Widget build(BuildContext context) {
    final mode = panel['reservationMode'] as Map<String, dynamic>? ?? const {};
    final isAutomatic = (mode['mode'] as String? ?? 'automatic') == 'automatic';
    final description = mode['description'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EBF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reservation mode',
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ModeTile(
                  title: 'Automatic',
                  subtitle: 'The user receives PIN and confirmation instantly',
                  selected: isAutomatic,
                  icon: Icons.bolt_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeTile(
                  title: 'Manual',
                  subtitle: 'You review each reservation before confirming it',
                  selected: !isAutomatic,
                  icon: Icons.pan_tool_alt_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAFBF0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFB7E4C7)),
            ),
            child: Text(
              isAutomatic
                  ? 'Active - Reservations confirm automatically. The user receives all the information immediately.'
                  : description,
              style: GoogleFonts.nunito(
                color: const Color(0xFF177245),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF1FBF4) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? const Color(0xFF15934A) : const Color(0xFFD6DFEA),
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: selected ? const Color(0xFF15934A) : AppColors.textFaint,
          ),
          const SizedBox(height: 9),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: selected ? const Color(0xFF15934A) : AppColors.textSub,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: AppColors.textFaint,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.blue, AppColors.blueSky],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: 0.18),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.94),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _PeakHourChart extends StatelessWidget {
  const _PeakHourChart({required this.panel});

  final Map<String, dynamic> panel;

  @override
  Widget build(BuildContext context) {
    final chart = (panel['peakHourChart'] as List<dynamic>? ?? const [])
        .map((item) => item as Map<String, dynamic>)
        .toList();

    final maxBookings = chart.fold<int>(
      1,
      (max, item) => item['bookings'] is int
          ? ((item['bookings'] as int) > max ? item['bookings'] as int : max)
          : max,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EBF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Peak hour of the day',
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final item in chart)
                  Expanded(
                    child: _ChartBar(
                      label: item['label'] as String? ?? '',
                      value: (item['bookings'] as num?)?.toInt() ?? 0,
                      maxValue: maxBookings,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              _ChartLegend(color: Color(0xFF15934A), label: 'High'),
              SizedBox(width: 12),
              _ChartLegend(color: Color(0xFF1F59B8), label: 'Medium'),
              SizedBox(width: 12),
              _ChartLegend(color: Color(0xFFE8EEF8), label: 'Low'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({
    required this.label,
    required this.value,
    required this.maxValue,
  });

  final String label;
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue == 0 ? 0.0 : value / maxValue;
    final color = ratio >= 0.75
        ? const Color(0xFF15934A)
        : ratio >= 0.4
        ? const Color(0xFF1F59B8)
        : const Color(0xFFE8EEF8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '$value',
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52 * ratio.clamp(0.08, 1.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: AppColors.textFaint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.color, required this.label});

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
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.nunito(
            color: AppColors.textFaint,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard({required this.panel});

  final Map<String, dynamic> panel;

  @override
  Widget build(BuildContext context) {
    final invite = panel['invite'] as Map<String, dynamic>? ?? const {};
    final code = invite['code'] as String? ?? 'HOST-JM3K9';
    final rewardAmount = invite['rewardAmount'] ?? 500;
    final message = invite['message'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAFBF0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB7E4C7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF15934A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite other hosts',
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF15934A),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Earn RD\$$rewardAmount for each host that publishes their first parking with your code.',
                      style: GoogleFonts.nunito(
                        color: AppColors.textSub,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC6EED0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    code,
                    style: GoogleFonts.nunito(
                      color: AppColors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Copy',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _InviteButton(
                  label: 'WhatsApp',
                  icon: Icons.chat_rounded,
                  backgroundColor: const Color(0xFF25D366),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InviteButton(
                  label: 'Share',
                  icon: Icons.share_rounded,
                  backgroundColor: AppColors.blue,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              message.isEmpty
                  ? '3 hosts referred - RD\$300 earned so far'
                  : message,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: AppColors.textFaint,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteButton extends StatelessWidget {
  const _InviteButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 14, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class _InlineBanner extends StatelessWidget {
  const _InlineBanner({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.borderColor,
  });

  final String title;
  final String subtitle;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
