import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/publish_parking_location_controller.dart';
import '../widgets/publish_parking_flow.dart';

class PublishParkingPage extends StatelessWidget {
  const PublishParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PublishParkingLocationController(),
      permanent: true,
    );

    return Obx(
      () => PublishFlowScaffold(
        currentStep: 0,
        stepTitle: 'Location',
        onContinue: controller.isSaving.value ? () {} : controller.submit,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PublishFieldLabel('PARKING NAME OR HOST *'),
              const SizedBox(height: 8),
              _InputField(
                controller: controller.nameController,
                hint: "Example: Central Parking or Juan's House",
              ),
              const SizedBox(height: 6),
              const PublishHintText(
                'This can be your business name or simply your name if it is a residential parking.',
              ),
              const SizedBox(height: 18),
              const PublishFieldLabel('LOCATION *'),
              const SizedBox(height: 8),
              _UseLocationCard(controller: controller),
              const SizedBox(height: 12),
              _InteractiveMap(controller: controller),
              const SizedBox(height: 8),
              Text(
                controller.locationMessage.value,
                style: GoogleFonts.nunito(
                  color: PublishFlowColors.hint,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 18),
              const PublishFieldLabel('EXACT ADDRESS *'),
              const SizedBox(height: 8),
              _InputField(
                controller: controller.addressController,
                hint: 'Street, number, building...',
              ),
              const SizedBox(height: 6),
              const PublishHintText(
                'Add references so users can find you easily',
              ),
              const SizedBox(height: 18),
              const PublishFieldLabel('SECTOR / ZONE *'),
              const SizedBox(height: 8),
              _SectorField(controller: controller),
              const SizedBox(height: 18),
              const PublishFieldLabel('CONTACT PHONE NUMBER'),
              const SizedBox(height: 8),
              _InputField(
                controller: controller.phoneController,
                hint: '+1 (809) 000-0000',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 18),
              const PublishFieldLabel('INSTAGRAM (optional)'),
              const SizedBox(height: 8),
              _InputField(
                controller: controller.instagramController,
                hint: '@myparking',
              ),
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
        style: GoogleFonts.nunito(
          color: PublishFlowColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(
            color: PublishFlowColors.hint,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
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

class _UseLocationCard extends StatelessWidget {
  const _UseLocationCard({required this.controller});

  final PublishParkingLocationController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: controller.useCurrentLocation,
        child: Container(
          constraints: const BoxConstraints(minHeight: 63),
          padding: const EdgeInsets.fromLTRB(17, 12, 14, 12),
          decoration: BoxDecoration(
            color: PublishFlowColors.blueSoft,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PublishFlowColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 19.5,
                backgroundColor: PublishFlowColors.blue,
                child: controller.isLocating.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.my_location_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
              ),
              const SizedBox(width: 13),
              const Expanded(
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
        ),
      ),
    );
  }
}

class _InteractiveMap extends StatelessWidget {
  const _InteractiveMap({required this.controller});

  final PublishParkingLocationController controller;

  @override
  Widget build(BuildContext context) {
    final pin = controller.selectedLocation.value;

    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: SizedBox(
        height: 132,
        child: FlutterMap(
          mapController: controller.mapController,
          options: MapOptions(
            initialCenter: controller.mapCenter,
            initialZoom: controller.mapZoom.value,
            minZoom: 5,
            maxZoom: 19,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            onTap: (_, point) =>
                controller.placePin(point, resolveAddress: true),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.parkealo',
            ),
            if (pin != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: pin,
                    width: 42,
                    height: 42,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFFF2D8B),
                      size: 38,
                    ),
                  ),
                ],
              )
            else
              MarkerLayer(
                markers: [
                  Marker(
                    point: PublishParkingLocationController.defaultLocation,
                    width: 148,
                    height: 38,
                    child: _TapToPlaceHint(),
                  ),
                ],
              ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TapToPlaceHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: PublishFlowColors.blue.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: Color(0xFFFF2D8B),
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            'Tap to place pin',
            style: GoogleFonts.nunito(
              color: PublishFlowColors.blue,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectorField extends StatelessWidget {
  const _SectorField({required this.controller});

  final PublishParkingLocationController controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _pickSector(context),
      child: IgnorePointer(
        child: PublishSelectBox(
          hint: 'Select a sector...',
          value: controller.sector.value,
        ),
      ),
    );
  }

  Future<void> _pickSector(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final sector in controller.sectors)
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
      controller.setSector(selected);
    }
  }
}

OutlineInputBorder _inputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
}
