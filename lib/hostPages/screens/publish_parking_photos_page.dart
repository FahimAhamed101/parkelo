import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _actionBlue = Color(0xFF0A8BFF);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF9AA6B4);

class PublishParkingPhotosPage extends StatelessWidget {
  const PublishParkingPhotosPage({super.key});

  static const _tabs = ['Location', 'Details', 'Spaces', 'Services', 'Photos'];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryBlue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _pageBg,
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        body: Column(
          children: [
            _PublishHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(7, 16, 7, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < _tabs.length; i++) ...[
                          Expanded(
                            child: _StepPill(
                              label: _tabs[i],
                              isSelected: i == 0,
                            ),
                          ),
                          if (i != _tabs.length - 1) const SizedBox(width: 5),
                        ],
                      ],
                    ),
                    const SizedBox(height: 11),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        'PARKING PHOTOS',
                        style: TextStyle(
                          color: Color(0xFF7C8797),
                          fontSize: 8.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.fromLTRB(6, 0, 6, 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: const [
                          _PhotoGrid(),
                          SizedBox(height: 25),
                          _TipsPanel(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 31,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/publish-parking-review',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _actionBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PublishHeader extends StatelessWidget {
  const _PublishHeader({required this.onBack});

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
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 17),
          child: SizedBox(
            height: 42,
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 42,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Publish parking',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
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

class _StepPill extends StatelessWidget {
  const _StepPill({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? _primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _primaryBlue, width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: isSelected ? Colors.white : _ink,
              fontSize: 8.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 9,
      childAspectRatio: 1.18,
      children: const [
        _PhotoSlot(isCover: true),
        _PhotoSlot(),
        _PhotoSlot(),
        _PhotoSlot(),
      ],
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({this.isCover = false});

  final bool isCover;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCover ? const Color(0xFFF8FBFF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: isCover
            ? null
            : Border.all(color: const Color(0xFFE7EDF5), width: 1),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: isCover ? _actionBlue : const Color(0xFFB8C3D2),
                  size: 17,
                ),
                const SizedBox(height: 3),
                Text(
                  isCover ? 'Main photo' : 'Add photo',
                  style: TextStyle(
                    color: isCover ? _actionBlue : _muted,
                    fontSize: 8.4,
                    fontWeight: isCover ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isCover)
            Positioned(
              top: 7,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 13,
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _primaryBlue,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'COVER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 6.3,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (!isCover) {
      return child;
    }

    return CustomPaint(
      painter: const _DashedBorderPainter(
        color: _actionBlue,
        radius: 8,
        dashWidth: 4,
        gap: 3,
      ),
      child: child,
    );
  }
}

class _TipsPanel extends StatelessWidget {
  const _TipsPanel();

  static const _tips = [
    'Photograph in natural daylight',
    'Show the entrance and the spaces',
    'Include visible signage',
    'At least 3 photos improve conversions by 60%',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips for better photos:',
            style: TextStyle(
              color: _ink,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 11),
          for (final tip in _tips) ...[
            _TipRow(text: tip),
            const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            color: _actionBlue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF49739E),
              fontSize: 7.8,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.dashWidth,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double dashWidth;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.gap != gap;
  }
}
