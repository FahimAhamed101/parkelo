import 'package:flutter/material.dart';

import '../services/host_publish_flow_service.dart';
import '../widgets/publish_parking_flow.dart';

class PublishParkingDetailsPage extends StatefulWidget {
  const PublishParkingDetailsPage({super.key});

  @override
  State<PublishParkingDetailsPage> createState() =>
      _PublishParkingDetailsPageState();
}

class _PublishParkingDetailsPageState extends State<PublishParkingDetailsPage> {
  final _spacesController = TextEditingController(text: '10');
  final _descriptionController = TextEditingController();
  final _rulesController = TextEditingController();

  String _parkingType = 'public';
  int _floors = 1;
  bool _open24Hours = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final parking = HostPublishFlowService.instance.parking ?? const {};
    final availability = parking['spaces'] as Map<String, dynamic>? ?? const {};
    _parkingType = (parking['parkingType'] as String? ?? 'public') == 'private'
        ? 'private'
        : 'public';
    _spacesController.text = ((availability['total'] as num?)?.toInt() ?? 10)
        .toString();
    _floors = ((availability['floors'] as num?)?.toInt() ?? 1).clamp(1, 30);
    _descriptionController.text = parking['description'] as String? ?? '';
    _rulesController.text = parking['rules'] as String? ?? '';
  }

  @override
  void dispose() {
    _spacesController.dispose();
    _descriptionController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PublishFlowScaffold(
      currentStep: 1,
      stepTitle: 'Details',
      showBackAction: true,
      onContinue: _saving ? () {} : _submit,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PublishFieldLabel('PARKING TYPE *'),
            const SizedBox(height: 9),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _TypeCard(
                      icon: Icons.location_city_rounded,
                      title: 'Public',
                      subtitle: 'Any user can book',
                      selected: _parkingType == 'public',
                      onTap: () => setState(() => _parkingType = 'public'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TypeCard(
                      icon: Icons.lock_rounded,
                      title: 'Private',
                      subtitle: 'Only approved users',
                      selected: _parkingType == 'private',
                      onTap: () => setState(() => _parkingType = 'private'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const PublishFieldLabel('NUMBER OF SPACES *'),
            const SizedBox(height: 8),
            _NumericField(controller: _spacesController, suffix: 'spaces'),
            const SizedBox(height: 7),
            const PublishHintText(
              'Enter any number: 1, 2, 10, 50, 100... You can configure sections and labels from the dashboard.',
            ),
            const SizedBox(height: 18),
            const PublishFieldLabel('LEVELS / FLOORS'),
            const SizedBox(height: 9),
            _LevelSelector(
              floors: _floors,
              onChanged: (value) => setState(() => _floors = value),
            ),
            const SizedBox(height: 18),
            const PublishFieldLabel('SCHEDULE'),
            const SizedBox(height: 9),
            Row(
              children: [
                Expanded(
                  child: _ScheduleButton(
                    icon: Icons.schedule_rounded,
                    label: '24/7',
                    selected: _open24Hours,
                    onTap: () => setState(() => _open24Hours = true),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _ScheduleButton(
                    icon: Icons.alarm_rounded,
                    label: 'Specific schedule',
                    selected: !_open24Hours,
                    onTap: () => setState(() => _open24Hours = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const PublishFieldLabel('DESCRIPTION'),
            const SizedBox(height: 9),
            _TextAreaField(
              controller: _descriptionController,
              hint:
                  'Describe your parking: materials, security, how to find it...',
            ),
            const SizedBox(height: 18),
            const PublishFieldLabel('PARKING RULES'),
            const SizedBox(height: 9),
            _TextAreaField(
              controller: _rulesController,
              hint: 'Example: No trucks allowed. Please respect speed signs...',
            ),
            if (_saving) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final totalSpaces = int.tryParse(_spacesController.text.trim()) ?? 0;
    if (totalSpaces <= 0) {
      _showError('Enter a valid number of spaces.');
      return;
    }

    setState(() => _saving = true);
    try {
      await HostPublishFlowService.instance.saveDetails({
        'parkingType': _parkingType,
        'totalSpaces': totalSpaces,
        'floors': _floors,
        'scheduleMode': _open24Hours ? '24_7' : 'specific',
        'open24Hours': _open24Hours,
        'description': _descriptionController.text.trim(),
        'rules': _rulesController.text.trim(),
      });

      if (!mounted) return;
      Navigator.pushNamed(context, '/publish-parking-spaces');
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 116),
        padding: const EdgeInsets.fromLTRB(10, 13, 10, 12),
        decoration: BoxDecoration(
          color: selected ? PublishFlowColors.greenSoft : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? PublishFlowColors.green
                : PublishFlowColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? PublishFlowColors.green
                  : PublishFlowColors.muted,
              size: 27,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: PublishFlowColors.ink,
                fontSize: 13,
                height: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: PublishFlowColors.hint,
                fontSize: 10,
                height: 1.15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumericField extends StatelessWidget {
  const _NumericField({required this.controller, required this.suffix});

  final TextEditingController controller;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 8),
            child: Icon(
              Icons.local_parking_rounded,
              color: PublishFlowColors.blue,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0),
          suffixText: suffix,
          suffixStyle: const TextStyle(
            color: PublishFlowColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
          enabledBorder: _localBorder(PublishFlowColors.border),
          focusedBorder: _localBorder(PublishFlowColors.blue),
        ),
      ),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  const _LevelSelector({required this.floors, required this.onChanged});

  final int floors;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PublishFlowColors.border),
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.remove_rounded,
            filled: true,
            onTap: () => onChanged(floors > 1 ? floors - 1 : 1),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              '$floors level${floors == 1 ? '' : 's'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PublishFlowColors.blue,
                fontSize: 21,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Spacer(),
          _CircleButton(
            icon: Icons.add_rounded,
            filled: false,
            onTap: () => onChanged(floors + 1),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFFEAF0F8) : Colors.white,
          shape: BoxShape.circle,
          border: filled
              ? null
              : Border.all(color: PublishFlowColors.blue, width: 1.3),
        ),
        child: Icon(
          icon,
          color: filled ? PublishFlowColors.ink : PublishFlowColors.blue,
          size: 21,
        ),
      ),
    );
  }
}

class _ScheduleButton extends StatelessWidget {
  const _ScheduleButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF7FBFF) : Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected ? PublishFlowColors.blue : PublishFlowColors.border,
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? PublishFlowColors.blue : Colors.pinkAccent,
              size: 15,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: PublishFlowColors.blue,
                  fontSize: 12,
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

class _TextAreaField extends StatelessWidget {
  const _TextAreaField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
          enabledBorder: _localBorder(PublishFlowColors.border),
          focusedBorder: _localBorder(PublishFlowColors.blue),
        ),
      ),
    );
  }
}

OutlineInputBorder _localBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
}
