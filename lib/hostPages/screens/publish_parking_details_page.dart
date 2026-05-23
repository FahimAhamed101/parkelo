import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _line = Color(0xFFDDE6F1);

class PublishParkingDetailsPage extends StatelessWidget {
  const PublishParkingDetailsPage({super.key});

  static const _tabs = ['Location', 'Details', 'Spaces', 'Services', 'Photos'];

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
                padding: const EdgeInsets.fromLTRB(11, 16, 11, 26),
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
                    const SizedBox(height: 12),
                    const Text(
                      'Write any number: 1, 2, 10, 50, 100... You will be able to\nconfigure sections and labels from the dashboard.',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 8.8,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('LEVELS / FLOORS'),
                    const SizedBox(height: 9),
                    const _LevelSelector(),
                    const SizedBox(height: 17),
                    const _FieldLabel('SCHEDULE'),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Expanded(
                          child: _ScheduleButton(label: '24/7', isActive: true),
                        ),
                        SizedBox(width: 17),
                        Expanded(
                          child: _ScheduleButton(
                            label: 'Specific schedule',
                            isActive: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const _FieldLabel('DESCRIPTION'),
                    const SizedBox(height: 8),
                    const _TextAreaBox(
                      hint:
                          'Describe your parking: materials, security, how to\nfind it...',
                    ),
                    const SizedBox(height: 18),
                    const _FieldLabel('PARKING RULES'),
                    const SizedBox(height: 8),
                    const _TextAreaBox(
                      hint:
                          'Example: No trucks allowed. Respect speed\nsigns...',
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/publish-parking-spaces',
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
                            fontSize: 12.5,
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF7C8797),
        fontSize: 8.8,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  const _LevelSelector();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _LevelButton(icon: Icons.remove_rounded),
          SizedBox(width: 21),
          Text(
            'Level 1',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 21),
          _LevelButton(icon: Icons.add_rounded),
        ],
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  const _LevelButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 25,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryBlue,
          padding: EdgeInsets.zero,
          side: const BorderSide(color: _primaryBlue, width: 1),
          shape: const CircleBorder(),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _ScheduleButton extends StatelessWidget {
  const _ScheduleButton({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF5FAFF) : const Color(0xFFEAEFF5),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isActive ? _actionBlue : const Color(0xFFEAEFF5),
          width: 1.4,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isActive ? _actionBlue : const Color(0xFF8B95A3),
          fontSize: 9,
          fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _TextAreaBox extends StatelessWidget {
  const _TextAreaBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: TextField(
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(color: _ink, fontSize: 10),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF9CA7B6),
            fontSize: 8.7,
            height: 1.25,
          ),
          contentPadding: const EdgeInsets.fromLTRB(11, 11, 11, 9),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: _border(_line),
          focusedBorder: _border(_primaryBlue),
        ),
      ),
    );
  }

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
