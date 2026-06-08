import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF6B7280);
const _green = Color(0xFF16A34A);
const _softGreen = Color(0xFFECFDF5);

class IncomeWithdrawalsPage extends StatelessWidget {
  const IncomeWithdrawalsPage({super.key});

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
            _Header(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SummaryGrid(),
                    const SizedBox(height: 10),
                    const _WithdrawalButton(),
                    const SizedBox(height: 13),
                    _SectionHeader(
                      title: 'Withdrawal account',
                      trailing: _AddAccountButton(
                        onTap: () => Get.toNamed('/add-withdrawal-account'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _EmptyAccountCard(),
                    const SizedBox(height: 13),
                    const _SectionHeader(title: 'Recent transactions'),
                    const SizedBox(height: 8),
                    const _TransactionsCard(),
                    const SizedBox(height: 19),
                    const _InviteHostCard(),
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

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

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
          padding: const EdgeInsets.fromLTRB(2, 6, 14, 16),
          child: SizedBox(
            height: 42,
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 42,
                    height: 42,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Income and withdrawals',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                value: 'RD\$12,450',
                label: 'Available for\nwithdrawal',
              ),
            ),
            SizedBox(width: 9),
            Expanded(
              child: _SummaryCard(
                value: 'RD\$4,200',
                label: 'Pending settlement',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                value: 'RD\$28,600',
                label: 'Bookings this month',
              ),
            ),
            SizedBox(width: 9),
            Expanded(
              child: _SummaryCard(value: '47', label: 'Bookings this month'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.fromLTRB(10, 8, 9, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 8.8,
              height: 1.16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawalButton extends StatelessWidget {
  const _WithdrawalButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/add-withdrawal-account');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _actionBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Request withdrawal - RD\$12,450',
            maxLines: 1,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _AddAccountButton extends StatelessWidget {
  const _AddAccountButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 18,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFD9EAFE)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: _actionBlue, size: 11),
            SizedBox(width: 2),
            Text(
              'Add',
              style: TextStyle(
                color: _actionBlue,
                fontSize: 8.4,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAccountCard extends StatelessWidget {
  const _EmptyAccountCard();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedRoundedBorderPainter(
        color: const Color(0xFFD7DFEA),
        radius: 10,
      ),
      child: Container(
        height: 133,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFF2F4F8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_outlined,
                color: Color(0xFFAAB4C2),
                size: 23,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No withdrawal account added',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Add your bank account to receive\npayments for your parking spaces.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7B8796),
                fontSize: 8.7,
                height: 1.28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionsCard extends StatelessWidget {
  const _TransactionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          _TransactionRow(
            title: 'Booking A3 · Carlos M.',
            time: 'Today 10:30',
            amount: '+RD\$300',
          ),
          SizedBox(height: 14),
          _TransactionRow(
            title: 'Booking B1 · María G.',
            time: 'Today 09:00',
            amount: '+RD\$150',
          ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.title,
    required this.time,
    required this.amount,
  });

  final String title;
  final String time;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 10.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF98A2B3),
                  fontSize: 8.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _green,
            fontSize: 9.1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _InviteHostCard extends StatelessWidget {
  const _InviteHostCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(
        color: _softGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6F6D5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite other hosts',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _green,
                        fontSize: 10.7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Earn RD\$100 for each host that publishes\ntheir first parking with your code',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF5B6B76),
                        fontSize: 7.9,
                        height: 1.22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _HostCodeBox(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ShareButton(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  backgroundColor: const Color(0xFF25D366),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ShareButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  backgroundColor: const Color(0xFF2563EB),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '3 hosts referred · RD\$300 earned hasta now',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF7B8A96),
              fontSize: 7.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HostCodeBox extends StatelessWidget {
  const _HostCodeBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8F3E0)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'HOST-JM3K9',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 9.6,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(
            height: 21,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Copy',
                style: TextStyle(fontSize: 8.3, fontWeight: FontWeight.w900),
              ),
            ),
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
    required this.backgroundColor,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 12),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8.9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 3.0;
    const dashGap = 4.0;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.5),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final end = next > metric.length ? metric.length : next;
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) {
    return color != oldDelegate.color || radius != oldDelegate.radius;
  }
}
