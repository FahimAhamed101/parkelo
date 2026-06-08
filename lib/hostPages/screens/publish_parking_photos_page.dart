import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/host_publish_flow_service.dart';
import '../widgets/publish_parking_flow.dart';

class PublishParkingPhotosPage extends StatefulWidget {
  const PublishParkingPhotosPage({super.key});

  @override
  State<PublishParkingPhotosPage> createState() =>
      _PublishParkingPhotosPageState();
}

class _PublishParkingPhotosPageState extends State<PublishParkingPhotosPage> {
  final _picker = ImagePicker();
  late List<String> _photos;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final parking = HostPublishFlowService.instance.parking ?? const {};
    final media = parking['media'] as Map<String, dynamic>? ?? const {};
    final gallery = (media['gallery'] as List<dynamic>? ?? const [])
        .cast<String>();
    _photos = List<String>.from(gallery.take(4));
    while (_photos.length < 4) {
      _photos.add('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PublishFlowScaffold(
      currentStep: 4,
      stepTitle: 'Photos',
      showBackAction: true,
      onContinue: _saving ? () {} : _submit,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(21, 21, 21, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PublishFieldLabel('PARKING PHOTOS'),
            const SizedBox(height: 10),
            GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                return _PhotoSlot(
                  path: _photos[index],
                  isCover: index == 0,
                  onTap: () => _pickPhoto(index),
                );
              },
            ),
            const SizedBox(height: 27),
            _TipsPanel(),
            if (_saving) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto(int index) async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      _photos[index] = file.path;
    });
  }

  Future<void> _submit() async {
    final selectedPhotos = _photos.where((path) => path.isNotEmpty).toList();
    if (selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one photo before continuing.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await HostPublishFlowService.instance.savePhotos({
        'photos': selectedPhotos,
        'mainPhoto': selectedPhotos.first,
      });

      if (!mounted) return;
      Navigator.pushNamed(context, '/publish-parking-prices');
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.path,
    required this.isCover,
    required this.onTap,
  });

  final String path;
  final bool isCover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = path.isNotEmpty;
    final child = InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isCover ? const Color(0xFFF8FBFF) : const Color(0xFFEFF3F8),
          borderRadius: BorderRadius.circular(12),
          border: isCover ? null : Border.all(color: const Color(0xFFDCE5F0)),
          image: hasImage
              ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover)
              : null,
        ),
        child: Stack(
          children: [
            if (!hasImage)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      color: isCover
                          ? PublishFlowColors.blue
                          : PublishFlowColors.hint,
                      size: 26,
                    ),
                    const SizedBox(height: 9),
                    Text(
                      isCover ? 'Main photo' : 'Add photo',
                      style: TextStyle(
                        color: isCover
                            ? PublishFlowColors.blue
                            : PublishFlowColors.hint,
                        fontSize: 11,
                        fontWeight: isCover ? FontWeight.w900 : FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            if (isCover)
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: PublishFlowColors.blue,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'COVER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (!isCover) return child;

    return CustomPaint(
      painter: const DashedBorderPainter(
        color: PublishFlowColors.blue,
        radius: 12,
      ),
      child: child,
    );
  }
}

class _TipsPanel extends StatelessWidget {
  const _TipsPanel();

  static const tips = [
    'Take photos in natural daylight',
    'Show the entrance and the spaces',
    'Include visible signage',
    'At least 3 photos improve conversions by 60%',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips for better photos:',
            style: TextStyle(
              color: PublishFlowColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final tip in tips) _TipRow(text: tip),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 7),
            decoration: const BoxDecoration(
              color: PublishFlowColors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: PublishFlowColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
