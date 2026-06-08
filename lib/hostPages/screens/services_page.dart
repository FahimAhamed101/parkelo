import 'package:flutter/material.dart';
import '../widgets/host_panel_chrome.dart';

const _primaryBlue = Color(0xFF1556B7);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF8A96A8);
const _line = Color(0xFFE5EDF6);
const _success = Color(0xFF16A34A);

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const _services = [
    _ServiceData(
      icon: Icons.roofing_rounded,
      iconColor: Color(0xFFB7791F),
      iconBg: Color(0xFFFFF4E0),
      title: 'Covered',
      subtitle: 'Covered area / roof',
      enabled: true,
    ),
    _ServiceData(
      icon: Icons.bolt_rounded,
      iconColor: Color(0xFFF59E0B),
      iconBg: Color(0xFFFFF3DA),
      title: 'EV Charging',
      subtitle: 'Electric chargers',
      enabled: false,
    ),
    _ServiceData(
      icon: Icons.videocam_rounded,
      iconColor: Color(0xFF475569),
      iconBg: Color(0xFFEAF2F8),
      title: 'Cameras',
      subtitle: '24h surveillance',
      enabled: true,
    ),
    _ServiceData(
      icon: Icons.local_taxi_rounded,
      iconColor: Color(0xFFEAB308),
      iconBg: Color(0xFFFFF8D9),
      title: 'Valet',
      subtitle: 'Valet service',
      enabled: false,
    ),
    _ServiceData(
      icon: Icons.access_time_filled_rounded,
      iconColor: Color(0xFF94A3B8),
      iconBg: Color(0xFFF2F6FB),
      title: '24/7',
      subtitle: 'Open 24 hours',
      enabled: true,
    ),
    _ServiceData(
      icon: Icons.lock_rounded,
      iconColor: Color(0xFFD99A16),
      iconBg: Color(0xFFFFF4D9),
      title: 'Access Control',
      subtitle: 'Access with card or PIN',
      enabled: true,
    ),
    _ServiceData(
      icon: Icons.person_rounded,
      iconColor: Color(0xFF5B8CC9),
      iconBg: Color(0xFFE8F2FF),
      title: 'Personnel',
      subtitle: 'Security personnel',
      enabled: false,
    ),
    _ServiceData(
      icon: Icons.home_rounded,
      iconColor: Color(0xFF16A34A),
      iconBg: Color(0xFFE9FFF4),
      title: 'Private',
      subtitle: 'Exclusive private space',
      enabled: false,
    ),
    _ServiceData(
      icon: Icons.wifi_rounded,
      iconColor: Color(0xFF2D83BE),
      iconBg: Color(0xFFE7F4FF),
      title: 'Wi-Fi',
      subtitle: 'Free internet',
      enabled: false,
    ),
    _ServiceData(
      icon: Icons.accessible_rounded,
      iconColor: Color(0xFF1677D2),
      iconBg: Color(0xFFE3F0FF),
      title: 'Disabled Access',
      subtitle: 'Accessible spaces',
      enabled: true,
    ),
    _ServiceData(
      icon: Icons.two_wheeler_rounded,
      iconColor: Color(0xFF64748B),
      iconBg: Color(0xFFFFECEB),
      title: 'Motorcycles',
      subtitle: 'Area for motorcycles',
      enabled: false,
    ),
    _ServiceData(
      icon: Icons.wc_rounded,
      iconColor: Color(0xFF5B8CC9),
      iconBg: Color(0xFFE8F2FF),
      title: 'Restrooms',
      subtitle: 'Sanitary services',
      enabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return HostPanelScaffold(
      selectedTab: HostPanelTab.services,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ActiveServicesCard(),
              const SizedBox(height: 16),
              const _ServicesListCard(services: _services),
              const SizedBox(height: 14),
              const _SaveServicesButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveServicesCard extends StatelessWidget {
  const _ActiveServicesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Active services',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFD9E7FF),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: ' of 12',
                        style: TextStyle(
                          color: Color(0xFFD9E7FF),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: const LinearProgressIndicator(
                    value: 5 / 12,
                    minHeight: 4,
                    backgroundColor: Color(0x3342A5F5),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.end,
            children: [
              _TinyServiceIcon(icon: Icons.roofing_rounded, bg: 0xFF90594B),
              _TinyServiceIcon(icon: Icons.lock_rounded, bg: 0xFFE08A22),
              _TinyServiceIcon(icon: Icons.videocam_rounded, bg: 0xFF5A9CCF),
              _TinyServiceIcon(
                icon: Icons.access_time_filled_rounded,
                bg: 0xFFE2C247,
              ),
              _TinyServiceIcon(icon: Icons.accessible_rounded, bg: 0xFF42A5F5),
              _TinyServiceIcon(icon: Icons.wc_rounded, bg: 0xFF6D94CB),
            ],
          ),
        ],
      ),
    );
  }
}

class _TinyServiceIcon extends StatelessWidget {
  const _TinyServiceIcon({required this.icon, required this.bg});

  final IconData icon;
  final int bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 19,
      height: 19,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(bg),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: Colors.white, size: 11),
    );
  }
}

class _ServicesListCard extends StatelessWidget {
  const _ServicesListCard({required this.services});

  final List<_ServiceData> services;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parking services',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < services.length; i++) ...[
            _ServiceRow(data: services[i]),
            if (i != services.length - 1)
              const Divider(height: 1, thickness: 0.7, color: _line),
          ],
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.data});

  final _ServiceData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: data.enabled
                        ? const Color(0xFFB7E4C7)
                        : const Color(0xFFE0E7EF),
                  ),
                ),
                child: Icon(data.icon, color: data.iconColor, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _MiniSwitch(isOn: data.enabled),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniSwitch extends StatelessWidget {
  const _MiniSwitch({required this.isOn});

  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isOn ? _success : const Color(0xFFE5EAF0),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isOn ? _success : const Color(0xFFC9D5E3),
          width: 1,
        ),
      ),
      alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveServicesButton extends StatelessWidget {
  const _SaveServicesButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 49,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _success,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Save services',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _ServiceData {
  const _ServiceData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.enabled,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool enabled;
}
