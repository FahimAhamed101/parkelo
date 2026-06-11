import 'package:get/get.dart';

import '../services/host_publish_flow_service.dart';

class PublishParkingSpacesController extends GetxController {
  final totalSpaces = 10.obs;
  final floors = 1.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDraft();
  }

  void _loadDraft() {
    final parking = HostPublishFlowService.instance.parking ?? const {};
    final spaces = parking['spaces'] as Map<String, dynamic>? ?? const {};

    totalSpaces.value = ((spaces['total'] as num?)?.toInt() ?? 10).clamp(
      1,
      120,
    );
    floors.value = ((spaces['floors'] as num?)?.toInt() ?? 1).clamp(1, 20);
  }

  List<String> get identifiers {
    return List<String>.generate(totalSpaces.value, (index) => '${index + 1}');
  }

  Future<void> submit() async {
    if (isSaving.value) return;

    if (!HostPublishFlowService.instance.hasDraft) {
      Get.snackbar(
        'Publish parking',
        'Complete the Location and Details steps before saving spaces.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed('/publish-parking');
      return;
    }

    isSaving.value = true;
    try {
      await HostPublishFlowService.instance.saveSpaces({
        'totalSpaces': totalSpaces.value,
        'spacesCount': totalSpaces.value,
        'floors': floors.value,
        'levels': floors.value,
        'identifiers': identifiers,
      });

      Get.offNamed('/publish-parking-services');
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
