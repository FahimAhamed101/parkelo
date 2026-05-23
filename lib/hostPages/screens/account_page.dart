import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/route.dart';

const _primaryBlue = Color(0xFF1556B7);
const _pageBg = Color(0xFFF4FAF7);
const _ink = Color(0xFF111827);
const _line = Color(0xFFE3EAF0);
const _danger = Color(0xFFFF3B3B);

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
            _AccountHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 13, 10, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Center(child: _ParkealoLogo()),
                    SizedBox(height: 12),
                    _AppInfoCard(),
                    SizedBox(height: 8),
                    _SettingsGroup(
                      title: 'Account Information',
                      items: [
                        _SettingsItemData(
                          icon: Icons.person_outline_rounded,
                          label: 'Profile Info',
                          routeName: '/profile-info',
                        ),
                        _SettingsItemData(
                          icon: Icons.swap_vert_rounded,
                          label: 'Switch to User',
                          hasSwitch: true,
                          routeName: AppRoutes.bottomNavScreen,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _SettingsGroup(
                      title: 'Policy Center',
                      items: [
                        _SettingsItemData(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Privacy Policy',
                          routeName: '/privacy-policy',
                        ),
                        _SettingsItemData(
                          icon: Icons.article_outlined,
                          label: 'Terms & Condition',
                          routeName: '/terms-condition',
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _SettingsGroup(
                      title: 'Settings',
                      items: [
                        _SettingsItemData(
                          icon: Icons.handshake_outlined,
                          label: 'Refer Friend',
                          routeName: '/invite-friend',
                        ),
                        _SettingsItemData(
                          icon: Icons.notifications_none_rounded,
                          label: 'Notification',
                          routeName: '/account-settings',
                        ),
                        _SettingsItemData(
                          icon: Icons.help_outline_rounded,
                          label: 'Help & Support',
                          routeName: '/help-support',
                        ),
                        _SettingsItemData(
                          icon: Icons.logout_rounded,
                          label: 'Log Out',
                        ),
                        _SettingsItemData(
                          icon: Icons.delete_outline_rounded,
                          label: 'Delete Account',
                          isDanger: true,
                        ),
                      ],
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

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.onBack});

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
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 14),
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
                    'Account',
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

class _ParkealoLogo extends StatelessWidget {
  const _ParkealoLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 122,
      height: 49,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 28,
            top: 11,
            child: Container(
              width: 87,
              height: 30,
              padding: const EdgeInsets.only(left: 18, top: 3),
              decoration: BoxDecoration(
                color: _primaryBlue,
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parkealo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 0.95,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Reserva tu Parqueo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 5.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 9,
            top: 2,
            child: CustomPaint(
              size: const Size(40, 46),
              painter: _PinLogoPainter(),
              child: const SizedBox(
                width: 40,
                height: 46,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'P',
                      style: TextStyle(
                        color: _primaryBlue,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinLogoPainter extends CustomPainter {
  const _PinLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final shadow = Paint()
      ..color = const Color(0x30000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    final fill = Paint()..color = _primaryBlue;
    final ring = Paint()..color = Colors.white;

    final path = Path()
      ..moveTo(size.width * 0.5, size.height)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.62,
        0,
        size.height * 0.43,
        0,
        size.height * 0.25,
      )
      ..cubicTo(0, 4, 8, 0, size.width * 0.5, 0)
      ..cubicTo(
        size.width - 8,
        0,
        size.width,
        4,
        size.width,
        size.height * 0.25,
      )
      ..cubicTo(
        size.width,
        size.height * 0.43,
        size.width * 0.82,
        size.height * 0.62,
        size.width * 0.5,
        size.height,
      )
      ..close();

    canvas.drawPath(path.shift(const Offset(1.2, 1.4)), shadow);
    canvas.drawPath(path, fill);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.28), 14, ring);
  }

  @override
  bool shouldRepaint(covariant _PinLogoPainter oldDelegate) => false;
}

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Parkealo',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _ink,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Version 1.0.0 (Build 100)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 9.7,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.copyright_rounded, color: Color(0xFF4B5563), size: 12),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  '2026 parkealo SRL. Santo Domingo, RD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 9.4,
                    fontWeight: FontWeight.w500,
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

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.items});

  final String title;
  final List<_SettingsItemData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 9, 12, 5),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 10.8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          for (var i = 0; i < items.length; i++)
            _SettingsRow(data: items[i], isLast: i == items.length - 1),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.data, required this.isLast});

  final _SettingsItemData data;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = data.isDanger ? _danger : const Color(0xFF4B5563);

    return InkWell(
      onTap: data.routeName == null
          ? () {}
          : () => Navigator.pushNamed(context, data.routeName!),
      child: Container(
        height: 30,
        padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(bottom: BorderSide(color: Color(0xFFF0F3F6))),
        ),
        child: Row(
          children: [
            Icon(data.icon, color: color, size: 15),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (data.hasSwitch)
              Container(
                width: 30,
                height: 17,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                color: data.isDanger ? _danger : const Color(0xFF4B5563),
                size: 17,
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItemData {
  const _SettingsItemData({
    required this.icon,
    required this.label,
    this.hasSwitch = false,
    this.isDanger = false,
    this.routeName,
  });

  final IconData icon;
  final String label;
  final bool hasSwitch;
  final bool isDanger;
  final String? routeName;
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: _line),
    boxShadow: const [
      BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
    ],
  );
}
