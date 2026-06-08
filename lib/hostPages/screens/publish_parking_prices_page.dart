import 'package:flutter/material.dart';

import '../services/host_publish_flow_service.dart';
import '../widgets/publish_parking_flow.dart';
import 'publish_parking_review_page.dart';

class PublishParkingPricesPage extends StatefulWidget {
  const PublishParkingPricesPage({super.key});

  @override
  State<PublishParkingPricesPage> createState() =>
      _PublishParkingPricesPageState();
}

class _PublishParkingPricesPageState extends State<PublishParkingPricesPage> {
  final _hourController = TextEditingController();
  final _dayController = TextEditingController();
  final _weekController = TextEditingController();

  bool _dynamicPricing = true;
  double _multiplier = 1.5;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _hourController.dispose();
    _dayController.dispose();
    _weekController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PublishFlowScaffold(
      currentStep: 5,
      stepTitle: 'Prices',
      showBackAction: true,
      continueLabel: 'Save prices',
      continueColor: PublishFlowColors.green,
      onContinue: _saving ? () {} : _submit,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 17, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _CardTitle('Pricing mode'),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(child: _ModeButton(label: 'Global (all same)')),
                      SizedBox(width: 9),
                      Expanded(
                        child: _ModeButton(label: 'By section', selected: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(height: 1, color: Color(0xFFDDE6F1)),
                  const SizedBox(height: 15),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Dynamic pricing',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: const Text(
                      'Automatically increases when occupancy exceeds 80%.',
                    ),
                    value: _dynamicPricing,
                    activeTrackColor: PublishFlowColors.green,
                    onChanged: (value) =>
                        setState(() => _dynamicPricing = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _CardTitle('Section pricing'),
                  const SizedBox(height: 14),
                  _PriceInput(label: 'Per hour', controller: _hourController),
                  const SizedBox(height: 10),
                  _PriceInput(label: 'Per day', controller: _dayController),
                  const SizedBox(height: 10),
                  _PriceInput(label: 'Per week', controller: _weekController),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _CardTitle('Overtime'),
                  const SizedBox(height: 17),
                  const Text(
                    'Additional charge when the user exceeds the reserved time.',
                    style: TextStyle(
                      color: PublishFlowColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      for (final value in const [1.0, 1.5, 2.0, 2.5])
                        ChoiceChip(
                          label: Text('${value.toStringAsFixed(1)}x'),
                          selected: _multiplier == value,
                          onSelected: (_) =>
                              setState(() => _multiplier = value),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (_loading || _saving) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _load() async {
    try {
      final response = await HostPublishFlowService.instance.fetchPricing();
      final pricing = response['pricing'] as Map<String, dynamic>? ?? const {};
      final global = pricing['global'] as Map<String, dynamic>? ?? const {};
      final overtime = pricing['overtime'] as Map<String, dynamic>? ?? const {};
      if (!mounted) return;
      setState(() {
        _hourController.text = '${global['hourly'] ?? 150}';
        _dayController.text = '${global['daily'] ?? 800}';
        _weekController.text = '${global['weekly'] ?? 4500}';
        _dynamicPricing =
            (pricing['dynamicPricing'] as Map<String, dynamic>?)?['enabled']
                as bool? ??
            true;
        _multiplier = (overtime['multiplier'] as num?)?.toDouble() ?? 1.5;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      final hourly = int.tryParse(_hourController.text.trim()) ?? 150;
      final daily = int.tryParse(_dayController.text.trim()) ?? 800;
      final weekly = int.tryParse(_weekController.text.trim()) ?? 4500;
      final parking = HostPublishFlowService.instance.parking ?? const {};
      final spaces = parking['spaces'] as Map<String, dynamic>? ?? const {};
      final floors = (spaces['floors'] as num?)?.toInt() ?? 1;
      final total = (spaces['total'] as num?)?.toInt() ?? 10;
      final midpoint = (total / floors).ceil();

      await HostPublishFlowService.instance.savePricing({
        'pricingMode': 'per_section',
        'dynamicPricing': {
          'enabled': _dynamicPricing,
          'occupancyThresholdPercent': 80,
          'peakIncreasePercent': 20,
        },
        'sections': [
          {
            'code': 'A',
            'name': 'Ground Floor',
            'enabled': true,
            'rate': {'hourly': hourly, 'daily': daily, 'weekly': weekly},
            'spaces': List<String>.generate(
              midpoint,
              (index) => '${index + 1}',
            ),
          },
          {
            'code': 'B',
            'name': 'Level 1',
            'enabled': floors > 1,
            'rate': {'hourly': hourly, 'daily': daily, 'weekly': weekly},
            'spaces': List<String>.generate(
              total - midpoint,
              (index) => '${midpoint + index + 1}',
            ),
          },
        ],
        'overtime': {'multiplier': _multiplier, 'graceMinutes': 0},
      });

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PublishParkingReviewPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixText: 'RD\$ ',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      padding: const EdgeInsets.fromLTRB(15, 17, 15, 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE2EAF5)),
        boxShadow: [
          BoxShadow(
            color: PublishFlowColors.blue.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: PublishFlowColors.ink,
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: selected ? PublishFlowColors.blue : PublishFlowColors.border,
          width: selected ? 1.7 : 1.2,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? PublishFlowColors.blue : PublishFlowColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
