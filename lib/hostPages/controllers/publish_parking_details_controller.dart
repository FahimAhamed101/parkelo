import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/host_publish_flow_service.dart';

class PublishParkingDetailsController extends GetxController {
  final spacesController = TextEditingController(text: '10');
  final descriptionController = TextEditingController();
  final rulesController = TextEditingController();

  final parkingType = 'public'.obs;
  final approvalMode = 'automatic'.obs;
  final floors = 1.obs;
  final open24Hours = true.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDraft();
  }

  void _loadDraft() {
    final parking = HostPublishFlowService.instance.parking ?? const {};
    final availability = parking['spaces'] as Map<String, dynamic>? ?? const {};
    final services = (parking['services'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>();

    parkingType.value =
        (parking['parkingType'] as String? ?? 'public') == 'private'
        ? 'private'
        : 'public';
    approvalMode.value =
        (parking['approvalMode'] as String? ?? 'automatic') == 'host_approval'
        ? 'host_approval'
        : 'automatic';
    spacesController.text = ((availability['total'] as num?)?.toInt() ?? 10)
        .toString();
    floors.value = ((availability['floors'] as num?)?.toInt() ?? 1).clamp(
      1,
      30,
    );
    open24Hours.value = services.any(
      (service) => service['code'] == 'open_24_7',
    );
    descriptionController.text = parking['description'] as String? ?? '';
    rulesController.text = parking['rules'] as String? ?? '';
  }

  void setParkingType(String value) {
    parkingType.value = value == 'private' ? 'private' : 'public';
  }

  void setApprovalMode(String value) {
    approvalMode.value = value == 'host_approval'
        ? 'host_approval'
        : 'automatic';
  }

  void setOpen24Hours(bool value) {
    open24Hours.value = value;
  }

  void changeFloors(int value) {
    floors.value = value.clamp(1, 30);
  }

  Future<void> submit() async {
    if (isSaving.value) return;

    final totalSpaces = int.tryParse(spacesController.text.trim()) ?? 0;
    if (totalSpaces <= 0) {
      Get.snackbar(
        'Publish parking',
        'Enter a valid number of spaces.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!HostPublishFlowService.instance.hasDraft) {
      Get.snackbar(
        'Publish parking',
        'Complete the Location step before saving details.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed('/publish-parking');
      return;
    }

    isSaving.value = true;
    try {
      await HostPublishFlowService.instance.saveDetails({
        'parkingType': parkingType.value,
        'accessType': parkingType.value,
        'approvalMode': approvalMode.value,
        'reservationMode': approvalMode.value,
        'totalSpaces': totalSpaces,
        'spacesCount': totalSpaces,
        'floors': floors.value,
        'levels': floors.value,
        'scheduleMode': open24Hours.value ? '24_7' : 'specific',
        'open24Hours': open24Hours.value,
        'description': descriptionController.text.trim(),
        'rules': rulesController.text.trim(),
        'parkingRules': rulesController.text.trim(),
      });

      Get.offNamed('/publish-parking-spaces');
    } catch (error) {
      Get.snackbar(
        'Publish parking',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
