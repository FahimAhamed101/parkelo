import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFF4FAF7);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF6B7280);
const _line = Color(0xFFE3EAF0);
const _green = Color(0xFF16A34A);
const _orange = Color(0xFFF97316);

class InviteFriendPage extends StatelessWidget {
  const InviteFriendPage({super.key});

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
            _InviteHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(9, 7, 9, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _EarnedCard(),
                    SizedBox(height: 8),
                    _HowItWorksCard(),
                    SizedBox(height: 8),
                    _ReferralCodeCard(),
                    SizedBox(height: 8),
                    _ReferralsCard(),
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

class _InviteHeader extends StatelessWidget {
  const _InviteHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 12),
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
                    'Invite friend',
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

class _EarnedCard extends StatelessWidget {
  const _EarnedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 101,
      decoration: BoxDecoration(
        color: const Color(0xFF075DB9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.celebration_rounded, color: Color(0xFFFFD166), size: 30),
          SizedBox(height: 7),
          Text(
            'RD\$100 earned',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'For 2 referred friends',
            style: TextStyle(
              color: Color(0xFFE2F0FF),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(9, 10, 9, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'How it works?',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 12.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10),
          _StepRow(number: '1', text: 'Share your code with friends'),
          SizedBox(height: 9),
          _StepRow(number: '2', text: 'Your friend registers with your code'),
          SizedBox(height: 9),
          _StepRow(
            number: '3',
            text: 'Both earn RD\$50 upon making your first\nreservation',
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 17,
          height: 17,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F2FF),
            shape: BoxShape.circle,
            border: Border.all(color: _actionBlue),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: _primaryBlue,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _ink,
              fontSize: 8.8,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReferralCodeCard extends StatelessWidget {
  const _ReferralCodeCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR REFERRAL CODE',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 9.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          CustomPaint(
            foregroundPainter: _DashedBorderPainter(),
            child: Container(
              height: 48,
              padding: const EdgeInsets.fromLTRB(14, 0, 10, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'PARK-CM7X2',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _primaryBlue,
                        fontSize: 10.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 27,
                    width: 58,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Copy',
                        style: TextStyle(
                          fontSize: 9.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ShareButton(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  color: const Color(0xFF22C55E),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ShareButton(
                  icon: Icons.facebook_rounded,
                  label: 'Facebook',
                  color: const Color(0xFF1877F2),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ShareButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  color: const Color(0xFF4B5563),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 11),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(fontSize: 8.4, fontWeight: FontWeight.w900),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}

class _ReferralsCard extends StatelessWidget {
  const _ReferralsCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'YOUR REFERRALS (3)',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 9.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 16),
          _ReferralRow(
            name: 'Roberto P.',
            time: '2 days ago',
            amount: 'RD\$50',
            status: 'EARNED',
            avatarColor: Color(0xFF0EA5E9),
            pending: false,
          ),
          SizedBox(height: 13),
          _ReferralRow(
            name: 'Lucia M.',
            time: '5 days ago',
            amount: 'RD\$50',
            status: 'EARNED',
            avatarColor: Color(0xFFBE185D),
            pending: false,
          ),
          SizedBox(height: 13),
          _ReferralRow(
            name: 'Diego F.',
            time: 'Pending',
            amount: 'RD\$50',
            status: 'PENDING',
            avatarColor: Color(0xFF334155),
            pending: true,
          ),
          SizedBox(height: 20),
          _BalanceNote(),
        ],
      ),
    );
  }
}

class _ReferralRow extends StatelessWidget {
  const _ReferralRow({
    required this.name,
    required this.time,
    required this.amount,
    required this.status,
    required this.avatarColor,
    required this.pending,
  });

  final String name;
  final String time;
  final String amount;
  final String status;
  final Color avatarColor;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: avatarColor,
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 10.1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 8.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: TextStyle(
                color: pending ? _orange : _green,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              status,
              style: TextStyle(
                color: pending ? _orange : _green,
                fontSize: 7.8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceNote extends StatelessWidget {
  const _BalanceNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 10, 11, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: const [
          Icon(Icons.savings_outlined, color: Color(0xFF9A7B1F), size: 13),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Available balance: RD\$100 — Redeemable on\nyour next reservation',
              style: TextStyle(
                color: Color(0xFF166534),
                fontSize: 7.8,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.6),
          const Radius.circular(6),
        ),
      );
    final paint = Paint()
      ..color = _actionBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = mathMin(distance + 4, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 8;
      }
    }
  }

  double mathMin(double a, double b) => a < b ? a : b;

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}
