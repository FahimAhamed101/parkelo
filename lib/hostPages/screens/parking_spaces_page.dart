import 'package:flutter/material.dart';

import '../widgets/host_panel_chrome.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF8A96A8);
const _green = Color(0xFF16A34A);
const _greenBorder = Color(0xFF86EFAC);
const _greenBg = Color(0xFFE9FFF4);
const _red = Color(0xFFEF4444);
const _redBorder = Color(0xFFFCA5A5);
const _redBg = Color(0xFFFFEEF0);

class ParkingSpacesPage extends StatelessWidget {
  const ParkingSpacesPage({super.key});

  static const _sections = [
    _ParkingSectionData(
      title: 'Ground Floor',
      free: 7,
      occupied: 3,
      total: 10,
      spaces: [
        _ParkingSpaceData('A1', true),
        _ParkingSpaceData('A2', false),
        _ParkingSpaceData('A3', false),
        _ParkingSpaceData('A4', true),
        _ParkingSpaceData('A5', false),
        _ParkingSpaceData('A6', false),
        _ParkingSpaceData('A7', true),
        _ParkingSpaceData('A8', false),
        _ParkingSpaceData('A9', false),
        _ParkingSpaceData('A10', false),
      ],
    ),
    _ParkingSectionData(
      title: 'Level 1',
      free: 6,
      occupied: 2,
      total: 8,
      spaces: [
        _ParkingSpaceData('B1', false),
        _ParkingSpaceData('B2', true),
        _ParkingSpaceData('B3', false),
        _ParkingSpaceData('B4', false),
        _ParkingSpaceData('B5', true),
        _ParkingSpaceData('B6', false),
        _ParkingSpaceData('B7', false),
        _ParkingSpaceData('B8', false),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return HostPanelScaffold(
      selectedTab: HostPanelTab.parking,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(13, 18, 13, 28),
        child: Column(
          children: [
            for (var i = 0; i < _sections.length; i++) ...[
              _ParkingSectionCard(
                section: _sections[i],
                action: _SettingsButton(
                  onTap: () =>
                      Navigator.pushNamed(context, '/parking-spaces-config'),
                ),
              ),
              if (i != _sections.length - 1) const SizedBox(height: 14),
            ],
            const SizedBox(height: 14),
            _AddSectionButton(onTap: () => _showNewSectionSheet(context)),
          ],
        ),
      ),
    );
  }

  static void _showNewSectionSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewSectionSheet(),
    );
  }
}

class ParkingSpacesConfigPage extends StatelessWidget {
  const ParkingSpacesConfigPage({super.key});

  static const _sections = ParkingSpacesPage._sections;

  @override
  Widget build(BuildContext context) {
    return HostPanelScaffold(
      selectedTab: HostPanelTab.parking,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(13, 18, 13, 10),
              child: Column(
                children: [
                  for (var i = 0; i < _sections.length; i++) ...[
                    _ParkingSectionCard(
                      section: _sections[i],
                      action: _DoneButton(
                        onTap: () => Navigator.maybePop(context),
                      ),
                      showConfiguration: true,
                    ),
                    if (i != _sections.length - 1) const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 2, 13, 12),
            child: _AddSectionButton(
              onTap: () => _showNewSectionSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  static void _showNewSectionSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _NewSectionSheet(),
    );
  }
}

class _ParkingSectionCard extends StatelessWidget {
  const _ParkingSectionCard({
    required this.section,
    required this.action,
    this.showConfiguration = false,
  });

  final _ParkingSectionData section;
  final Widget action;
  final bool showConfiguration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 14, 16, showConfiguration ? 12 : 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EAF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              action,
            ],
          ),
          const SizedBox(height: 8),
          _SectionStats(section: section),
          if (showConfiguration) ...[
            const SizedBox(height: 12),
            const _ConfigurePanel(),
          ],
          const SizedBox(height: 15),
          _SpacesWrap(spaces: section.spaces),
          const SizedBox(height: 14),
          const _SpaceLegend(),
        ],
      ),
    );
  }
}

class _SectionStats extends StatelessWidget {
  const _SectionStats({required this.section});

  final _ParkingSectionData section;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(fontSize: 8.8, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: '${section.free} free',
            style: const TextStyle(color: _green),
          ),
          const TextSpan(
            text: '  \u2022  ',
            style: TextStyle(color: Color(0xFFB4C0CE)),
          ),
          TextSpan(
            text: '${section.occupied} occupied',
            style: const TextStyle(color: _red),
          ),
          const TextSpan(
            text: '  \u2022  ',
            style: TextStyle(color: Color(0xFFB4C0CE)),
          ),
          TextSpan(
            text: '${section.total} total',
            style: const TextStyle(color: Color(0xFFB4C0CE)),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 27,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings_outlined, color: Color(0xFF4B5563), size: 12),
            SizedBox(width: 4),
            Text(
              'Config',
              style: TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 22,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _primaryBlue),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, color: _primaryBlue, size: 11),
            SizedBox(width: 3),
            Text(
              'Done',
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigurePanel extends StatelessWidget {
  const _ConfigurePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'CONFIGURE SECTION',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 7.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 86,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Space prefix',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 7.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFFDCE7F5)),
                      ),
                      child: const Text(
                        'A',
                        style: TextStyle(
                          color: _primaryBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Spaces will be A1, A2...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _muted, fontSize: 6.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Number of spaces',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 7.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    _NumberChips(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            constraints: const BoxConstraints(minHeight: 36),
            padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FF),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: _primaryBlue,
                  size: 12,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Tap any space on the map below to\nchange its identifier or status.',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 7,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
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

class _NumberChips extends StatelessWidget {
  const _NumberChips();

  @override
  Widget build(BuildContext context) {
    const values = ['5', '10', '15', '20', '25', '30'];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final value in values)
          _NumberChip(label: value, isSelected: value == '10'),
      ],
    );
  }
}

