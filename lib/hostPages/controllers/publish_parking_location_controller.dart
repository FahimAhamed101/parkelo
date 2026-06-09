import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../services/host_publish_flow_service.dart';

class PublishParkingLocationController extends GetxController {
  static const LatLng defaultLocation = LatLng(18.4734, -69.8849);

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final instagramController = TextEditingController();
  final mapController = MapController();

  final sectors = const <String>[
    'Zona Colonial',
    'Piantini',
    'Naco',
    'Gazcue',
    'Bella Vista',
  ];

  final sector = 'Zona Colonial'.obs;
  final selectedLocation = Rxn<LatLng>();
  final isLocating = false.obs;
  final isSaving = false.obs;
  final locationMessage = 'Tap the map or use GPS to place the pin'.obs;
  final mapZoom = 15.0.obs;

  LatLng get mapCenter => selectedLocation.value ?? defaultLocation;

  @override
  void onInit() {
    super.onInit();
    _loadDraft();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    instagramController.dispose();
    super.onClose();
  }

  void _loadDraft() {
    final parking = HostPublishFlowService.instance.parking ?? const {};
    nameController.text = parking['name'] as String? ?? '';
    addressController.text =
        (parking['address'] as Map<String, dynamic>?)?['line1'] as String? ??
        '';
    phoneController.text =
        (parking['host'] as Map<String, dynamic>?)?['contactPhone']
            as String? ??
        '';
    instagramController.text =
        (parking['host'] as Map<String, dynamic>?)?['instagram'] as String? ??
        '';
    sector.value = parking['sector'] as String? ?? sector.value;

    final coordinates = parking['coordinates'] as Map<String, dynamic>?;
    final latitude = (coordinates?['latitude'] as num?)?.toDouble();
    final longitude = (coordinates?['longitude'] as num?)?.toDouble();
    if (latitude != null && longitude != null) {
      selectedLocation.value = LatLng(latitude, longitude);
      locationMessage.value = 'Pin placed from saved draft';
    }
  }

  void setSector(String value) {
    sector.value = value;
  }

  void placePin(LatLng point) {
    selectedLocation.value = point;
    locationMessage.value =
        'Pin placed at ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
  }

  Future<void> useCurrentLocation() async {
    if (isLocating.value) return;

    isLocating.value = true;
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        throw const LocationException('Turn on location services first.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw const LocationException('Location permission was denied.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationException(
          'Location permission is permanently denied. Enable it in settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      final point = LatLng(position.latitude, position.longitude);
      placePin(point);
      mapController.move(point, 16);
    } on LocationException catch (error) {
      Get.snackbar('Location', error.message, snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar(
        'Location',
        'Could not read your current location.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> submit() async {
    if (isSaving.value) return;

    final name = nameController.text.trim();
    final address = addressController.text.trim();
    final point = selectedLocation.value;

    if (name.isEmpty || address.isEmpty) {
      Get.snackbar(
        'Publish parking',
        'Name and address are required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (point == null) {
      Get.snackbar(
        'Publish parking',
        'Place the parking pin on the map before continuing.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSaving.value = true;
    try {
      await HostPublishFlowService.instance.createOrUpdateLocation({
        'name': name,
        'zone': sector.value,
        'sector': sector.value,
        'addressLine': address,
        'city': 'Santo Domingo',
        'state': 'Distrito Nacional',
        'country': 'Dominican Republic',
        'contactPhone': phoneController.text.trim(),
        'instagram': instagramController.text.trim(),
        'latitude': point.latitude,
        'longitude': point.longitude,
        'location': {
          'latitude': point.latitude,
          'longitude': point.longitude,
        },
      });

      Get.toNamed('/publish-parking-details');
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

class LocationException implements Exception {
  const LocationException(this.message);

  final String message;
}
