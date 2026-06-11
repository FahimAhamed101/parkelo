import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  late MobileScannerController _controller;
  double _zoomValue = 0.0;
  bool _hasScanned = false;
  String? _scannedCode;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final code = barcode.rawValue!;
        setState(() => _hasScanned = true);
        _scannedCode = code;
        _controller.stop();

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
                const SizedBox(width: 8),
                AppText("Scanned!", fontSize: 18, fontWeight: FontWeight.bold),
              ],
            ),
            content: AppText(
              "Code: $code",
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.back(result: _scannedCode);
                },
                child: AppText("Confirm", fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.Primary),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _hasScanned = false);
                  _controller.start();
                },
                child: AppText("Scan Again", fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(title: "Scanning"),
      body: Stack(
        children: [
          // Camera Preview
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Dark overlay with transparent cutout
          _buildOverlay(),

          // Top instruction text
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: AppText(
                "scan for auto fill your Reservation",
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),

          // Scanner Frame Corners
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                children: [
                  _buildCorner(top: 0, left: 0, borderTop: true, borderLeft: true),
                  _buildCorner(top: 0, right: 0, borderTop: true, borderRight: true),
                  _buildCorner(bottom: 0, left: 0, borderBottom: true, borderLeft: true),
                  _buildCorner(bottom: 0, right: 0, borderBottom: true, borderRight: true),
                ],
              ),
            ),
          ),

          // Zoom Slider
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    double newVal = (_zoomValue - 0.1).clamp(0.0, 1.0);
                    setState(() => _zoomValue = newVal);
                    _controller.setZoomScale(newVal);
                  },
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.Primary,
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                      thumbColor: AppColors.Primary,
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _zoomValue,
                      onChanged: (val) {
                        setState(() => _zoomValue = val);
                        _controller.setZoomScale(val);
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    double newVal = (_zoomValue + 0.1).clamp(0.0, 1.0);
                    setState(() => _zoomValue = newVal);
                    _controller.setZoomScale(newVal);
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the dark overlay with a transparent rectangular cutout in the center
  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scanArea = 250.0;
        final left = (constraints.maxWidth - scanArea) / 2;
        final top = (constraints.maxHeight - scanArea) / 2;

        return Stack(
          children: [
            // Top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: top,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
            // Bottom
            Positioned(
              top: top + scanArea,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
            // Left
            Positioned(
              top: top,
              left: 0,
              width: left,
              height: scanArea,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
            // Right
            Positioned(
              top: top,
              right: 0,
              width: left,
              height: scanArea,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ],
        );
      },
    );
  }

  /// Builds a single corner bracket
  Widget _buildCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool borderTop = false,
    bool borderBottom = false,
    bool borderLeft = false,
    bool borderRight = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: borderTop ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            bottom: borderBottom ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            left: borderLeft ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            right: borderRight ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
