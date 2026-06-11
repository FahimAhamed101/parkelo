import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/publish_parking_services_controller.dart';
import '../widgets/publish_parking_flow.dart';

class PublishParkingServicesPage extends StatelessWidget {
  const PublishParkingServicesPage({super.key});

  static const _serviceOptions = <_ServiceOption>[
    _ServiceOption(Icons.house_rounded, 'Covered', 'covered'),
    _ServiceOption(Icons.videocam_rounded, 'Cameras', 'cameras'),
    _ServiceOption(Icons.schedule_rounded, '24/7', 'open_24_7'),
    _ServiceOption(Icons.lock_rounded, 'Access control', 'controlled_access'),
    _ServiceOption(Icons.person_rounded, 'Personnel', 'staff'),
    _ServiceOption(Icons.bolt_rounded, 'EV charging', 'ev_charging'),
    _ServiceOption(Icons.emoji_people_rounded, 'Valet', 'valet'),
    _ServiceOption(Icons.home_work_rounded, 'Private', 'private'),
    _ServiceOption(Icons.wifi_rounded, 'Wi-Fi', 'wifi'),
    _ServiceOption(
      Icons.accessible_forward_rounded,
      'Accessible spaces',
      'accessible',
    ),
    _ServiceOption(Icons.two_wheeler_rounded, 'Motorcycles', 'motorcycles'),
    _ServiceOption(Icons.wc_rounded, 'Restrooms', 'bathrooms'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PublishParkingServicesController());

    return Obx(
      () => PublishFlowScaffold(
        currentStep: 3,
        stepTitle: 'Services',
        showBackAction: true,
        onContinue: controller.isSaving.value ? () {} : controller.submit,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(9, 20, 9, 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE2EAF5)),
              boxShadow: [
                BoxShadow(
                  color: PublishFlowColors.blue.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'What services does your parking offer?',
                  style: TextStyle(
                    color: PublishFlowColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  'Select all that apply. You can edit them later.',
                  style: TextStyle(
                    color: PublishFlowColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 19),
                for (var i = 0; i < _serviceOptions.length; i++) ...[
                  _ServiceRow(
                    option: _serviceOptions[i],
                    value: controller.isSelected(_serviceOptions[i].key),
                    onChanged: (value) {
                      controller.setSelected(_serviceOptions[i].key, value);
                    },
                  ),
                  if (i != _serviceOptions.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFDDE6F1),
                      indent: 52,
                    ),
                ],
                if (controller.isSaving.value) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.option,
    required this.value,
    required this.onChanged,
  });

  final _ServiceOption option;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0F8),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0xFFDDE6F1)),
            ),
            child: Icon(option.icon, color: _iconColor(option.icon), size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: PublishFlowColors.muted,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            activeTrackColor: PublishFlowColors.green,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Color _iconColor(IconData icon) {
    if (icon == Icons.bolt_rounded) return const Color(0xFFFF7A1A);
    if (icon == Icons.lock_rounded) return const Color(0xFFF59E0B);
    if (icon == Icons.person_rounded) return const Color(0xFF4C1D95);
    if (icon == Icons.wifi_rounded ||
        icon == Icons.accessible_forward_rounded) {
      return PublishFlowColors.blue;
    }
    return PublishFlowColors.muted;
  }
}

class _ServiceOption {
  const _ServiceOption(this.icon, this.label, this.key);

  final IconData icon;
  final String label;
  final String key;
}
