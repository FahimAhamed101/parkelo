import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/publish_parking_spaces_controller.dart';
import '../widgets/publish_parking_flow.dart';

class PublishParkingSpacesPage extends StatelessWidget {
  const PublishParkingSpacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PublishParkingSpacesController());

    return Obx(
      () => PublishFlowScaffold(
        currentStep: 2,
        stepTitle: 'Spaces',
        showBackAction: true,
        onContinue: controller.isSaving.value ? () {} : controller.submit,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 30, 18, 24),
          child: Column(
            children: [
              _SpacesPreviewCard(
                totalSpaces: controller.totalSpaces.value,
                floors: controller.floors.value,
              ),
              if (controller.isSaving.value) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SpacesPreviewCard extends StatelessWidget {
  const _SpacesPreviewCard({required this.totalSpaces, required this.floors});

  final int totalSpaces;
  final int floors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 33, 17, 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE2EAF5)),
        boxShadow: [
          BoxShadow(
            color: PublishFlowColors.blue.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          const ParkingPSquare(size: 40),
          const SizedBox(height: 18),
          Text(
            '$totalSpaces spaces - $floors level${floors == 1 ? '' : 's'}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PublishFlowColors.ink,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Preview of your parking map',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PublishFlowColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 19),
          _SpacesGrid(totalSpaces: totalSpaces),
          const SizedBox(height: 14),
          const _IdentifierNote(),
        ],
      ),
    );
  }
}

class _SpacesGrid extends StatelessWidget {
  const _SpacesGrid({required this.totalSpaces});

  final int totalSpaces;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = totalSpaces <= 8 ? 4 : 5;
    return GridView.builder(
      itemCount: totalSpaces,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 7,
        crossAxisSpacing: 7,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: PublishFlowColors.greenSoft,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF9DDFC0)),
          ),
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: PublishFlowColors.green,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        );
      },
    );
  }
}

class _IdentifierNote extends StatelessWidget {
  const _IdentifierNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: PublishFlowColors.blueSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: Color(0xFFF59E0B),
            size: 16,
          ),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'You can customize identifiers (A1, VIP, T1...) and sections from the admin panel.',
              style: TextStyle(
                color: PublishFlowColors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                height: 1.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
