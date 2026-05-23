import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';

class ExtendTimeScreen extends StatefulWidget {
  const ExtendTimeScreen({super.key});

  @override
  State<ExtendTimeScreen> createState() => _ExtendTimeScreenState();
}

class _ExtendTimeScreenState extends State<ExtendTimeScreen> {
  int _selectedHours = 1;
  final List<int> _quickOptions = [1, 2, 3, 4, 6];
  final double _ratePerHour = 150;
  final double _itbisRate = 0.18;
  final double _serviceFee = 25;

  double get _subtotal => _ratePerHour * _selectedHours;
  double get _itbis => _subtotal * _itbisRate;
  double get _total => _subtotal + _itbis + _serviceFee;

  void _increment() {
    if (_selectedHours < 6) setState(() => _selectedHours++);
  }

  void _decrement() {
    if (_selectedHours > 1) setState(() => _selectedHours--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Extend Time", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Availability banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32), size: 18),
                  const SizedBox(width: 8),
                  AppText(
                    "Space available — you can extend up to 3h more",
                    fontSize: 13,
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Hour picker card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText("How many more hours?", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  const SizedBox(height: 20),

                  // Stepper
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StepperButton(
                        icon: Icons.remove,
                        onTap: _decrement,
                        enabled: _selectedHours > 1,
                      ),
                      const SizedBox(width: 28),
                      Column(
                        children: [
                          AppText(
                            "$_selectedHours",
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.Primary,
                          ),
                          AppText("HOUR", fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                        ],
                      ),
                      const SizedBox(width: 28),
                      _StepperButton(
                        icon: Icons.add,
                        onTap: _increment,
                        enabled: _selectedHours < 6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quick select chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _quickOptions.map((h) {
                      final selected = _selectedHours == h;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedHours = h),
                        child: Container(
                          width: 56,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? Colors.white : Colors.white,
                            border: Border.all(
                              color: selected ? AppColors.Primary : Colors.grey.shade300,
                              width: selected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            "${h}h",
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            color: selected ? AppColors.Primary : Colors.grey.shade600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText("Payment Summary", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  const SizedBox(height: 16),
                  _SummaryRow(
                    label: "RD\$${_ratePerHour.toInt()} × $_selectedHours hour${_selectedHours > 1 ? 's' : ''}",
                    value: "RD\$${_subtotal.toInt()}",
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow(label: "ITBIS (18%)", value: "RD\$${_itbis.toInt()}"),
                  const SizedBox(height: 10),
                  _SummaryRow(label: "Service fee", value: "RD\$${_serviceFee.toInt()}"),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText("Total", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.Primary, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText(
                          "RD\$${_total.toInt()}",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.Primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm button
            GestureDetector(
              onTap: () => Get.back(result: _selectedHours),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.Primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: AppText(
                  "Confirm and pay RD\$${_total.toInt()}",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _StepperButton({required this.icon, required this.onTap, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? Colors.grey.shade400 : Colors.grey.shade200, width: 1.5),
          color: Colors.white,
        ),
        child: Icon(icon, size: 20, color: enabled ? Colors.black87 : Colors.grey.shade300),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, fontSize: 13, color: Colors.grey.shade600),
        AppText(value, fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
      ],
    );
  }
}
