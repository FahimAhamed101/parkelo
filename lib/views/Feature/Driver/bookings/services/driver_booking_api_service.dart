import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../Authentication/controllers/auth_controller.dart';
import '../../../Authentication/services/auth_api_service.dart';

class DriverBookingApiException implements Exception {
  const DriverBookingApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class DriverBookingApiService {
  DriverBookingApiService._();

  static final DriverBookingApiService instance = DriverBookingApiService._();

  Future<Map<String, dynamic>> listBookings({required String tab}) {
    return _get('/api/bookings?tab=$tab');
  }

  Future<Map<String, dynamic>> checkIn({
    required String bookingId,
    required String qrPayload,
  }) {
    return _post(
      '/api/bookings/$bookingId/check-in',
      body: {'qrPayload': qrPayload},
    );
  }

  Future<Map<String, dynamic>> checkOut({required String bookingId}) {
    return _post('/api/bookings/$bookingId/check-out');
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final response = await http.get(
      Uri.parse('${AuthApiService.baseUrl}$path'),
      headers: _headers(),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    Map<String, dynamic> body = const <String, dynamic>{},
  }) async {
    final response = await http.post(
      Uri.parse('${AuthApiService.baseUrl}$path'),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Map<String, String> _headers() {
    final token = AuthController.instance.token.value ?? '';
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decode(http.Response response) {
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);

    if (response.statusCode >= 400) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString() ?? 'Request failed'
          : 'Request failed';
      throw DriverBookingApiException(message, response.statusCode);
    }

    if (decoded is Map<String, dynamic>) return decoded;
    throw const DriverBookingApiException('Unexpected response format', 500);
  }
}
