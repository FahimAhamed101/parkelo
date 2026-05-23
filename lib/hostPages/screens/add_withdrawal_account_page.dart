import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _line = Color(0xFFE1E8F2);
const _warningBg = Color(0xFFFFF8E8);
const _warningLine = Color(0xFFFFE7B8);
const _warningIcon = Color(0xFFF59E0B);

class AddWithdrawalAccountPage extends StatelessWidget {
  const AddWithdrawalAccountPage({super.key});

  static const _banks = [
    'Banco Popular',
    'BanBookingtions',
    'BHD Leon',
    'Banco Santa Cruz',
    'Scotiabank',
    'Apap',
    'Bancamerica',
    'Banesco',
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryBlue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        body: Column(
          children: [
            _Header(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 30,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCE3EC),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Add withdrawal account',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'This account will receive the funds from your\nparking spaces.',
                        style: TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 10.5,
                          height: 1.28,
                        ),
                      ),
                      const SizedBox(height: 21),
                      const _FieldLabel('Bank'),
                      const SizedBox(height: 9),
                      Wrap(
                        spacing: 6,
                        runSpacing: 8,
                        children: [
                          for (final bank in _banks)
                            _BankChip(
                              label: bank,
                              isSelected: bank == 'Banco Popular',
                            ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const _FieldLabel('Account type'),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Expanded(
                            child: _AccountTypeButton(
                              label: 'Checking',
                              isSelected: true,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _AccountTypeButton(
                              label: 'Savings',
                              isSelected: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 17),
                      const _FieldLabel('Account number'),
                      const SizedBox(height: 7),
                      const _FormFieldBox(hint: 'Ej: 01234567890'),
                      const SizedBox(height: 14),
                      const _FieldLabel('Full name of the account holder'),
                      const SizedBox(height: 7),
                      const _FormFieldBox(hint: 'Ej: Juan Carlos Perez'),
                      const SizedBox(height: 14),
                      const _FieldLabel('Identity card'),
                      const SizedBox(height: 7),
                      const _FormFieldBox(hint: 'Ej: 001-1234567-8'),
                      const SizedBox(height: 5),
                      const Text(
                        'REQUIRED FOR IDENTITY VERIFICATION',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFFAAB4C2),
                          fontSize: 7.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const _SecurityNotice(),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _BottomButton(
                              label: 'Cancel',
                              isPrimary: false,
                              onPressed: () => Navigator.maybePop(context),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: _BottomButton(
                              label: 'Save account',
                              isPrimary: true,
                              onPressed: () {
                                Navigator.pushNamed(context, '/publish-parking');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 14, 16),
          child: SizedBox(
            height: 42,
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 42,
                    height: 42,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Income and withdrawals',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: _ink,
        fontSize: 10.5,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _BankChip extends StatelessWidget {
  const _BankChip({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isSelected ? _primaryBlue : const Color(0xFFDDE5F0),
          width: isSelected ? 1.1 : 1,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isSelected ? _primaryBlue : const Color(0xFF5F6C80),
          fontSize: 8.6,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
        ),
      ),
    );
  }
}

class _AccountTypeButton extends StatelessWidget {
  const _AccountTypeButton({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? _primaryBlue : const Color(0xFF111827),
          width: isSelected ? 1.3 : 1,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isSelected ? _primaryBlue : const Color(0xFF4B5563),
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _FormFieldBox extends StatelessWidget {
  const _FormFieldBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37,
      child: TextField(
        style: const TextStyle(color: _ink, fontSize: 11),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFD0D6DF), fontSize: 11),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: _inputBorder(_line),
          focusedBorder: _inputBorder(_primaryBlue),
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      decoration: BoxDecoration(
        color: _warningBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _warningLine),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.lock_rounded, color: _warningIcon, size: 14),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your banking information is encrypted and\nonly used to process withdrawals.',
              style: TextStyle(color: _ink, fontSize: 9.5, height: 1.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: isPrimary ? _actionBlue : Colors.white,
          foregroundColor: isPrimary ? Colors.white : _actionBlue,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: const BorderSide(color: _actionBlue),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
