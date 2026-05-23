import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _pageBg = Color(0xFFF4FAF7);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF4B5563);
const _line = Color(0xFFE3EAF0);

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

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
            _FaqHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 13, 12, 28),
                child: Column(
                  children: const [
                    _FaqItem(
                      question: 'How do i book a service App?',
                      answer:
                          'Select your service, pick a date & time, and confirm. You\'ll\nget a notification with details.',
                      isExpanded: true,
                    ),
                    SizedBox(height: 8),
                    _FaqItem(
                      question: 'Can I reschedule or cancel my booking?',
                    ),
                    SizedBox(height: 8),
                    _FaqItem(question: 'What payment methods are accepted?'),
                    SizedBox(height: 8),
                    _FaqItem(
                      question: 'How do I contact the service provider?',
                    ),
                    SizedBox(height: 8),
                    _FaqItem(question: 'Is my personal information safe?'),
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

class _FaqHeader extends StatelessWidget {
  const _FaqHeader({required this.onBack});

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
                    'Faq',
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

class _FaqItem extends StatelessWidget {
  const _FaqItem({
    required this.question,
    this.answer,
    this.isExpanded = false,
  });

  final String question;
  final String? answer;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: isExpanded ? 88 : 47),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.fromLTRB(11, isExpanded ? 11 : 0, 8, 0),
            child: isExpanded
                ? _ExpandedFaqContent(this)
                : _CollapsedFaqRow(this),
          ),
        ),
      ),
    );
  }
}

class _CollapsedFaqRow extends StatelessWidget {
  const _CollapsedFaqRow(this.item);

  final _FaqItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.question,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 10.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF4B5563),
          size: 17,
        ),
      ],
    );
  }
}

class _ExpandedFaqContent extends StatelessWidget {
  const _ExpandedFaqContent(this.item);

  final _FaqItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.question,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 10.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Color(0xFF4B5563),
              size: 17,
            ),
          ],
        ),
        const SizedBox(height: 19),
        Text(
          item.answer ?? '',
          style: const TextStyle(
            color: _muted,
            fontSize: 7.7,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
