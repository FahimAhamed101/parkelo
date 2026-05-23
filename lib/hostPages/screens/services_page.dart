import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/host_bottom_nav.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFEFF7FF);
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryBlue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: Scaffold(
          backgroundColor: _pageBg,
          body: Column(
            children: [
              _ServicesHeader(onBack: () => Navigator.maybePop(context)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      _ActiveServicesCard(),
                      SizedBox(height: 12),
                      _SectionTitle('Parking services'),
                      SizedBox(height: 8),
                      _ServicesListCard(services: _services),
                      SizedBox(height: 12),
                      _SaveServicesButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicesHeader extends StatelessWidget {
  const _ServicesHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 13),
          child: SizedBox(
            height: 38,
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 38,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Services',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
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
      padding: const EdgeInsets.fromLTRB(13, 11, 12, 11),
      decoration: BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.circular(10),
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
                  'Active services enabled',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFD9E7FF),
                    fontSize: 9,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: ' of 12',
                        style: TextStyle(
                          color: Color(0xFFD9E7FF),
                          fontSize: 10,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _primaryBlue,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE9FFF4),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFB7F3CC)),
          ),
          child: const Text(
            '5 active',
            style: TextStyle(
              color: _success,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServicesListCard extends StatelessWidget {
  const _ServicesListCard({required this.services});

  final List<_ServiceData> services;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
        children: [
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
          height: 38,
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, color: data.iconColor, size: 15),
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
                        fontSize: 10.1,
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
                        fontSize: 7.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 22,
                child: Text(
                  data.enabled ? 'On' : 'Off',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: data.enabled ? _primaryBlue : _muted,
                    fontSize: 7.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 7),
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
      width: 32,
      height: 18,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isOn ? _primaryBlue : const Color(0xFFE5EAF0),
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 14,
        height: 14,
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
      height: 38,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _actionBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Save Services',
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
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
