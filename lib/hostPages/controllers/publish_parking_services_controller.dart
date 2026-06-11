import 'package:get/get.dart';

import '../services/host_publish_flow_service.dart';

class PublishParkingServicesController extends GetxController {
  static const serviceKeys = <String>[
    'covered',
    'cameras',
    'open_24_7',
    'controlled_access',
    'staff',
    'ev_charging',
    'valet',
    'private',
    'wifi',
    'accessible',
    'motorcycles',
    'bathrooms',
  ];

  final selected = <String, bool>{}.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDraft();
  }

  void _loadDraft() {
    final services =
        (HostPublishFlowService.instance.parking?['services']
                    as List<dynamic>? ??
                const [])
            .map((item) => item is Map<String, dynamic> ? item['code'] : item)
            .whereType<String>()
            .toSet();

    selected.assignAll({
      for (final key in serviceKeys) key: services.contains(key),
    });
  }

  bool isSelected(String key) {
    return selected[key] ?? false;
  }

  void setSelected(String key, bool value) {
    selected[key] = value;
  }

  Future<void> submit() async {
    if (isSaving.value) return;

    if (!HostPublishFlowService.instance.hasDraft) {
      Get.snackbar(
        'Publish parking',
        'Complete the previous steps before saving services.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed('/publish-parking');
      return;
    }

    if (!selected.values.any((enabled) => enabled)) {
      Get.snackbar(
        'Publish parking',
        'Select at least one available service.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSaving.value = true;
    try {
      await HostPublishFlowService.instance.saveServices({
        'services': Map<String, bool>.from(selected),
      });

      Get.offNamed('/publish-parking-photos');
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
