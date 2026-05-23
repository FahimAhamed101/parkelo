import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _pageBg = Color(0xFFF4FAF7);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF6B7280);
const _line = Color(0xFFE3EAF0);

class ProfileInfoPage extends StatelessWidget {
  const ProfileInfoPage({super.key});

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
            _ProfileHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 17, 15, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _ProfileHero(),
                    SizedBox(height: 12),
                    _InfoCard(
                      title: 'Personal Information',
                      rows: [
                        _InfoRowData(
                          icon: Icons.person_outline_rounded,
                          label: 'Full Name',
                          value: 'Rokey Mahmud',
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _InfoCard(
                      title: 'Contact Information',
                      rows: [
                        _InfoRowData(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: 'alice@example.com',
                        ),
                        _InfoRowData(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: '+1 (555) 123-4567',
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _IdentificationCard(),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onBack});

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
          padding: const EdgeInsets.fromLTRB(2, 6, 8, 14),
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
                    'Profile Info',
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
                SizedBox(
                  width: 44,
                  height: 42,
                  child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.person_add_alt_1_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const ClipOval(
                child: CustomPaint(painter: _AvatarPainter()),
              ),
            ),
            Positioned(
              right: 2,
              bottom: 1,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: _primaryBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.4),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Rokey Mahmud',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _ink,
            fontSize: 11.4,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 10.7,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < rows.length; i++) ...[
            _InfoRow(data: rows[i]),
            if (i != rows.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.data});

  final _InfoRowData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Icon(data.icon, color: const Color(0xFF6B7280), size: 15),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 8.7,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 10.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IdentificationCard extends StatelessWidget {
  const _IdentificationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Identification',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _ink,
              fontSize: 10.7,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 9),
          _NidRow(),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _IdPreview(label: 'ID Card Front', isBack: false),
              ),
              SizedBox(width: 9),
              Expanded(child: _IdPreview(label: 'ID Card Back', isBack: true)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NidRow extends StatelessWidget {
  const _NidRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NID',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _muted,
                  fontSize: 8.7,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '285945554',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _ink,
                  fontSize: 10.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IdPreview extends StatelessWidget {
  const _IdPreview({required this.label, required this.isBack});

  final String label;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.52,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: const Color(0xFFD1D5DB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: CustomPaint(painter: _IdCardPainter(isBack: isBack)),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontSize: 8.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AvatarPainter extends CustomPainter {
  const _AvatarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()..color = const Color(0xFFD9F0FF);
    final trees = Paint()..color = const Color(0xFF7FB13D);
    final dark = Paint()..color = const Color(0xFF1F2937);
    final skin = Paint()..color = const Color(0xFFB77755);
    final shirt = Paint()..color = Colors.white;
    final jacket = Paint()..color = const Color(0xFF111827);
    final glasses = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRect(Offset.zero & size, sky);
    canvas.drawCircle(Offset(size.width * 0.26, size.height * 0.09), 11, trees);
    canvas.drawCircle(Offset(size.width * 0.39, size.height * 0.04), 13, trees);
    canvas.drawCircle(Offset(size.width * 0.12, size.height * 0.22), 9, trees);
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.63,
        size.width * 0.46,
        size.height * 0.44,
      ),
      shirt,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.08, size.height)
        ..lineTo(size.width * 0.32, size.height * 0.62)
        ..lineTo(size.width * 0.50, size.height)
        ..close(),
      jacket,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.92, size.height)
        ..lineTo(size.width * 0.66, size.height * 0.62)
        ..lineTo(size.width * 0.48, size.height)
        ..close(),
      jacket,
    );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.36,
        size.height * 0.24,
        size.width * 0.30,
        size.height * 0.32,
      ),
      skin,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.34, size.height * 0.29)
        ..quadraticBezierTo(
          size.width * 0.49,
          size.height * 0.13,
          size.width * 0.69,
          size.height * 0.27,
        )
        ..lineTo(size.width * 0.66, size.height * 0.36)
        ..quadraticBezierTo(
          size.width * 0.49,
          size.height * 0.23,
          size.width * 0.37,
          size.height * 0.36,
        )
        ..close(),
      dark,
    );
    canvas.drawCircle(
      Offset(size.width * 0.45, size.height * 0.39),
      4,
      glasses,
    );
    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.39),
      4,
      glasses,
    );
    canvas.drawLine(
      Offset(size.width * 0.49, size.height * 0.39),
      Offset(size.width * 0.54, size.height * 0.39),
      glasses,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.44,
        size.height * 0.43,
        size.width * 0.16,
        size.height * 0.08,
      ),
      0.2,
      2.6,
      false,
      Paint()
        ..color = const Color(0xFF4B1F16)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) => false;
}

