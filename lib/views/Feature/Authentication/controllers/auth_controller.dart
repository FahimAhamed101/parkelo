import 'package:get/get.dart';

import '../../../../helpers/route.dart';
import '../models/auth_user.dart';
import '../services/auth_api_service.dart';

class AuthController extends GetxController {
  AuthController({AuthApiService? api}) : _api = api ?? AuthApiService.instance;

  static AuthController get instance {
    if (Get.isRegistered<AuthController>()) {
      return Get.find<AuthController>();
    }

    return Get.put(AuthController(), permanent: true);
  }

  final AuthApiService _api;

  final RxnString token = RxnString();
  final Rxn<AuthUser> user = Rxn<AuthUser>();
  final Rxn<AccountProfile> profile = Rxn<AccountProfile>();
  final RxBool isLoading = false.obs;
  final RxBool isProfileLoading = false.obs;

  bool get isAuthenticated => token.value?.isNotEmpty == true;

  Future<void> signIn({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    if (identifier.trim().isEmpty || password.isEmpty) {
      _showError('Email/phone and password are required');
      return;
    }

    await _runAuthRequest(() async {
      final response = await _api.signIn(
        identifier: identifier.trim(),
        password: password,
        rememberMe: rememberMe,
      );
      _setSession(response);
      await loadProfile();
      Get.offAllNamed(AppRoutes.bottomNavScreen);
    });
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String vehiclePlate,
    required String password,
    required String confirmPassword,
    required bool termsAccepted,
  }) async {
    final names = _splitName(fullName);

    if (names.$1.isEmpty) {
      _showError('Enter your full name');
      return;
    }
    if (email.trim().isEmpty ||
        phoneNumber.trim().isEmpty ||
        vehiclePlate.trim().isEmpty) {
      _showError('Email, phone, and vehicle plate are required');
      return;
    }
    if (!termsAccepted) {
      _showError('Terms and conditions must be accepted');
      return;
    }

    await _runAuthRequest(() async {
      final response = await _api.signUp(
        firstName: names.$1,
        lastName: names.$2,
        email: email.trim(),
        phoneNumber: phoneNumber.trim(),
        vehiclePlate: vehiclePlate.trim(),
        password: password,
        confirmPassword: confirmPassword,
        termsAccepted: termsAccepted,
      );
      _setSession(response);
      await loadProfile();
      Get.offAllNamed(AppRoutes.bottomNavScreen);
    });
  }

  Future<void> loadProfile() async {
    final currentToken = token.value;
    if (currentToken == null || currentToken.isEmpty) return;

    isProfileLoading.value = true;
    try {
      final response = await _api.profile(currentToken);
      final profileJson = response['profile'];
      if (profileJson is Map<String, dynamic>) {
        profile.value = AccountProfile.fromJson(profileJson);
        user.value = profile.value?.user;
      }
    } catch (_) {
      final response = await _api.me(currentToken);
      final userJson = response['user'];
      if (userJson is Map<String, dynamic>) {
        user.value = AuthUser.fromJson(userJson);
      }
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String phoneNumber,
    required String email,
  }) async {
    final currentToken = token.value;
    if (currentToken == null || currentToken.isEmpty) return;

    await _runAuthRequest(() async {
      final response = await _api.updateProfile(
        currentToken,
        fullName: fullName.trim(),
        phoneNumber: phoneNumber.trim(),
        email: email.trim(),
      );
      final profileJson = response['profile'];
      if (profileJson is Map<String, dynamic>) {
        profile.value = AccountProfile.fromJson(profileJson);
        user.value = profile.value?.user;
      }
      Get.back();
      _showSuccess(response['message']?.toString() ?? 'Profile updated');
    });
  }

  Future<void> logout() async {
    final currentToken = token.value;

    isLoading.value = true;
    try {
      if (currentToken != null && currentToken.isNotEmpty) {
        await _api.logout(currentToken);
      }
    } catch (_) {
      // Local session still needs to be cleared even if the stateless API call fails.
    } finally {
      token.value = null;
      user.value = null;
      profile.value = null;
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  Future<void> _runAuthRequest(Future<void> Function() request) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await request();
    } on AuthApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError(
        'Could not connect to Parkealo backend at ${AuthApiService.baseUrl}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _setSession(Map<String, dynamic> response) {
    token.value = response['token']?.toString();
    final userJson = response['user'];
    if (userJson is Map<String, dynamic>) {
      user.value = AuthUser.fromJson(userJson);
    }
  }

  (String, String) _splitName(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return ('', '');
    if (parts.length == 1) return (parts.first, 'User');
    return (parts.first, parts.sublist(1).join(' '));
  }

  void _showError(String message) {
    Get.snackbar('Parkealo', message, snackPosition: SnackPosition.BOTTOM);
  }

  void _showSuccess(String message) {
    Get.snackbar('Parkealo', message, snackPosition: SnackPosition.BOTTOM);
  }
}
