import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/publish_parking_photos_controller.dart';
import '../widgets/publish_parking_flow.dart';

class PublishParkingPhotosPage extends StatelessWidget {
  const PublishParkingPhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PublishParkingPhotosController());

    return Obx(
      () => PublishFlowScaffold(
        currentStep: 4,
        stepTitle: 'Photos',
        showBackAction: true,
        onContinue: controller.isSaving.value ? () {} : controller.submit,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(21, 21, 21, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PublishFieldLabel('PARKING PHOTOS'),
              const SizedBox(height: 10),
              GridView.builder(
                itemCount: controller.photos.length,
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
                    path: controller.photos[index],
                    isCover: index == 0,
                    onTap: () => controller.pickPhoto(index),
                  );
                },
              ),
              const SizedBox(height: 27),
              _TipsPanel(),
              if (controller.isSaving.value) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
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
              ? DecorationImage(image: _imageProvider(path), fit: BoxFit.cover)
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

  ImageProvider _imageProvider(String value) {
    final uri = Uri.tryParse(value);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return NetworkImage(value);
    }

    return FileImage(File(value));
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
