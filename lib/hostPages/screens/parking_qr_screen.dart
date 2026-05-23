import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ParkingQrScreen extends StatelessWidget {
  const ParkingQrScreen({super.key});

  static const _backgroundColor = Color(0xFFEAF6FF);
  static const _brandBlue = Color(0xFF154A9F);
  static const _actionBlue = Color(0xFF0796FF);
  static const _inkColor = Color(0xFF101B3D);
  static const _mutedText = Color(0xFF8796B4);

  static const _designWidth = 232.0;
  static const _designHeight = 557.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _brandBlue,
        systemNavigationBarColor: _backgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: Scaffold(
          backgroundColor: _backgroundColor,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final scale = math.min(
                constraints.maxWidth / _designWidth,
                constraints.maxHeight / _designHeight,
              );

              double s(double value) => value * scale;

              return Column(
                children: [
                  _Header(onBack: () => Navigator.maybePop(context)),
                  SizedBox(height: s(16)),
                  _QrCard(scale: scale),
                  SizedBox(height: s(10)),
                  _HowItWorksCard(scale: scale),
                  SizedBox(height: s(13)),
                  _ActionButtons(scale: scale),
                ],
              );
            },
          ),
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
        color: ParkingQrScreen._brandBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 40,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'parking QR Code',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QrCard extends StatelessWidget {
  const _QrCard({required this.scale});

  final double scale;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: s(187),
      height: s(303),
      padding: EdgeInsets.fromLTRB(s(24), s(23), s(24), 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(s(15)),
      ),
      child: Column(
        children: [
          _ParkealoLogo(scale: scale),
          SizedBox(height: s(6)),
          Text(
            'Parking Colonial Premium',
            maxLines: 1,
            overflow: TextOverflow.visible,
            softWrap: false,
            style: TextStyle(
              color: ParkingQrScreen._mutedText,
              fontSize: s(8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: s(7)),
          _QrFrame(scale: scale),
          SizedBox(height: s(9)),
          Text(
            'PKL-COL001',
            maxLines: 1,
            overflow: TextOverflow.visible,
            softWrap: false,
            style: TextStyle(color: const Color(0xFF9BA9BE), fontSize: s(7)),
          ),
          SizedBox(height: s(8)),
          Container(
            height: s(23),
            width: s(127),
            decoration: BoxDecoration(
              color: ParkingQrScreen._actionBlue,
              borderRadius: BorderRadius.circular(s(6)),
            ),
            alignment: Alignment.center,
            child: Text(
              'Check-In / Check-Out',
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: TextStyle(
                color: Colors.white,
                fontSize: s(10.5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: s(16)),
          Text(
            'Scan with the Parkealo app or your camera\n'
            'to check-in or check-out of your reservation.',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: false,
            style: TextStyle(
              color: const Color(0xFFB3C0D3),
              fontSize: s(6.3),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkealoLogo extends StatelessWidget {
  const _ParkealoLogo({required this.scale});

  final double scale;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: s(40),
      height: s(13),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: s(5),
            child: Container(
              width: s(32),
              height: s(10),
              decoration: BoxDecoration(
                color: ParkingQrScreen._brandBlue,
                borderRadius: BorderRadius.circular(s(3)),
              ),
              alignment: Alignment.center,
              child: Text(
                'Parkealo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: s(4.7),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Container(
              width: s(12),
              height: s(12),
              decoration: BoxDecoration(
                color: ParkingQrScreen._actionBlue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: s(1)),
              ),
              alignment: Alignment.center,
              child: Text(
                'P',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: s(7),
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrFrame extends StatelessWidget {
  const _QrFrame({required this.scale});

  final double scale;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: s(139),
      height: s(139),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ParkingQrScreen._inkColor, width: s(1.2)),
        borderRadius: BorderRadius.circular(s(8)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(s(19)),
              child: QrImageView(
                data: 'PKL-COL001',
                version: QrVersions.auto,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: ParkingQrScreen._inkColor,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: ParkingQrScreen._inkColor,
                ),
              ),
            ),
          ),
          _QrCornerMarks(scale: scale),
        ],
      ),
    );
  }
}

class _QrCornerMarks extends StatelessWidget {
  const _QrCornerMarks({required this.scale});

  final double scale;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _CornerMark(scale: scale, left: s(12), top: s(12)),
        _CornerMark(scale: scale, right: s(12), top: s(12), quarterTurns: 1),
        _CornerMark(scale: scale, right: s(12), bottom: s(12), quarterTurns: 2),
        _CornerMark(scale: scale, left: s(12), bottom: s(12), quarterTurns: 3),
      ],
    );
  }
}

class _CornerMark extends StatelessWidget {
  const _CornerMark({
    required this.scale,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.quarterTurns = 0,
  });

  final double scale;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final int quarterTurns;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: SizedBox(
          width: s(12),
          height: s(12),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: s(12),
                  height: s(1.4),
                  color: ParkingQrScreen._inkColor,
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: s(1.4),
                  height: s(12),
                  color: ParkingQrScreen._inkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.scale});

  final double scale;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: s(187),
      height: s(108),
      padding: EdgeInsets.fromLTRB(s(14), s(13), s(12), 0),
      decoration: BoxDecoration(
        color: ParkingQrScreen._backgroundColor,
        borderRadius: BorderRadius.circular(s(9)),
        border: Border.all(color: const Color(0xFFD6E4F3), width: s(1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How it works',
            style: TextStyle(
              color: const Color(0xFF1457C8),
              fontSize: s(7.5),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: s(10)),
          _InstructionLine(
            scale: scale,
            text: 'User with reservation \u2192 starts the\nclock/timer',
          ),
          SizedBox(height: s(5)),
          _InstructionLine(
            scale: scale,
            text: 'Without an account \u2192 download the app',
          ),
          SizedBox(height: s(5)),
          _InstructionLine(
            scale: scale,
            text: 'Registered without a reservation \u2192 explorer',
          ),
        ],
      ),
    );
  }
}

class _InstructionLine extends StatelessWidget {
  const _InstructionLine({required this.scale, required this.text});

  final double scale;
  final String text;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u2022',
          style: TextStyle(
            color: const Color(0xFF7E91AD),
            fontSize: s(6.3),
            height: 1.25,
          ),
        ),
        SizedBox(width: s(5)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF7E91AD),
              fontSize: s(6.3),
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.scale});

  final double scale;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: s(22)),
      child: Row(
        children: [
          Expanded(
            child: _FooterButton(
              label: 'Close',
              scale: scale,
              filled: false,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          SizedBox(width: s(7)),
          Expanded(
            child: _FooterButton(
              label: 'Download',
              scale: scale,
              filled: true,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.label,
    required this.scale,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final double scale;
  final bool filled;
  final VoidCallback onTap;

  double s(double value) => value * scale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: s(25),
        decoration: BoxDecoration(
          color: filled ? ParkingQrScreen._actionBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(s(6)),
          border: Border.all(color: ParkingQrScreen._actionBlue, width: s(1)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.white : ParkingQrScreen._actionBlue,
            fontSize: s(10),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