class _IdCardPainter extends CustomPainter {
  const _IdCardPainter({required this.isBack});

  final bool isBack;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFFFFFFF);
    final red = Paint()..color = const Color(0xFFE11D48);
    final green = Paint()..color = const Color(0xFF15803D);
    final yellow = Paint()..color = const Color(0xFFFACC15);
    final lightBlue = Paint()..color = const Color(0xFFEAF4FF);
    final photo = Paint()..color = const Color(0xFFE5E7EB);
    final gray = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..strokeWidth = 1;

    canvas.drawRect(Offset.zero & size, bg);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.19), red);
    canvas.drawCircle(
      Offset(size.width * 0.10, size.height * 0.095),
      6,
      yellow,
    );
    canvas.drawCircle(Offset(size.width * 0.10, size.height * 0.095), 3, green);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.20,
        size.height * 0.035,
        size.width * 0.72,
        size.height * 0.035,
      ),
      green,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.20,
        size.height * 0.092,
        size.width * 0.56,
        size.height * 0.026,
      ),
      Paint()..color = Colors.white,
    );

    if (isBack) {
      _drawBack(canvas, size, gray, lightBlue);
    } else {
      _drawFront(canvas, size, gray, lightBlue, photo);
    }

    final titlePainter = TextPainter(
      text: TextSpan(
        text: isBack ? 'NATIONAL ID CARD' : 'IDENTITY CARD',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 5,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width * 0.6);
    titlePainter.paint(canvas, Offset(size.width * 0.22, size.height * 0.125));
  }

  void _drawFront(
    Canvas canvas,
    Size size,
    Paint gray,
    Paint lightBlue,
    Paint photo,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.07,
        size.height * 0.31,
        size.width * 0.23,
        size.height * 0.33,
      ),
      photo,
    );
    canvas.drawCircle(
      Offset(size.width * 0.185, size.height * 0.41),
      size.width * 0.055,
      Paint()..color = const Color(0xFFD1D5DB),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.13,
        size.height * 0.49,
        size.width * 0.11,
        size.height * 0.10,
      ),
      Paint()..color = const Color(0xFFD1D5DB),
    );
    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.30 + i * 0.075);
      canvas.drawLine(
        Offset(size.width * 0.36, y),
        Offset(size.width * (i.isEven ? 0.86 : 0.78), y),
        gray,
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.05,
        size.height * 0.69,
        size.width * 0.90,
        size.height * 0.12,
      ),
      lightBlue,
    );
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.87),
      Offset(size.width * 0.39, size.height * 0.87),
      gray,
    );
    canvas.drawLine(
      Offset(size.width * 0.56, size.height * 0.87),
      Offset(size.width * 0.88, size.height * 0.87),
      gray,
    );
  }

  void _drawBack(Canvas canvas, Size size, Paint gray, Paint lightBlue) {
    for (var i = 0; i < 8; i++) {
      final y = size.height * (0.29 + i * 0.055);
      canvas.drawLine(
        Offset(size.width * 0.08, y),
        Offset(size.width * (i.isEven ? 0.91 : 0.80), y),
        gray,
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.73,
        size.width * 0.33,
        size.height * 0.12,
      ),
      lightBlue,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.54,
        size.height * 0.70,
        size.width * 0.34,
        size.height * 0.15,
      ),
      Paint()..color = const Color(0xFFE5E7EB),
    );
    canvas.drawLine(
      Offset(size.width * 0.56, size.height * 0.77),
      Offset(size.width * 0.86, size.height * 0.77),
      gray,
    );
  }

  @override
  bool shouldRepaint(covariant _IdCardPainter oldDelegate) {
    return isBack != oldDelegate.isBack;
  }
}

class _InfoRowData {
  const _InfoRowData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
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
