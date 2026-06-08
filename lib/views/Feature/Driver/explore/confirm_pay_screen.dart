import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../helpers/route.dart';
import '../../../../utils/appColor/app_colors.dart';
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
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _draft = BookingDraft.fromMap(args is Map<String, dynamic> ? args : null);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _nameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
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
                    _Card(
                      child: Column(
                        children: [
                          _inputLabel('Card number'),
                          const SizedBox(height: 6),
                          _textField(
                            controller: _cardNumberController,
                            hint: '**** **** **** ****',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          _inputLabel('Name on card'),
                          const SizedBox(height: 6),
                          _textField(
                            controller: _nameController,
                            hint: 'NAME SURNAME',
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _inputLabel('Expiration'),
                                    const SizedBox(height: 6),
                                    _textField(
                                      controller: _expiryController,
                                      hint: 'MM/AA',
                                      keyboardType: TextInputType.datetime,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _inputLabel('CVV'),
                                    const SizedBox(height: 6),
                                    _textField(
                                      controller: _cvvController,
                                      hint: '***',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                    onTap: _confirmReservation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
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

  void _confirmReservation() {
    Get.toNamed(AppRoutes.bookingConfirmedScreen, arguments: _draft.toMap());
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

  Widget _inputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AppText(
        label,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.textSub,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.text,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.textFaint,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blue),
        ),
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
