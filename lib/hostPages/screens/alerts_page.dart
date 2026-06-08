import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/host_api_client.dart';
import '../widgets/host_panel_chrome.dart';

const _ink = Color(0xFF111827);
const _muted = Color(0xFF6B7280);

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late Future<Map<String, dynamic>> _alertsFuture;

  @override
  void initState() {
    super.initState();
    _alertsFuture = HostApiClient.instance.fetchAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return HostPanelScaffold(
      selectedTab: HostPanelTab.alerts,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _alertsFuture,
        builder: (context, snapshot) {
          final alerts =
              (snapshot.data?['alerts'] as List<dynamic>? ?? const [])
                  .map((item) => item as Map<String, dynamic>)
                  .toList();

          if (snapshot.connectionState == ConnectionState.waiting &&
              alerts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _alertsFuture = HostApiClient.instance.fetchAlerts();
              });
              await _alertsFuture;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(13, 16, 13, 28),
              itemCount: alerts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _AlertCard(alert: alerts[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final Map<String, dynamic> alert;

  @override
  Widget build(BuildContext context) {
    final severity = alert['severity'] as String? ?? 'info';
    final color = switch (severity) {
      'warning' => const Color(0xFFF59E0B),
      'success' => const Color(0xFF16A34A),
      'danger' => const Color(0xFFEF4444),
      _ => const Color(0xFF2563EB),
    };

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
            Container(width: 4, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 9, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alert['message'] as String? ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: _ink,
                        fontSize: 12,
                        height: 1.18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      alert['time'] as String? ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: _muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
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