class _NumberChip extends StatelessWidget {
  const _NumberChip({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? _actionBlue : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isSelected ? _actionBlue : const Color(0xFFDCE7F5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : _ink,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SpacesWrap extends StatelessWidget {
  const _SpacesWrap({required this.spaces});

  final List<_ParkingSpaceData> spaces;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final itemWidth = (constraints.maxWidth - (spacing * 4)) / 5;

        return Wrap(
          spacing: spacing,
          runSpacing: 8,
          children: [
            for (final space in spaces)
              SizedBox(
                width: itemWidth,
                height: 44,
                child: _SpaceTile(space: space),
              ),
          ],
        );
      },
    );
  }
}

class _SpaceTile extends StatelessWidget {
  const _SpaceTile({required this.space});

  final _ParkingSpaceData space;

  @override
  Widget build(BuildContext context) {
    final color = space.isOccupied ? _red : _green;

    return Container(
      decoration: BoxDecoration(
        color: space.isOccupied ? _redBg : _greenBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: space.isOccupied ? _redBorder : _greenBorder,
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            space.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            space.isOccupied
                ? Icons.directions_car_filled_rounded
                : Icons.check_rounded,
            color: color,
            size: space.isOccupied ? 12 : 14,
          ),
        ],
      ),
    );
  }
}

class _SpaceLegend extends StatelessWidget {
  const _SpaceLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _LegendItem(
          label: 'Free',
          borderColor: _greenBorder,
          fillColor: Color(0xFFF4FFF9),
        ),
        const SizedBox(width: 10),
        const _LegendItem(
          label: 'Occupied',
          borderColor: _redBorder,
          fillColor: Color(0xFFFFF6F7),
        ),
        const Spacer(),
        Text(
          'Tap to change status',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _actionBlue.withAlpha(125),
            fontSize: 7.2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.borderColor,
    required this.fillColor,
  });

  final String label;
  final Color borderColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 7.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AddSectionButton extends StatelessWidget {
  const _AddSectionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 43,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFDDE7F3),
            style: BorderStyle.solid,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: _primaryBlue, size: 18),
            SizedBox(width: 8),
            Text(
              'Add parking section',
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewSectionSheet extends StatelessWidget {
  const _NewSectionSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(7, 10, 7, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'New parking section',
                style: TextStyle(
                  color: _primaryBlue,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              const _SheetLabel('Section name'),
              const SizedBox(height: 5),
              const _SheetInput(hint: 'e.g. Ground Floor, VIP, Roof'),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SheetLabel('Prefix (letters/numbers)'),
                        SizedBox(height: 5),
                        _SheetInput(hint: 'A, VIP, T1...'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _SheetLabel('Quantity'),
                        SizedBox(height: 5),
                        _SheetQuantityChips(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SheetButton(
                      label: 'Cancel',
                      isPrimary: false,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _SheetButton(
                      label: 'Create section',
                      isPrimary: true,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  const _SheetLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 7.3,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  const _SheetInput({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextField(
        style: const TextStyle(color: _ink, fontSize: 9),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFB4BFCD),
            fontSize: 8.7,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: _sheetInputBorder(const Color(0xFFDDE7F3)),
          focusedBorder: _sheetInputBorder(_primaryBlue),
        ),
      ),
    );
  }

  static OutlineInputBorder _sheetInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: color),
    );
  }
}

class _SheetQuantityChips extends StatelessWidget {
  const _SheetQuantityChips();

  @override
  Widget build(BuildContext context) {
    const values = ['5', '10', '15', '20'];

    return Row(
      children: [
        for (var i = 0; i < values.length; i++) ...[
          _SheetQuantityChip(label: values[i], isSelected: values[i] == '10'),
          if (i != values.length - 1) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class _SheetQuantityChip extends StatelessWidget {
  const _SheetQuantityChip({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? _actionBlue : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isSelected ? _actionBlue : const Color(0xFFDDE7F3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : _ink,
          fontSize: 7.8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: isPrimary ? _actionBlue : Colors.white,
          foregroundColor: isPrimary ? Colors.white : _actionBlue,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: _actionBlue),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

class _ParkingSectionData {
  const _ParkingSectionData({
    required this.title,
    required this.free,
    required this.occupied,
    required this.total,
    required this.spaces,
  });

  final String title;
  final int free;
  final int occupied;
  final int total;
  final List<_ParkingSpaceData> spaces;
}

class _ParkingSpaceData {
  const _ParkingSpaceData(this.label, this.isOccupied);

  final String label;
  final bool isOccupied;
}
