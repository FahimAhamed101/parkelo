import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/appColor/app_colors.dart';
import '../services/host_api_client.dart';

enum HostPanelTab { panel, parking, services, prices, alerts }

class HostPanelScaffold extends StatelessWidget {
  const HostPanelScaffold({
    super.key,
    required this.selectedTab,
    required this.child,
    this.backgroundColor = const Color(0xFFF3F7FC),
  });

  final HostPanelTab selectedTab;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            HostPanelHeader(selectedTab: selectedTab),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class HostPanelHeader extends StatelessWidget {
  const HostPanelHeader({super.key, required this.selectedTab});

  final HostPanelTab selectedTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1F59B8), Color(0xFF08934C)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 12, 11),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showHostQrModal(context),
                    child: const _HostLogo(),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panel Host',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: AppColors.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Parking Colonial Premium',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: AppColors.textSub,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _HeaderButton(
                    icon: Icons.grid_view_rounded,
                    backgroundColor: const Color(0xFFE8F8F0),
                    foregroundColor: const Color(0xFF08934C),
                    onTap: () => Get.offAllNamed('/host_bottom_nav'),
                  ),
                  const SizedBox(width: 9),
                  _HeaderButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    backgroundColor: const Color(0xFFF7FAFF),
                    foregroundColor: AppColors.blue,
                    badgeCount: 3,
                    onTap: () =>
                        Get.offAllNamed('/host_bottom_nav', arguments: 4),
                  ),
                ],
              ),
            ),
            HostPanelTabs(selectedTab: selectedTab),
            const Divider(height: 1, color: Color(0xFFE5EBF5)),
          ],
        ),
      ),
    );
  }
}

class HostPanelTabs extends StatelessWidget {
  const HostPanelTabs({super.key, required this.selectedTab});

  final HostPanelTab selectedTab;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('Panel', HostPanelTab.panel, 0),
      ('Parking', HostPanelTab.parking, 1),
      ('Services', HostPanelTab.services, 2),
      ('Prices', HostPanelTab.prices, 3),
      ('Alerts', HostPanelTab.alerts, 4),
    ];

    return SizedBox(
      height: 39,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _HeaderTab(
                label: tab.$1,
                selected: tab.$2 == selectedTab,
                onTap: () {
                  Get.offAllNamed('/host_bottom_nav', arguments: tab.$3);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _HostLogo extends StatelessWidget {
  const _HostLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF164AA1), Color(0xFF1F66D1)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.location_on_rounded, color: Color(0xFF39B5FF), size: 29),
          Positioned(
            top: 8,
            child: Text(
              'P',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.badgeCount,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: 39,
            height: 39,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD5E5F7)),
            ),
            child: Icon(icon, color: foregroundColor, size: 21),
          ),
        ),
        if (badgeCount != null)
          Positioned(
            right: -3,
            top: -4,
            child: Container(
              width: 15,
              height: 15,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFE11D48),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badgeCount',
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Future<Map<String, dynamic>> _loadHostQr() async {
  final parkings = await HostApiClient.instance.fetchParkings();
  final parkingList = parkings['parkings'] as List<dynamic>? ?? const [];
  final firstParking = parkingList.isNotEmpty
      ? parkingList.first as Map<String, dynamic>
      : null;
  final parkingId = firstParking?['id'] as String? ?? 'demo-parking-1';
  return HostApiClient.instance.fetchParkingQr(parkingId);
}

void _showHostQrModal(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierColor: const Color(0xFF07142F).withValues(alpha: 0.72),
    builder: (_) => const _HostQrDialog(),
  );
}

class _HostQrDialog extends StatefulWidget {
  const _HostQrDialog();

  @override
  State<_HostQrDialog> createState() => _HostQrDialogState();
}

