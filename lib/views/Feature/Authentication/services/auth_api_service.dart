import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthApiException implements Exception {
  const AuthApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class AuthApiService {
  AuthApiService._();

  static final AuthApiService instance = AuthApiService._();

  static String get baseUrl {
    const configured = String.fromEnvironment('PARKEALO_API_BASE_URL');
    if (configured.isNotEmpty) return configured;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://localhost:5000';
  }

  Future<Map<String, dynamic>> signIn({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) {
    return _post(
      '/api/auth/signin',
      body: {
        'identifier': identifier,
        'password': password,
        'rememberMe': rememberMe,
      },
    );
  }

  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String vehiclePlate,
    required String password,
    required String confirmPassword,
    required bool termsAccepted,
  }) {
    return _post(
      '/api/auth/signup',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'vehiclePlate': vehiclePlate,
        'password': password,
        'confirmPassword': confirmPassword,
        'termsAccepted': termsAccepted,
      },
    );
  }

  Future<Map<String, dynamic>> me(String token) {
    return _get('/api/auth/me', token: token);
  }

  Future<Map<String, dynamic>> profile(String token) {
    return _get('/api/account/profile', token: token);
  }

  Future<Map<String, dynamic>> updateProfile(
    String token, {
    required String fullName,
    required String phoneNumber,
    required String email,
  }) {
    return _patch(
      '/api/account/profile',
      token: token,
      body: {'fullName': fullName, 'phoneNumber': phoneNumber, 'email': email},
    );
  }

  Future<Map<String, dynamic>> logout(String token) {
    return _post('/api/account/logout', token: token);
  }

  Future<Map<String, dynamic>> _get(String path, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    Map<String, dynamic> body = const <String, dynamic>{},
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> _patch(
    String path, {
    required Map<String, dynamic> body,
    required String token,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decode(http.Response response) {
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);

    if (response.statusCode >= 400) {
      final message = decoded is Map<String, dynamic>
          ? (decoded['message'] ?? 'Request failed').toString()
          : 'Request failed';
      throw AuthApiException(message, response.statusCode);
    }

    if (decoded is Map<String, dynamic>) return decoded;
    throw const AuthApiException('Unexpected response format', 500);
  }
}
