import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../services/host_publish_flow_service.dart';

class PublishParkingLocationController extends GetxController {
  static const LatLng defaultLocation = LatLng(18.4734, -69.8849);

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final instagramController = TextEditingController();
  final mapController = MapController();

  String city = 'Santo Domingo';
  String state = 'Distrito Nacional';
  String country = 'Dominican Republic';

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

  void _loadDraft() {
    final parking = HostPublishFlowService.instance.parking ?? const {};
    final address = parking['address'] as Map<String, dynamic>? ?? const {};
    nameController.text = parking['name'] as String? ?? '';
    addressController.text = address['line1'] as String? ?? '';
    city = address['city'] as String? ?? city;
    state = address['state'] as String? ?? state;
    country = address['country'] as String? ?? country;
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

  Future<void> placePin(
    LatLng point, {
    bool resolveAddress = false,
    bool moveMap = false,
  }) async {
    selectedLocation.value = point;
    locationMessage.value =
        'Pin placed at ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';

    if (moveMap) {
      mapController.move(point, 16);
    }

    if (resolveAddress) {
      await _fillAddressFromPoint(point);
    }
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

      locationMessage.value = 'Reading your device location...';
      final position = await _getCurrentGpsPosition();
      var point = LatLng(position.latitude, position.longitude);

      final usedNetworkFallback = _isAndroidEmulatorDefault(position);
      if (usedNetworkFallback) {
        locationMessage.value =
            'Ignoring emulator default location. Trying network location...';
        point =
            await _getApproximateNetworkLocation() ??
            (throw const LocationException(
              'Your emulator is reporting the default Googleplex location. Set a location in the emulator, or test on a real phone.',
            ));
      }

      await placePin(point, resolveAddress: true, moveMap: true);

      if (usedNetworkFallback) {
        Get.snackbar(
          'Location',
          'Using approximate network location because the emulator reported its default location.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (position.accuracy > 100) {
        Get.snackbar(
          'Location',
          'Location detected, but GPS accuracy is about ${position.accuracy.round()}m.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on LocationException catch (error) {
      Get.snackbar(
        'Location',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
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

  Future<Position> _getCurrentGpsPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (_) {
      return Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    }
  }

  bool _isAndroidEmulatorDefault(Position position) {
    final latDiff = (position.latitude - 37.4219999).abs();
    final lngDiff = (position.longitude + 122.0840575).abs();
    return latDiff < 0.01 && lngDiff < 0.01;
  }

  Future<LatLng?> _getApproximateNetworkLocation() async {
    try {
      final response = await http
          .get(Uri.parse('https://ipapi.co/json/'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode >= 400) return null;

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;

      final latitude = _toDouble(decoded['latitude'] ?? decoded['lat']);
      final longitude = _toDouble(decoded['longitude'] ?? decoded['lon']);
      if (latitude == null || longitude == null) return null;

      return LatLng(latitude, longitude);
    } catch (_) {
      return null;
    }
  }

  double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Future<void> _fillAddressFromPoint(LatLng point) async {
    locationMessage.value = 'Detecting address from map location...';

    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (placemarks.isEmpty) {
        locationMessage.value =
            'Pin placed at ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
        return;
      }

      final place = placemarks.first;
      final address = _formatAddress(place);
      if (address.isNotEmpty) {
        addressController.text = address;
      }

      city = _firstNotEmpty([
        place.locality,
        place.subAdministrativeArea,
        city,
      ]);
      state = _firstNotEmpty([place.administrativeArea, state]);
      country = _firstNotEmpty([place.country, country]);

      final detectedSector = _matchSector(place);
      if (detectedSector != null) {
        sector.value = detectedSector;
      }

      locationMessage.value =
          'Location detected at ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
    } catch (_) {
      locationMessage.value =
          'Pin placed at ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}. Address not detected automatically.';
    }
  }

  String _formatAddress(geocoding.Placemark place) {
    final street = _firstNotEmpty([place.street, place.name]);
    final area = _firstNotEmpty([place.subLocality, place.locality]);
    final province = _firstNotEmpty([
      place.subAdministrativeArea,
      place.administrativeArea,
    ]);

    return [
      street,
      area,
      province,
    ].where((part) => part.trim().isNotEmpty).join(', ');
  }

  String? _matchSector(geocoding.Placemark place) {
    final haystack = [
      place.name,
      place.street,
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
    ].whereType<String>().join(' ').toLowerCase();

    final aliases = <String, String>{
      'ciudad colonial': 'Zona Colonial',
      'colonial': 'Zona Colonial',
      'zona colonial': 'Zona Colonial',
    };

    for (final entry in aliases.entries) {
      if (haystack.contains(entry.key)) return entry.value;
    }

    for (final value in sectors) {
      if (haystack.contains(value.toLowerCase())) return value;
    }

    return null;
  }

  String _firstNotEmpty(List<String?> values) {
    for (final value in values) {
      final cleaned = value?.trim();
      if (cleaned != null && cleaned.isNotEmpty) return cleaned;
    }

    return '';
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
        'city': city,
        'state': state,
        'country': country,
        'contactPhone': phoneController.text.trim(),
        'instagram': instagramController.text.trim(),
        'latitude': point.latitude,
        'longitude': point.longitude,
        'location': {'latitude': point.latitude, 'longitude': point.longitude},
      });

      Get.offNamed('/publish-parking-details');
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
