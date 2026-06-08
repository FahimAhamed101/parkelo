import 'package:flutter/material.dart';

import '../services/host_publish_flow_service.dart';
import '../widgets/publish_parking_flow.dart';

class PublishParkingPage extends StatefulWidget {
  const PublishParkingPage({super.key});

  @override
  State<PublishParkingPage> createState() => _PublishParkingPageState();
}

class _PublishParkingPageState extends State<PublishParkingPage> {
  static const _sectors = <String>[
    'Zona Colonial',
    'Piantini',
    'Naco',
    'Gazcue',
    'Bella Vista',
  ];

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();
  String _sector = _sectors.first;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final parking = HostPublishFlowService.instance.parking ?? const {};
    _nameController.text = parking['name'] as String? ?? '';
    _addressController.text =
        (parking['address'] as Map<String, dynamic>?)?['line1'] as String? ??
        '';
    _phoneController.text =
        (parking['host'] as Map<String, dynamic>?)?['contactPhone']
            as String? ??
        '';
    _instagramController.text =
        (parking['host'] as Map<String, dynamic>?)?['instagram'] as String? ??
        '';
    _sector = parking['sector'] as String? ?? _sector;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PublishFlowScaffold(
      currentStep: 0,
      stepTitle: 'Location',
      onContinue: _saving ? () {} : _submit,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PublishFieldLabel('PARKING NAME OR HOST *'),
            const SizedBox(height: 8),
            _InputField(
              controller: _nameController,
              hint: "Example: Central Parking or Juan's House",
            ),
            const SizedBox(height: 6),
            const PublishHintText(
              'This can be your business name or simply your name if it is a residential parking.',
            ),
            const SizedBox(height: 18),
            const PublishFieldLabel('LOCATION *'),
            const SizedBox(height: 8),
            const _UseLocationCard(),
            const SizedBox(height: 12),
            const PublishMapPreview(),
            const SizedBox(height: 18),
            const PublishFieldLabel('EXACT ADDRESS *'),
            const SizedBox(height: 8),
            _InputField(
              controller: _addressController,
              hint: 'Street, number, building...',
            ),
            const SizedBox(height: 6),
            const PublishHintText(
              'Add references so users can find you easily',
            ),
            const SizedBox(height: 18),
            const PublishFieldLabel('SECTOR / ZONE *'),
            const SizedBox(height: 8),
            _SectorField(value: _sector, onTap: _pickSector),
            const SizedBox(height: 18),
            const PublishFieldLabel('CONTACT PHONE NUMBER'),
            const SizedBox(height: 8),
            _InputField(
              controller: _phoneController,
              hint: '+1 (809) 000-0000',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 18),
            const PublishFieldLabel('INSTAGRAM (optional)'),
            const SizedBox(height: 8),
            _InputField(controller: _instagramController, hint: '@myparking'),
            if (_saving) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickSector() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final sector in _sectors)
                ListTile(
                  title: Text(sector),
                  onTap: () => Navigator.pop(context, sector),
                ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => _sector = selected);
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      _showError('Name and address are required.');
      return;
    }

    setState(() => _saving = true);
    try {
      await HostPublishFlowService.instance.createOrUpdateLocation({
        'name': _nameController.text.trim(),
        'zone': _sector,
        'sector': _sector,
        'addressLine': _addressController.text.trim(),
        'contactPhone': _phoneController.text.trim(),
        'instagram': _instagramController.text.trim(),
        'latitude': 18.4734,
        'longitude': -69.8849,
      });

      if (!mounted) return;
      Navigator.pushNamed(context, '/publish-parking-details');
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          enabledBorder: _inputBorder(PublishFlowColors.border),
          focusedBorder: _inputBorder(PublishFlowColors.blue),
        ),
      ),
    );
  }
}

class _SectorField extends StatelessWidget {
  const _SectorField({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: IgnorePointer(
        child: PublishSelectBox(hint: 'Select a sector...', value: value),
      ),
    );
  }
}

class _UseLocationCard extends StatelessWidget {
  const _UseLocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 63),
      padding: const EdgeInsets.fromLTRB(17, 12, 14, 12),
      decoration: BoxDecoration(
        color: PublishFlowColors.blueSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PublishFlowColors.border),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 19.5,
            backgroundColor: PublishFlowColors.blue,
            child: Icon(
              Icons.my_location_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Use my current location',
                  style: TextStyle(
                    color: PublishFlowColors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Enable GPS for better accuracy',
                  style: TextStyle(
                    color: PublishFlowColors.muted,
                    fontSize: 11,
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

OutlineInputBorder _inputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
}
