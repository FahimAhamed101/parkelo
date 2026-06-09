import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../views/Feature/Authentication/controllers/auth_controller.dart';
import '../../views/Feature/Authentication/services/auth_api_service.dart';

class HostApiClient {
  HostApiClient._();

  static final HostApiClient instance = HostApiClient._();

  static const String _token = String.fromEnvironment(
    'PARKEALO_API_TOKEN',
    defaultValue: '',
  );

  static String get _baseUrl => AuthApiService.baseUrl;

  String get _authToken {
    if (_token.isNotEmpty) return _token;
    if (Get.isRegistered<AuthController>()) {
      return AuthController.instance.token.value ?? '';
    }
    return '';
  }

  Map<String, String> get _headers {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final token = _authToken;

    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  bool get _canUseDemoFallback => _authToken.isEmpty;

  Future<Map<String, dynamic>> fetchSummary() {
    return _getJson('/api/host/summary', fallback: _demoSummary());
  }

  Future<Map<String, dynamic>> fetchDashboard() {
    return _getJson('/api/host/dashboard', fallback: _demoDashboard());
  }

  Future<Map<String, dynamic>> fetchAlerts() {
    return _getJson('/api/host/alerts', fallback: _demoAlerts());
  }

  Future<Map<String, dynamic>> fetchManualRequests() {
    return _getJson(
      '/api/host/manual-requests',
      fallback: _demoManualRequests(),
    );
  }

  Future<Map<String, dynamic>> fetchParkings() {
    return _getJson('/api/host/parkings', fallback: _demoParkings());
  }

  Future<Map<String, dynamic>> fetchParking(String parkingId) {
    return _getJson(
      '/api/host/parkings/$parkingId',
      fallback: _demoParkingDetail(),
    );
  }

  Future<Map<String, dynamic>> fetchPricing(String parkingId) {
    return _getJson(
      '/api/host/parkings/$parkingId/pricing',
      fallback: _demoPricing(),
    );
  }

  Future<Map<String, dynamic>> createParkingDraft(
    Map<String, dynamic> payload,
  ) async {
    try {
      return await _postJson('/api/host/parkings', body: payload);
    } catch (_) {
      if (!_canUseDemoFallback) rethrow;
      final parking = Map<String, dynamic>.from(
        _demoParkingDetail()['parking'],
      );
      parking
        ..['name'] = payload['name'] ?? parking['name']
        ..['zone'] = payload['zone'] ?? parking['zone']
        ..['sector'] = payload['sector'] ?? parking['sector'];
      return {
        'success': true,
        'message': 'Host parking draft created',
        'parking': parking,
      };
    }
  }

  Future<Map<String, dynamic>> saveLocationStep(
    String parkingId,
    Map<String, dynamic> payload,
  ) async {
    return _patchJson(
      '/api/host/parkings/$parkingId/location',
      body: payload,
    ).catchError((error) {
      if (!_canUseDemoFallback) throw error;
      return {'success': true, 'parking': _demoParkingDetail()['parking']};
    });
  }

  Future<Map<String, dynamic>> saveDetailsStep(
    String parkingId,
    Map<String, dynamic> payload,
  ) async {
    return _patchJson(
      '/api/host/parkings/$parkingId/details',
      body: payload,
    ).catchError(
      (_) => {'success': true, 'parking': _demoParkingDetail()['parking']},
    );
  }

  Future<Map<String, dynamic>> saveSpacesStep(
    String parkingId,
    Map<String, dynamic> payload,
  ) async {
    return _patchJson(
      '/api/host/parkings/$parkingId/spaces',
      body: payload,
    ).catchError(
      (_) => {'success': true, 'parking': _demoParkingDetail()['parking']},
    );
  }

  Future<Map<String, dynamic>> saveServicesStep(
    String parkingId,
    Map<String, dynamic> payload,
  ) async {
    return _patchJson(
      '/api/host/parkings/$parkingId/services',
      body: payload,
    ).catchError(
      (_) => {'success': true, 'parking': _demoParkingDetail()['parking']},
    );
  }

  Future<Map<String, dynamic>> savePhotosStep(
    String parkingId,
    Map<String, dynamic> payload,
  ) async {
    return _patchJson(
      '/api/host/parkings/$parkingId/photos',
      body: payload,
    ).catchError(
      (_) => {'success': true, 'parking': _demoParkingDetail()['parking']},
    );
  }

  Future<Map<String, dynamic>> fetchReview(String parkingId) {
    return _getJson(
      '/api/host/parkings/$parkingId/review',
      fallback: _demoReview(),
    );
  }

  Future<Map<String, dynamic>> submitParking(String parkingId) {
    return _postJson(
      '/api/host/parkings/$parkingId/submit',
    ).catchError((_) => _demoSubmitted());
  }

  Future<Map<String, dynamic>> savePricing(
    String parkingId,
    Map<String, dynamic> payload,
  ) async {
    return _putJson(
      '/api/host/parkings/$parkingId/pricing',
      body: payload,
    ).catchError(
      (_) => {'success': true, 'pricing': _demoPricing()['pricing']},
    );
  }

  Future<Map<String, dynamic>> fetchParkingQr(String parkingId) {
    return _getJson(
      '/api/host/parkings/$parkingId/qr',
      fallback: _demoParkingQr(),
    );
  }

  Future<Map<String, dynamic>> approveRequest(String bookingId) {
    return _postJson(
      '/api/host/requests/$bookingId/approve',
    ).catchError((_) => _demoActionResponse('approved', bookingId));
  }

  Future<Map<String, dynamic>> declineRequest(String bookingId) {
    return _postJson(
      '/api/host/requests/$bookingId/decline',
    ).catchError((_) => _demoActionResponse('declined', bookingId));
  }

  Future<Map<String, dynamic>> _getJson(
    String path, {
    required Map<String, dynamic> fallback,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$path'),
        headers: _headers,
      );
      return _decodeResponse(response);
    } catch (_) {
      return fallback;
    }
  }

