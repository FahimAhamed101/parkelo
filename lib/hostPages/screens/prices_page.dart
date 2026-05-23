import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/host_bottom_nav.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF8A96A8);
const _line = Color(0xFFE1EAF5);
const _warningBg = Color(0xFFFFF4D8);
const _warningText = Color(0xFFB45309);

class PricesBySectionPage extends StatelessWidget {
  const PricesBySectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PricesScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _PricingModeSelector(isGlobal: false),
          SizedBox(height: 8),
          _DynamicPricingCard(),
          SizedBox(height: 10),
          _SectionRateCard(
            prefix: 'A',
            title: 'Ground Floor',
            subtitle: 'Section A1 - A10',
            hour: 'RD\$150',
            day: 'RD\$800',
            week: 'RD\$4500',
          ),
          SizedBox(height: 10),
          _SectionRateCard(
            prefix: 'B',
            title: 'Level 1',
            subtitle: 'Section B1 - B8',
            hour: 'RD\$120',
            day: 'RD\$650',
            week: 'RD\$3800',
          ),
          SizedBox(height: 10),
          _OvertimeCard(),
        ],
      ),
    );
  }
}

class PricesGlobalPage extends StatelessWidget {
  const PricesGlobalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PricesScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _PricingModeSelector(isGlobal: true),
          SizedBox(height: 10),
          _GlobalRatesCard(),
          SizedBox(height: 10),
          _OvertimeCard(),
        ],
      ),
    );
  }
}

class _PricesScaffold extends StatelessWidget {
  const _PricesScaffold({required this.child});

  final Widget child;

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
            _PricesHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 9, 8, 14),
                child: child,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 9),
              child: _SavePricesButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricesHeader extends StatelessWidget {
  const _PricesHeader({required this.onBack});

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
                    'Prices',
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

class _PricingModeSelector extends StatelessWidget {
  const _PricingModeSelector({required this.isGlobal});

  final bool isGlobal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 1, bottom: 6),
          child: Text(
            'Pricing mode',
            style: TextStyle(
              color: _ink,
              fontSize: 9.2,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          height: 36,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FA),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              Expanded(
                child: _ModeSegment(
                  label: 'Global (all same)',
                  isSelected: isGlobal,
                  onTap: () {
                    if (!isGlobal) {
                      Navigator.pushReplacementNamed(context, '/prices-global');
                    }
                  },
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: _ModeSegment(
                  label: 'By section',
                  isSelected: !isGlobal,
                  onTap: () {
                    if (isGlobal) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/prices-by-section',
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? _actionBlue : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_rounded, color: _actionBlue, size: 11),
              const SizedBox(width: 3),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? _primaryBlue : const Color(0xFF667085),
                  fontSize: 8.5,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DynamicPricingCard extends StatelessWidget {
  const _DynamicPricingCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Row(
            children: [
              Expanded(
                child: _CardTitleBlock(
                  title: 'Dynamic pricing',
                  subtitle:
                      'Automatically increases when occupancy exceeds 80%.',
                ),
              ),
              _TinySwitch(),
            ],
          ),
          SizedBox(height: 9),
          _WarningNote(
            text: 'Active — A 20% extra is applied during peak hours',
          ),
        ],
      ),
    );
  }
}

class _GlobalRatesCard extends StatelessWidget {
  const _GlobalRatesCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _CardTitleBlock(
            title: 'Global rates',
            subtitle: 'Applies equally to all sections of the parking lot.',
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _RateBox(label: 'PER HOUR', value: 'RD\$150'),
              ),
              SizedBox(width: 7),
              Expanded(
                child: _RateBox(label: 'PER DAY', value: 'RD\$800'),
              ),
              SizedBox(width: 7),
              Expanded(
                child: _RateBox(label: 'PER WEEK', value: 'RD\$4500'),
              ),
            ],
          ),
          SizedBox(height: 13),
          Text(
            'RATES PREVIEW',
            style: TextStyle(
              color: _muted,
              fontSize: 7.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5),
          _PreviewRow(label: '1 hour', value: 'RD\$150'),
          SizedBox(height: 3),
          _PreviewRow(label: '1 full day', value: 'RD\$800'),
          SizedBox(height: 3),
          _PreviewRow(label: '1 week', value: 'RD\$4500'),
        ],
      ),
    );
  }
}

class _SectionRateCard extends StatelessWidget {
  const _SectionRateCard({
    required this.prefix,
    required this.title,
    required this.subtitle,
    required this.hour,
    required this.day,
    required this.week,
  });

  final String prefix;
  final String title;
  final String subtitle;
  final String hour;
  final String day;
  final String week;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _actionBlue,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  prefix,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _CardTitleBlock(title: title, subtitle: subtitle),
              ),
              const _TinySwitch(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _RateBox(label: 'PER HOUR', value: hour),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _RateBox(label: 'PER DAY', value: day),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _RateBox(label: 'PER WEEK', value: week),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _RateFooter(label: 'Base', value: hour),
              ),
              Expanded(
                child: _RateFooter(label: 'Day', value: day),
              ),
              Expanded(
                child: _RateFooter(label: 'Week', value: week),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OvertimeCard extends StatelessWidget {
  const _OvertimeCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _CardTitleBlock(
            title: 'Overtime',
            subtitle:
                'Additional charge when the user exceeds the reserved time.',
          ),
          SizedBox(height: 12),
          Text(
            'MULTIPLIER',
            style: TextStyle(
              color: _muted,
              fontSize: 7.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7),
          Row(
            children: [
              Expanded(child: _MultiplierChip(label: '1.0x')),
              SizedBox(width: 7),
              Expanded(child: _MultiplierChip(label: '1.5x', isSelected: true)),
              SizedBox(width: 7),
              Expanded(child: _MultiplierChip(label: '2.0x')),
              SizedBox(width: 7),
              Expanded(child: _MultiplierChip(label: '2.5x')),
            ],
          ),
          SizedBox(height: 10),
          _WarningNote(
            text:
                'e.g. If they booked 2h at RD\$150/h and delay 30 min,\novertime charge: RD\$112.50',
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
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: child,
    );
  }
}

class _CardTitleBlock extends StatelessWidget {
  const _CardTitleBlock({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _muted,
            fontSize: 7.1,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TinySwitch extends StatelessWidget {
  const _TinySwitch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 31,
      height: 17,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _actionBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.centerRight,
      child: Container(
        width: 13,
        height: 13,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _RateBox extends StatelessWidget {
  const _RateBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 6.6,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _primaryBlue,
              fontSize: 9.4,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _RateFooter extends StatelessWidget {
  const _RateFooter({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _muted,
            fontSize: 6.8,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontSize: 8.7,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 8.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontSize: 8.2,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _MultiplierChip extends StatelessWidget {
  const _MultiplierChip({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF7E6) : Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isSelected ? const Color(0xFFF59E0B) : _line,
          width: isSelected ? 1.2 : 1,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isSelected ? const Color(0xFFB45309) : _muted,
          fontSize: 8.2,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
      decoration: BoxDecoration(
        color: _warningBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _warningText,
          fontSize: 7.2,
          height: 1.25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SavePricesButton extends StatelessWidget {
  const _SavePricesButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _actionBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: const Text(
          'Save prices',
          style: TextStyle(fontSize: 12.2, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
