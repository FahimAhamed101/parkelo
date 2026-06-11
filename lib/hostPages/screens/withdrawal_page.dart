import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../services/host_api_client.dart';

const _green = Color(0xFF0B8F4D);
const _greenDark = Color(0xFF06733E);
const _greenSoft = Color(0xFFE9FFF3);
const _blue = Color(0xFF1F59D1);
const _blueSoft = Color(0xFFEFF5FF);
const _gold = Color(0xFF996B00);
const _goldSoft = Color(0xFFFFF5DB);
const _red = Color(0xFFC41230);
const _pageBg = Color(0xFFF1F6FC);
const _ink = Color(0xFF06143A);
const _muted = Color(0xFF8090B2);
const _border = Color(0xFFDDE7F3);

class IncomeWithdrawalsPage extends StatefulWidget {
  const IncomeWithdrawalsPage({super.key});

  @override
  State<IncomeWithdrawalsPage> createState() => _IncomeWithdrawalsPageState();
}

class _IncomeWithdrawalsPageState extends State<IncomeWithdrawalsPage> {
  late Future<Map<String, dynamic>> _incomeFuture;

  @override
  void initState() {
    super.initState();
    _incomeFuture = HostApiClient.instance.fetchIncome();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _greenDark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        bottomNavigationBar: const _HostBottomBar(),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _incomeFuture,
          builder: (context, snapshot) {
            final income =
                snapshot.data?['income'] as Map<String, dynamic>? ??
                _fallbackIncome();

            return RefreshIndicator(
              color: _green,
              onRefresh: () async {
                setState(() {
                  _incomeFuture = HostApiClient.instance.fetchIncome();
                });
                await _incomeFuture;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  const SliverToBoxAdapter(child: _Header()),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        _SummaryGrid(income: income),
                        const SizedBox(height: 18),
                        _WithdrawalButton(income: income),
                        const SizedBox(height: 18),
                        _WithdrawalAccountCard(income: income),
                        const SizedBox(height: 18),
                        _MovementsCard(income: income),
                        const SizedBox(height: 16),
                        _ChartCard(income: income),
                        const SizedBox(height: 16),
                        _InviteHostCard(income: income),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, dynamic> _fallbackIncome() {
    return {
      'availableForWithdrawalLabel': 'RD\$12,450',
      'pendingToClearLabel': 'RD\$4,200',
      'revenueThisMonthLabel': 'RD\$28,600',
      'bookingsThisMonth': 47,
      'bankAccount': null,
      'movements': const [],
      'chart': const [],
    };
  }
}

class _HostBottomBar extends StatelessWidget {
  const _HostBottomBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 66,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _border)),
        ),
        child: Row(
          children: const [
            _BottomItem(icon: Icons.map_outlined, label: 'Explore'),
            _BottomItem(
              icon: Icons.calendar_month_outlined,
              label: 'Bookingtions',
            ),
            _BottomItem(
              icon: Icons.favorite_border_rounded,
              label: 'Favorites',
            ),
            _BottomItem(
              icon: Icons.home_rounded,
              label: 'Host',
              selected: true,
            ),
            _BottomItem(icon: Icons.person_outline_rounded, label: 'Account'),
            _BottomItem(icon: Icons.settings_outlined, label: 'Admin'),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 29,
            height: 29,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? _blue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 19,
              color: selected ? Colors.white : const Color(0xFF5270A9),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? _blue : const Color(0xFF8BA0C8),
              fontSize: 8,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: selected ? 18 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: selected ? _green : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: _greenDark),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 20, 18),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos y retiros',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Parking Colonial Premium',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFFBDEBD0),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.income});

  final Map<String, dynamic> income;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                value:
                    income['availableForWithdrawalLabel']?.toString() ??
                    'RD\$0',
                label: 'Available para retirar',
                color: _green,
                background: _greenSoft,
                borderColor: _green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                value: income['pendingToClearLabel']?.toString() ?? 'RD\$0',
                label: 'Pendiente de liquidar',
                color: _gold,
                background: _goldSoft,
                borderColor: _gold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                value: income['revenueThisMonthLabel']?.toString() ?? 'RD\$0',
                label: 'Retirado este mes',
                color: _blue,
                background: _blueSoft,
                borderColor: _blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                value: '${income['bookingsThisMonth'] ?? 0}',
                label: 'Bookingiones este mes',
                color: _blue,
                background: _blueSoft,
                borderColor: _border,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.value,
    required this.label,
    required this.color,
    required this.background,
    required this.borderColor,
  });

  final String value;
  final String label;
  final Color color;
  final Color background;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(14, 13, 12, 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: Border(top: BorderSide(color: borderColor, width: 2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0B2448),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawalButton extends StatelessWidget {
  const _WithdrawalButton({required this.income});

  final Map<String, dynamic> income;

  @override
  Widget build(BuildContext context) {
    final amount = income['availableForWithdrawalLabel']?.toString() ?? 'RD\$0';

    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () => Get.toNamed('/add-withdrawal-account'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.credit_card_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Request retiro - $amount',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
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

class _WithdrawalAccountCard extends StatelessWidget {
  const _WithdrawalAccountCard({required this.income});

  final Map<String, dynamic> income;

  @override
  Widget build(BuildContext context) {
    final account = income['bankAccount'] as Map<String, dynamic>?;

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Account de retiro',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _AddButton(onTap: () => Get.toNamed('/add-withdrawal-account')),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            constraints: const BoxConstraints(minHeight: 136),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: account == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        color: Color(0xFF9AA7BA),
                        size: 36,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Sin cuenta de retiro',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Agrega tu cuenta bancaria para recibir pagos\nde tus parqueos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _muted,
                          fontSize: 12,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_rounded,
                        color: _green,
                        size: 34,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        account['bankName']?.toString() ?? 'Banco',
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        account['accountNumberMasked']?.toString() ?? '',
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F8FF),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFBFD4F8)),
        ),
        alignment: Alignment.center,
        child: const Text(
          '+ Agregar',
          style: TextStyle(
            color: _blue,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _MovementsCard extends StatelessWidget {
  const _MovementsCard({required this.income});

  final Map<String, dynamic> income;

  @override
  Widget build(BuildContext context) {
    final movements = (income['movements'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Últimos movimientos',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          if (movements.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Todavía no hay movimientos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontWeight: FontWeight.w700),
              ),
            )
          else
            for (var i = 0; i < movements.take(5).length; i++) ...[
              _MovementRow(movement: movements[i]),
              if (i != movements.take(5).length - 1)
                const Divider(height: 22, color: _border),
            ],
        ],
      ),
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.movement});

  final Map<String, dynamic> movement;

  @override
  Widget build(BuildContext context) {
    final amount = (movement['amount'] as num?) ?? 0;
    final amountLabel = movement['amountLabel']?.toString() ?? 'RD\$0';
    final isPositive = amount >= 0 || amountLabel.startsWith('+');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movement['label']?.toString() ?? 'Movimiento',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                movement['detail']?.toString() ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF9AABD0),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          amountLabel,
          style: TextStyle(
            color: isPositive ? _green : _red,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.income});

  final Map<String, dynamic> income;

  @override
  Widget build(BuildContext context) {
    final chart = (income['chart'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final bars = chart.isEmpty
        ? [
            {'label': '6am', 'bookings': 1},
            {'label': '9am', 'bookings': 4},
            {'label': '12pm', 'bookings': 3},
            {'label': '3pm', 'bookings': 5},
            {'label': '6pm', 'bookings': 4},
            {'label': '9pm', 'bookings': 1},
          ]
        : chart;
    final maxValue = bars.fold<int>(1, (max, item) {
      final value = (item['bookings'] as num?)?.round() ?? 0;
      return value > max ? value : max;
    });

    return _WhiteCard(
      child: Column(
        children: [
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final item in bars)
                  Expanded(
                    child: _ChartBar(
                      label: item['label']?.toString() ?? '',
                      value: (item['bookings'] as num?)?.round() ?? 0,
                      maxValue: maxValue,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              _Legend(color: _green, label: 'Alto'),
              SizedBox(width: 18),
              _Legend(color: _blue, label: 'Medio'),
              SizedBox(width: 18),
              _Legend(color: Color(0xFFE9EFF8), label: 'Bajo'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({
    required this.label,
    required this.value,
    required this.maxValue,
  });

  final String label;
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue == 0 ? 0.0 : value / maxValue;
    final color = ratio >= 0.75
        ? _green
        : ratio >= 0.45
        ? _blue
        : const Color(0xFFE9EFF8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 64 * ratio.clamp(0.14, 1.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF9AABD0),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6F7FA0),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InviteHostCard extends StatelessWidget {
  const _InviteHostCard({required this.income});

  final Map<String, dynamic> income;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 13),
      decoration: BoxDecoration(
        color: _greenSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF98E3B8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invita a otros hosts',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _green,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Gana RD\$100 por cada host que publique su\nprimer parqueo con tu código',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF6580A0),
                        fontSize: 12,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _blue, style: BorderStyle.solid),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'HOST-JM3K9',
                    style: TextStyle(
                      color: _blue,
                      fontSize: 15,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      const ClipboardData(text: 'HOST-JM3K9'),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Copiar',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ShareButton(
                  color: const Color(0xFF25D366),
                  label: 'WhatsApp',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ShareButton(
                  color: _blue,
                  label: 'Compartir',
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Text(
            '3 hosts referidos - RD\$300 ganados hasta now',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF7C91A8),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.color,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C0B2448),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
