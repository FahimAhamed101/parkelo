import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _pageBg = Color(0xFFF4FAF7);
const _ink = Color(0xFF111827);

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

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
            _TermsHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 22, 12, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Terms & Condition',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _ink,
                        fontSize: 13.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 28),
                    Text(
                      'Welcome to Parkealo App !',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 9.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Terms of use — Parkealo\n'
                      'By using Parkealo, you agree that:',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 9.4,
                        height: 1.24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 23),
                    _TermsList(),
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

class _TermsHeader extends StatelessWidget {
  const _TermsHeader({required this.onBack});

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
                    'Terms & Condition',
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

class _TermsList extends StatelessWidget {
  const _TermsList();

  static const _items = [
    'You are responsible for the vehicle and its\ndocuments.',
    'Parkealo acts as an intermediary between the\nuser and the host.',
    'Confirmed reservations generate an\nimmediate charge.',
    'Parkealo is not responsible for damages not\ncovered by the contracted insurance.',
    'Failure to comply with the rules may result in\naccount suspension.',
    'Refunds are subject to review according to the\ndispute policy.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _items.length; i++) ...[
          _TermsListItem(number: i + 1, text: _items[i]),
          if (i != _items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TermsListItem extends StatelessWidget {
  const _TermsListItem({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 14,
          child: Text(
            '$number.',
            style: const TextStyle(
              color: _ink,
              fontSize: 9.7,
              height: 1.28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _ink,
              fontSize: 9.7,
              height: 1.28,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
