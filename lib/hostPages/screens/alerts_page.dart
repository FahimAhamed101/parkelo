import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/host_bottom_nav.dart';

const _primaryBlue = Color(0xFF1556B7);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF6B7280);

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  static const _alerts = [
    _AlertData(
      message: 'User A123456 finished their time in space B1',
      time: 'ago 5 min',
      color: Color(0xFFF59E0B),
    ),
    _AlertData(
      message: 'New private request - license plate C789012',
      time: 'ago 18 min',
      color: Color(0xFF2563EB),
    ),
    _AlertData(
      message: 'Overtime detected - A2 (+12 mins)',
      time: 'ago 32 min',
      color: Color(0xFFEF4444),
    ),
    _AlertData(
      message: 'Booking confirmed - D901234 - tomorrow\n09:00',
      time: 'ago 1h',
      color: Color(0xFF16A34A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryBlue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        body: Column(
          children: [
            _AlertsHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(13, 13, 13, 28),
                child: Column(
                  children: [
                    for (var i = 0; i < _alerts.length; i++) ...[
                      _AlertCard(alert: _alerts[i]),
                      if (i != _alerts.length - 1) const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertsHeader extends StatelessWidget {
  const _AlertsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 17),
          child: SizedBox(
            height: 42,
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 42,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Alerts',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final _AlertData alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 57),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: alert.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 9, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alert.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 11.5,
                        height: 1.18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      alert.time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 8.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertData {
  const _AlertData({
    required this.message,
    required this.time,
    required this.color,
  });

  final String message;
  final String time;
  final Color color;
}