  Future<Map<String, dynamic>> _postJson(
    String path, {
    Map<String, dynamic> body = const <String, dynamic>{},
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> _patchJson(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> _putJson(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      final message = decoded is Map<String, dynamic>
          ? (decoded['message'] as String? ?? 'Request failed')
          : 'Request failed';
      throw HostApiException(message, response.statusCode);
    }

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const HostApiException('Unexpected response format', 500);
  }

  Map<String, dynamic> _demoSummary() {
    return {
      'success': true,
      'host': {
        'isHost': true,
        'onboardingCompleted': false,
        'inviteCode': 'HOST-JM3K9',
        'inviteRewardAmount': 500,
      },
      'primaryAction': 'Add my parking',
      'parkings': const [],
    };
  }

  Map<String, dynamic> _demoDashboard() {
    return {
      'success': true,
      'panel': {
        'title': 'Host panel',
        'subtitle': 'Parking Colonial Premium',
        'primaryParking': {
          'id': 'demo-parking-1',
          'name': 'Parking Colonial Premium',
          'code': 'HOST-JM3K9',
          'submissionStatus': 'draft',
        },
        'stats': {
          'incomeToday': 4200,
          'incomeTodayLabel': 'RD\$4,200',
          'occupancy': {
            'occupied': 8,
            'total': 12,
            'label': '8 / 12',
            'percent': 67,
          },
          'bookingsToday': 14,
          'rating': 4.87,
        },
        'reservationMode': {
          'mode': 'automatic',
          'active': true,
          'description':
              'Reservations are confirmed automatically. The user receives the information immediately.',
        },
        'peakHourChart': [
          {'label': '6am', 'bookings': 1},
          {'label': '9am', 'bookings': 4},
          {'label': '12pm', 'bookings': 3},
          {'label': '3pm', 'bookings': 5},
          {'label': '6pm', 'bookings': 4},
          {'label': '9pm', 'bookings': 1},
        ],
        'invite': {
          'code': 'HOST-JM3K9',
          'rewardAmount': 500,
          'message':
              'Invite other hosts and earn a reward for each first parking published.',
        },
      },
    };
  }

  Map<String, dynamic> _demoAlerts() {
    return {
      'success': true,
      'unreadCount': 4,
      'alerts': [
        {
          'id': 'a1',
          'message': 'User A123456 finished their time in space B1',
          'time': '5 min ago',
          'severity': 'warning',
        },
        {
          'id': 'a2',
          'message': 'New private request - license plate C789012',
          'time': '18 min ago',
          'severity': 'info',
        },
        {
          'id': 'a3',
          'message': 'Overtime detected - A2 (+12 min)',
          'time': '32 min ago',
          'severity': 'warning',
        },
        {
          'id': 'a4',
          'message': 'Booking confirmed - D901234 - tomorrow 09:00',
          'time': '1h ago',
          'severity': 'success',
        },
      ],
    };
  }

  Map<String, dynamic> _demoManualRequests() {
    return {
      'success': true,
      'total': 2,
      'requests': [
        {
          'id': 'r1',
          'bookingId': 'r1',
          'confirmationCode': 'PKL-1234',
          'vehiclePlate': 'ABC-123',
          'parkingName': 'Parking Colonial Premium',
          'message': 'A driver requested to reserve Parking Colonial Premium.',
          'time': '1 minute ago',
        },
        {
          'id': 'r2',
          'bookingId': 'r2',
          'confirmationCode': 'PKL-2345',
          'vehiclePlate': 'C789012',
          'parkingName': 'Parking Colonial Premium',
          'message': 'A driver requested to reserve Parking Colonial Premium.',
          'time': '1 day ago',
        },
      ],
    };
  }

  Map<String, dynamic> _demoParkings() {
    return {
      'success': true,
      'total': 1,
      'parkings': [
        {
          'id': 'demo-parking-1',
          'name': 'Parking Colonial Premium',
          'code': 'HOST-JM3K9',
          'status': 'draft',
          'submissionStatus': 'draft',
          'spaces': {
            'total': 12,
            'available': 8,
            'floors': 2,
            'identifiers': List<String>.generate(12, (index) => '${index + 1}'),
          },
        },
      ],
    };
  }

  Map<String, dynamic> _demoParkingDetail() {
    final parkings = _demoParkings()['parkings'] as List<dynamic>;
    return {'success': true, 'parking': parkings.first};
  }

  Map<String, dynamic> _demoPricing() {
    return {
      'success': true,
      'pricing': {
        'mode': 'per_section',
        'global': {
          'hourly': 150,
          'daily': 800,
          'weekly': 4500,
          'hourlyLabel': 'RD\$150',
          'dailyLabel': 'RD\$800',
          'weeklyLabel': 'RD\$4500',
        },
        'dynamicPricing': {
          'enabled': true,
          'occupancyThresholdPercent': 80,
          'peakIncreasePercent': 20,
        },
        'overtime': {'multiplier': 1.5, 'graceMinutes': 0},
        'sections': [
          {
            'id': 'a',
            'code': 'A',
            'name': 'Ground Floor',
            'description': 'Section A1 - A10',
            'enabled': true,
            'spaces': ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
            'rate': {
              'hourly': 150,
              'daily': 800,
              'weekly': 4500,
              'hourlyLabel': 'RD\$150',
              'dailyLabel': 'RD\$800',
              'weeklyLabel': 'RD\$4500',
            },
          },
          {
            'id': 'b',
            'code': 'B',
            'name': 'Level 1',
            'description': 'Section B1 - B10',
            'enabled': true,
            'spaces': ['1', '2', '3', '4', '5', '6', '7', '8'],
            'rate': {
              'hourly': 120,
              'daily': 650,
              'weekly': 3800,
              'hourlyLabel': 'RD\$120',
              'dailyLabel': 'RD\$650',
              'weeklyLabel': 'RD\$3800',
            },
          },
        ],
      },
    };
  }

  Map<String, dynamic> _demoReview() {
    return {
      'success': true,
      'parking': _demoParkingDetail()['parking'],
      'next': {
        'title': 'What happens next?',
        'items': [
          'The Parkealo team will review your parking in up to 2 hours.',
          'After approval, it will appear on the map and users can reserve it.',
          'You will receive booking notifications in the host panel.',
        ],
      },
    };
  }

  Map<String, dynamic> _demoSubmitted() {
    return {
      'success': true,
      'message': 'Parking submitted for review',
      'parking': _demoParkingDetail()['parking'],
      'notice': {
        'title': 'Request submitted!',
        'message': 'Your parking is being reviewed by the Parkealo team.',
        'estimatedReviewHours': 2,
        'actionLabel': 'Go to admin panel',
      },
    };
  }

  Map<String, dynamic> _demoParkingQr() {
    return {
      'success': true,
      'qr': {
        'payload':
            '{"type":"parkealo_host_parking","parkingId":"demo-parking-1"}',
        'dataUrl': '',
        'label': 'Parking Colonial Premium',
        'code': 'HOST-JM3K9',
      },
    };
  }

  Map<String, dynamic> _demoActionResponse(String status, String bookingId) {
    return {
      'success': true,
      'message': 'Request $status',
      'booking': {
        'id': bookingId,
        'status': status == 'approved' ? 'pending_checkin' : 'declined',
      },
    };
  }
}

class HostApiException implements Exception {
  const HostApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => 'HostApiException($statusCode): $message';
}
