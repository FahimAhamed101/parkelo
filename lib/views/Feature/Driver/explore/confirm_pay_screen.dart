import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../../helpers/route.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../Authentication/controllers/auth_controller.dart';
import '../../Authentication/services/auth_api_service.dart';
import '../../../base/AppText/appText.dart';
import 'booking_flow_models.dart';
import 'widgets/driver_flow_nav_bar.dart';

class ConfirmPayScreen extends StatefulWidget {
  const ConfirmPayScreen({super.key});

  @override
  State<ConfirmPayScreen> createState() => _ConfirmPayScreenState();
}

class _ConfirmPayScreenState extends State<ConfirmPayScreen> {
  late BookingDraft _draft;
  int _selectedPaymentMethod = 0;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _draft = BookingDraft.fromMap(args is Map<String, dynamic> ? args : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: const DriverFlowNavBar(selectedIndex: 0),
      body: Column(
        children: [
          _PlainFlowHeader(
            title: 'Confirm and pay',
            subtitle: _draft.parkingName,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'Your reservation',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        const SizedBox(height: 14),
                        _Row(
                          label: 'Date',
                          value:
                              '${_draft.dateLabel} - ${_draft.timeRangeLabel}',
                        ),
                        const SizedBox(height: 10),
                        _Row(label: 'Duration', value: _draft.durationLabel),
                        const SizedBox(height: 10),
                        _Row(label: 'Space', value: _draft.assignedSpace),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    'Payment method',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: 10),
                  _paymentOption(0, 'Credit card / debit'),
                  const SizedBox(height: 10),
                  _paymentOption(1, 'Cash on arrival'),
                  if (_selectedPaymentMethod == 0) ...[
                    const SizedBox(height: 14),
                    _StripeNotice(total: _draft.total),
                  ],
                  const SizedBox(height: 14),
                  _Card(
                    child: Column(
                      children: [
                        _Row(
                          label: 'Subtotal',
                          value: 'RD\$${_draft.subtotal}',
                        ),
                        if (_draft.insuranceEnabled) ...[
                          const SizedBox(height: 10),
                          _Row(
                            label: 'Insurance',
                            value: 'RD\$${_draft.insuranceFee}',
                          ),
                        ],
                        const SizedBox(height: 10),
                        _Row(label: 'ITBIS 18%', value: 'RD\$${_draft.tax}'),
                        const SizedBox(height: 10),
                        _Row(
                          label: 'Service fee',
                          value: 'RD\$${_draft.serviceFee}',
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              'Total',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                            AppText(
                              'RD\$${_draft.total}',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: _submitting ? null : _confirmReservation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : AppText(
                              'Confirm reservation',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No charge is processed until check-in. By continuing you accept the Terms of Use.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textFaint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReservation() async {
    final parkingId = _draft.parkingId;
    if (parkingId == null || parkingId.isEmpty) {
      _showError('Parking id is missing. Please reopen the parking details.');
      return;
    }

    final token = AuthController.instance.token.value;
    if (token == null || token.isEmpty) {
      _showError('Please sign in before confirming a reservation.');
      return;
    }

    setState(() => _submitting = true);
    try {
      final isCard = _selectedPaymentMethod == 0;
      final paymentIntentId = isCard
          ? await _confirmStripePayment(token)
          : null;
      final response = await http.post(
        Uri.parse('${AuthApiService.baseUrl}/api/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(_bookingPayload(paymentIntentId: paymentIntentId)),
      );
      final decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
      if (response.statusCode >= 400) {
        final message = decoded is Map<String, dynamic>
            ? decoded['message']?.toString() ?? 'Booking failed'
            : 'Booking failed';
        throw Exception(message);
      }
      if (!mounted) return;
      Get.toNamed(AppRoutes.bookingConfirmedScreen, arguments: _draft.toMap());
    } on stripe.StripeException catch (error) {
      final message = error.error.localizedMessage;
      _showError(message?.isNotEmpty == true ? message! : 'Payment cancelled');
    } catch (error) {
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Map<String, dynamic> _bookingPayload({String? paymentIntentId}) {
    return {
      'parkingId': _draft.parkingId,
      'date': _draft.toMap()['date'],
      'arrivalTime': _draft.arrivalTime,
      'durationHours': _draft.durationHours,
      'insuranceIncluded': _draft.insuranceEnabled,
      'vehiclePlate': _draft.vehiclePlate,
      'bookForOther': _draft.bookForAnotherPerson,
      'paymentMethod': _selectedPaymentMethod == 0 ? 'card' : 'cash',
      if (paymentIntentId != null) 'paymentIntentId': paymentIntentId,
    };
  }

  Future<String> _confirmStripePayment(String token) async {
    final response = await http.post(
      Uri.parse('${AuthApiService.baseUrl}/api/bookings/payment-intent'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(_bookingPayload()),
    );
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);
    if (response.statusCode >= 400) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString() ?? 'Payment setup failed'
          : 'Payment setup failed';
      throw Exception(message);
    }
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Payment setup failed');
    }

    final publishableKey = decoded['publishableKey']?.toString();
    final clientSecret = decoded['clientSecret']?.toString();
    final paymentIntentId = decoded['paymentIntentId']?.toString();
    if (publishableKey == null || publishableKey.isEmpty) {
      throw Exception('Stripe publishable key is missing from the backend');
    }
    if (clientSecret == null || clientSecret.isEmpty) {
      throw Exception('Stripe client secret is missing from the backend');
    }
    if (paymentIntentId == null || paymentIntentId.isEmpty) {
      throw Exception('Stripe payment intent id is missing from the backend');
    }

    stripe.Stripe.publishableKey = publishableKey;
    await stripe.Stripe.instance.applySettings();
    await stripe.Stripe.instance.initPaymentSheet(
      paymentSheetParameters: stripe.SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Parkealo',
        style: ThemeMode.light,
      ),
    );
    await stripe.Stripe.instance.presentPaymentSheet();

    return paymentIntentId;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _paymentOption(int index, String label) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.blue : AppColors.borderMd,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.blue : Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            AppText(label, fontSize: 13, fontWeight: FontWeight.w800),
          ],
        ),
      ),
    );
  }

}

class _StripeNotice extends StatelessWidget {
  final int total;

  const _StripeNotice({required this.total});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.credit_card_rounded,
              color: AppColors.blue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Secure Stripe checkout',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
                const SizedBox(height: 4),
                AppText(
                  'Card details are entered in Stripe. Total RD\$$total.',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSub,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlainFlowHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PlainFlowHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.blue,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title, fontSize: 24, fontWeight: FontWeight.w900),
                  const SizedBox(height: 2),
                  AppText(
                    subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSub,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: AppText(label, fontSize: 13, color: AppColors.textSub)),
        Expanded(
          child: AppText(
            value,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
