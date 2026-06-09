import 'host_api_client.dart';

class HostPublishFlowService {
  HostPublishFlowService._();

  static final HostPublishFlowService instance = HostPublishFlowService._();

  String? parkingId;
  Map<String, dynamic>? parking;
  Map<String, dynamic>? review;
  Map<String, dynamic>? submitNotice;
  bool panelUnlocked = false;

  bool get hasDraft => parkingId != null && parkingId!.isNotEmpty;

  void reset() {
    parkingId = null;
    parking = null;
    review = null;
    submitNotice = null;
    panelUnlocked = false;
  }

  void unlockPanel() {
    panelUnlocked = true;
  }

  Future<Map<String, dynamic>> createOrUpdateLocation(
    Map<String, dynamic> payload,
  ) async {
    final response = hasDraft
        ? await HostApiClient.instance.saveLocationStep(parkingId!, payload)
        : await HostApiClient.instance.createParkingDraft(payload);
    _storeParking(response);
    return response;
  }

  Future<Map<String, dynamic>> saveDetails(Map<String, dynamic> payload) async {
    final response = await HostApiClient.instance.saveDetailsStep(
      parkingId!,
      payload,
    );
    _storeParking(response);
    return response;
  }

  Future<Map<String, dynamic>> saveSpaces(Map<String, dynamic> payload) async {
    final response = await HostApiClient.instance.saveSpacesStep(
      parkingId!,
      payload,
    );
    _storeParking(response);
    return response;
  }

  Future<Map<String, dynamic>> saveServices(
    Map<String, dynamic> payload,
  ) async {
    final response = await HostApiClient.instance.saveServicesStep(
      parkingId!,
      payload,
    );
    _storeParking(response);
    return response;
  }

  Future<Map<String, dynamic>> savePhotos(Map<String, dynamic> payload) async {
    final response = await HostApiClient.instance.savePhotosStep(
      parkingId!,
      payload,
    );
    _storeParking(response);
    return response;
  }

  Future<Map<String, dynamic>> fetchReview() async {
    final response = await HostApiClient.instance.fetchReview(parkingId!);
    review = response;
    _storeParking(response);
    return response;
  }

  Future<Map<String, dynamic>> fetchPricing() async {
    return HostApiClient.instance.fetchPricing(parkingId!);
  }

  Future<Map<String, dynamic>> savePricing(Map<String, dynamic> payload) async {
    return HostApiClient.instance.savePricing(parkingId!, payload);
  }

  Future<Map<String, dynamic>> submit() async {
    final response = await HostApiClient.instance.submitParking(parkingId!);
    submitNotice = response['notice'] as Map<String, dynamic>?;
    _storeParking(response);
    return response;
  }

  void _storeParking(Map<String, dynamic> response) {
    final parkingData = response['parking'] as Map<String, dynamic>?;
    if (parkingData == null) return;
    parking = parkingData;
    parkingId = parkingData['id'] as String? ?? parkingId;
  }
}