class _HostQrDialogState extends State<_HostQrDialog> {
  late final Future<Map<String, dynamic>> _qrFuture = _loadHostQr();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.white,
          child: FutureBuilder<Map<String, dynamic>>(
            future: _qrFuture,
            builder: (context, snapshot) {
              final qr =
                  snapshot.data?['qr'] as Map<String, dynamic>? ??
                  {
                    'payload':
                        '{"type":"parkealo_host_parking","parkingId":"demo-parking-1"}',
                    'label': 'Parking Colonial Premium',
                    'code': 'PKL-COL001',
                  };

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _HostQrHeader(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                      child: Column(
                        children: [
                          _HostQrCard(qr: qr, loading: snapshot.connectionState == ConnectionState.waiting),
                          const SizedBox(height: 16),
                          const _HostQrHowItWorks(),
                          const SizedBox(height: 18),
                          _HostQrActions(qr: qr),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HostQrHeader extends StatelessWidget {
  const _HostQrHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: const Color(0xFF1E55BC),
      child: Row(
        children: [
          const _MiniHostLogo(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Codigo QR del parqueo',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _HostQrCard extends StatelessWidget {
  const _HostQrCard({required this.qr, required this.loading});

  final Map<String, dynamic> qr;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final payload = qr['payload']?.toString() ?? '';
    final label = qr['label']?.toString() ?? 'Parking Colonial Premium';
    final code = qr['code']?.toString() ?? 'PKL-COL001';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 21, 18, 23),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDDE7F5), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D3C68).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const _ParkealoWordmark(),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          _HostQrFrame(payload: payload, loading: loading),
          const SizedBox(height: 13),
          Text(
            code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: const Color(0xFFB5C2D5),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 13),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Text(
              'Check-In / Check-Out',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Escanea con la app Parkealo o tu camara para agor\ncheck-in o check-out en tu reserva.',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _HostQrFrame extends StatelessWidget {
  const _HostQrFrame({required this.payload, required this.loading});

  final String payload;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF101B3D), width: 2),
      ),
      child: loading
          ? const Center(
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          : QrImageView(
              data: payload.isEmpty ? 'parkealo-host-parking' : payload,
              version: QrVersions.auto,
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF101B3D),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF101B3D),
              ),
            ),
    );
  }
}

class _HostQrHowItWorks extends StatelessWidget {
  const _HostQrHowItWorks();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCFE0F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: AppColors.blue, size: 14),
              const SizedBox(width: 6),
              Text(
                'Como funciona',
                style: GoogleFonts.nunito(
                  color: AppColors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _HostQrInstruction('User con reserva -> activa el reloj'),
          _HostQrInstruction('Sin cuenta -> descarga la app'),
          _HostQrInstruction('Registrado sin reserva -> explorador'),
        ],
      ),
    );
  }
}

class _HostQrInstruction extends StatelessWidget {
  const _HostQrInstruction(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '- ',
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                color: AppColors.textSub,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HostQrActions extends StatelessWidget {
  const _HostQrActions({required this.qr});

  final Map<String, dynamic> qr;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HostQrActionButton(
            label: 'Download',
            icon: Icons.print_rounded,
            color: AppColors.blue,
            textColor: Colors.white,
            onTap: () {
              Clipboard.setData(ClipboardData(text: qr['payload']?.toString() ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR payload copied')),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HostQrActionButton(
            label: 'Close',
            color: const Color(0xFFE9EDF5),
            textColor: AppColors.textSub,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}

class _HostQrActionButton extends StatelessWidget {
  const _HostQrActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 17),
              const SizedBox(width: 7),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniHostLogo extends StatelessWidget {
  const _MiniHostLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Icon(Icons.location_on_rounded, color: Color(0xFF46C5FF), size: 27),
          Positioned(
            top: 6,
            child: Text(
              'P',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkealoWordmark extends StatelessWidget {
  const _ParkealoWordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _MiniHostLogo(),
        const SizedBox(width: 7),
        Text(
          'Parkealo',
          style: GoogleFonts.nunito(
            color: AppColors.blue,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: selected ? AppColors.blue : AppColors.textFaint,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2,
            width: selected ? 52 : 0,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF08934C) : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}
