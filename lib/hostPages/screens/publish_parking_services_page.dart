import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF6B7280);

class PublishParkingServicesPage extends StatelessWidget {
  const PublishParkingServicesPage({super.key});

  static const _tabs = ['Location', 'Details', 'Spaces', 'Services', 'Photos'];
  static const _services = [
    _ServiceOption(
      icon: Icons.house_rounded,
      iconBg: Color(0xFFFFF3E4),
      iconColor: Color(0xFFB45309),
      title: 'Covered',
      subtitle: 'Covered area / roof',
      isEnabled: true,
    ),
    _ServiceOption(
      icon: Icons.bolt_rounded,
      iconBg: Color(0xFFFFF3E4),
      iconColor: Color(0xFFF59E0B),
      title: 'EV Charging',
      subtitle: 'Electric chargers',
      isEnabled: false,
    ),
    _ServiceOption(
      icon: Icons.videocam_rounded,
      iconBg: Color(0xFFE9F7EF),
      iconColor: Color(0xFF334155),
      title: 'Cameras',
      subtitle: '24h surveillance',
      isEnabled: true,
    ),
    _ServiceOption(
      icon: Icons.emoji_people_rounded,
      iconBg: Color(0xFFFFF7DB),
      iconColor: Color(0xFF1D4ED8),
      title: 'Valet',
      subtitle: 'Valet service',
      isEnabled: false,
    ),
    _ServiceOption(
      icon: Icons.schedule_rounded,
      iconBg: Color(0xFFFFFBE8),
      iconColor: Color(0xFF94A3B8),
      title: '24/7',
      subtitle: 'Open 24 hours',
      isEnabled: true,
    ),
    _ServiceOption(
      icon: Icons.lock_rounded,
      iconBg: Color(0xFFFFF7DB),
      iconColor: Color(0xFFB45309),
      title: 'Access Control',
      subtitle: 'Access with card or PIN',
      isEnabled: true,
    ),
    _ServiceOption(
      icon: Icons.person_rounded,
      iconBg: Color(0xFFE8F2FF),
      iconColor: Color(0xFF64748B),
      title: 'Personnel',
      subtitle: 'Security personnel',
      isEnabled: false,
    ),
    _ServiceOption(
      icon: Icons.local_parking_rounded,
      iconBg: Color(0xFFEAF9E9),
      iconColor: Color(0xFF16A34A),
      title: 'Private',
      subtitle: 'Exclusive private space',
      isEnabled: false,
    ),
    _ServiceOption(
      icon: Icons.wifi_rounded,
      iconBg: Color(0xFFE7F3FF),
      iconColor: Color(0xFF64748B),
      title: 'Wi-Fi',
      subtitle: 'Free internet',
      isEnabled: false,
    ),
    _ServiceOption(
      icon: Icons.accessible_forward_rounded,
      iconBg: Color(0xFFE7F0FF),
      iconColor: Color(0xFF2563EB),
      title: 'Disabled Access',
      subtitle: 'Accessible spaces',
      isEnabled: true,
    ),
    _ServiceOption(
      icon: Icons.two_wheeler_rounded,
      iconBg: Color(0xFFFFEEF2),
      iconColor: Color(0xFF334155),
      title: 'Motorcycles',
      subtitle: 'Area for motorcycles',
      isEnabled: false,
    ),
    _ServiceOption(
      icon: Icons.wc_rounded,
      iconBg: Color(0xFFE7F3FF),
      iconColor: Color(0xFF64748B),
      title: 'Restrooms',
      subtitle: 'Sanitary services',
      isEnabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryBlue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _pageBg,
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        body: Column(
          children: [
            _PublishHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 16, 10, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < _tabs.length; i++) ...[
                          Expanded(
                            child: _StepPill(
                              label: _tabs[i],
                              isSelected: i == 0,
                            ),
                          ),
                          if (i != _tabs.length - 1) const SizedBox(width: 5),
                        ],
                      ],
                    ),
                    const SizedBox(height: 11),
                    const Text(
                      'What services does your parking lot offer?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Select all that apply. You can edit them later.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < _services.length; i++) ...[
                            _ServiceRow(option: _services[i]),
                            if (i != _services.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFF2F5F8),
                                indent: 40,
                              ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 29),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/publish-parking-photos',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _actionBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
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

class _PublishHeader extends StatelessWidget {
  const _PublishHeader({required this.onBack});

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
                    'Publish parking',
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

class _StepPill extends StatelessWidget {
  const _StepPill({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? _primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _primaryBlue, width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: isSelected ? Colors.white : _ink,
              fontSize: 8.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.option});

  final _ServiceOption option;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: option.iconBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(option.icon, color: option.iconColor, size: 13),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    option.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 9.2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 6.7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _TinySwitch(isEnabled: option.isEnabled),
          ],
        ),
      ),
    );
  }
}

class _TinySwitch extends StatelessWidget {
  const _TinySwitch({required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 16,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFF0068C9) : const Color(0xFFE6EBF1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ServiceOption {
  const _ServiceOption({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isEnabled;
}
