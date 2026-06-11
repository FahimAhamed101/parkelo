import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/host_publish_flow_service.dart';

class PublishParkingPhotosController extends GetxController {
  final _picker = ImagePicker();

  final photos = <String>[].obs;
  final uploadValues = <String, String>{}.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDraft();
  }

  void _loadDraft() {
    final parking = HostPublishFlowService.instance.parking ?? const {};
    final media = parking['media'] as Map<String, dynamic>? ?? const {};
    final gallery = (media['gallery'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .take(4)
        .toList();

    for (final url in gallery.where((url) => url.isNotEmpty)) {
      uploadValues[url] = url;
    }

    while (gallery.length < 4) {
      gallery.add('');
    }

    photos.assignAll(gallery);
  }

  Future<void> pickPhoto(int index) async {
    if (index < 0 || index >= photos.length) return;

    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
    );
    if (file == null) return;

    photos[index] = file.path;
    final bytes = await file.readAsBytes();
    uploadValues[file.path] =
        'data:${_mimeType(file)};base64,${base64Encode(bytes)}';
  }

  Future<void> submit() async {
    if (isSaving.value) return;

    if (!HostPublishFlowService.instance.hasDraft) {
      Get.snackbar(
        'Publish parking',
        'Complete the previous steps before saving photos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed('/publish-parking');
      return;
    }

    final selectedPhotos = photos.where((path) => path.isNotEmpty).toList();
    if (selectedPhotos.isEmpty) {
      Get.snackbar(
        'Publish parking',
        'Add at least one photo before continuing.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSaving.value = true;
    try {
      final uploadedPhotos = <String>[];
      for (final path in selectedPhotos) {
        uploadedPhotos.add(await _uploadValueFor(path));
      }
      await HostPublishFlowService.instance.savePhotos({
        'photos': uploadedPhotos,
        'gallery': uploadedPhotos,
        'mainPhoto': uploadedPhotos.first,
        'heroImageUrl': uploadedPhotos.first,
        'thumbnailUrl': uploadedPhotos.first,
      });

      Get.offNamed('/publish-parking-prices');
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

  String _mimeType(XFile file) {
    final lower = file.name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  Future<String> _uploadValueFor(String path) async {
    final existing = uploadValues[path];
    if (existing != null && existing.isNotEmpty) return existing;

    final uri = Uri.tryParse(path);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return path;
    }
    if (path.startsWith('data:image/')) return path;

    final file = XFile(path);
    final bytes = await file.readAsBytes();
    final value = 'data:${_mimeType(file)};base64,${base64Encode(bytes)}';
    uploadValues[path] = value;
    return value;
  }
}
