import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _line = Color(0xFFDDE6F1);
const _green = Color(0xFF16A34A);

class PublishParkingPage extends StatelessWidget {
  const PublishParkingPage({super.key});

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
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
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
                    const SizedBox(height: 17),
                    const _FieldLabel('PARKING NAME OR HOST NAME *'),
                    const SizedBox(height: 7),
                    const _InputBox(
                      hint: "Example: Central Parking or Juan's House",
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'It can be your business name or simply your name if it is a residential parking.',
                      style: TextStyle(color: Color(0xFF9AA6B4), fontSize: 7.3),
                    ),
                    const SizedBox(height: 15),
                    const _FieldLabel('LOCATION *'),
                    const SizedBox(height: 8),
                    const _LocationObtainedCard(),
                    const SizedBox(height: 8),
                    const _MapPreview(),
                    const SizedBox(height: 16),
                    const _FieldLabel('EXACT ADDRESS *'),
                    const SizedBox(height: 7),
                    const _InputBox(hint: 'Street, number, building...'),
                    const SizedBox(height: 6),
                    const Text(
                      'Add references so users can find you easily',
                      style: TextStyle(color: Color(0xFF9AA6B4), fontSize: 7.3),
                    ),
                    const SizedBox(height: 15),
                    const _FieldLabel('SECTOR / ZONE *'),
                    const SizedBox(height: 7),
                    const _SelectBox(hint: 'Select a sector...'),
                    const SizedBox(height: 15),
                    const _FieldLabel('CONTACT PHONE NUMBER'),
                    const SizedBox(height: 7),
                    const _InputBox(hint: '+1 (809) 000-0000'),
                    const SizedBox(height: 15),
                    const _FieldLabel('INSTAGRAM (OPTIONAL)'),
                    const SizedBox(height: 7),
                    const _InputBox(hint: '@myparking'),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/publish-parking-details',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8EA6E8),
                          foregroundColor: Colors.white,
                          elevation: 9,
                          shadowColor: const Color(0x338EA6E8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward_rounded, size: 14),
                          ],
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
        color: Color(0xFF7C8797),
        fontSize: 8.8,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31,
      child: TextField(
        style: const TextStyle(color: _ink, fontSize: 10),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA7B6), fontSize: 9.2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: _border(_line),
          focusedBorder: _border(_primaryBlue),
        ),
      ),
    );
  }

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF9CA7B6), fontSize: 9.2),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF9CA7B6),
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _LocationObtainedCard extends StatelessWidget {
  const _LocationObtainedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.fromLTRB(14, 7, 10, 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F9EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Icon(Icons.my_location_rounded, color: _ink, size: 13),
          SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_rounded, color: _green, size: 12),
                    SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        'Location obtained',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _green,
                          fontSize: 10.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Av. Winston Churchill 1099, Piantini',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFF334155), fontSize: 8.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: 151,
        color: const Color(0xFFF4F4F1),
        child: Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: _MapPainter())),
            Positioned(
              top: 65,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFFFF2D8B),
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Tap to place pin',
                        style: TextStyle(
                          color: _primaryBlue,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 24,
              right: 4,
              child: Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: _primaryBlue,
                  size: 14,
                ),
              ),
            ),
            Positioned(
              right: 7,
              bottom: 43,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'INTERACTIVE MAP',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 6.3,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
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

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final park = Paint()..color = const Color(0xFFEAEDE8);
    final blocks = Paint()..color = const Color(0xFFF9F9F7);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final roadEdge = Paint()
      ..color = const Color(0xFFE2E5E9)
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final thinRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final thinEdge = Paint()
      ..color = const Color(0xFFE3E7EC)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final alleyRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final alleyEdge = Paint()
      ..color = const Color(0xFFE8EBEF)
      ..strokeWidth = 3.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(Offset.zero & size, blocks);
    canvas.drawOval(
      Rect.fromLTWH(-size.width * 0.32, 46, size.width * 0.82, 118),
      park,
    );

    void drawRoad(List<Offset> points, Paint edgePaint, Paint fillPaint) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, edgePaint);
      canvas.drawPath(path, fillPaint);
    }

    drawRoad(
      [
        Offset(size.width * 0.07, 25),
        Offset(size.width * 0.30, 20),
        Offset(size.width * 0.47, 13),
      ],
      alleyEdge,
      alleyRoad,
    );
    drawRoad(
      [
        Offset(size.width * 0.34, 23),
        Offset(size.width * 0.34, 61),
        Offset(size.width * 0.35, 91),
      ],
      alleyEdge,
      alleyRoad,
    );
    drawRoad(
      [
        Offset(size.width * 0.40, 58),
        Offset(size.width * 0.50, 54),
        Offset(size.width * 0.65, 51),
      ],
      alleyEdge,
      alleyRoad,
    );
    drawRoad(
      [
        Offset(size.width * 0.78, 44),
        Offset(size.width * 0.96, 43),
        Offset(size.width + 8, 45),
      ],
      alleyEdge,
      alleyRoad,
    );
    drawRoad(
      [
        Offset(size.width * 0.80, 82),
        Offset(size.width * 0.98, 80),
        Offset(size.width + 8, 78),
      ],
      alleyEdge,
      alleyRoad,
    );
    drawRoad(
      [
        Offset(size.width * 0.18, 146),
        Offset(size.width * 0.25, 114),
        Offset(size.width * 0.30, 82),
      ],
      alleyEdge,
      alleyRoad,
    );
    drawRoad(
      [
        Offset(-12, 109),
        Offset(size.width * 0.23, 94),
        Offset(size.width * 0.50, 81),
        Offset(size.width + 10, 72),
      ],
      roadEdge,
      road,
    );
    drawRoad(
      [
        Offset(size.width * 0.58, -8),
        Offset(size.width * 0.55, 38),
        Offset(size.width * 0.57, 82),
        Offset(size.width * 0.58, size.height + 8),
      ],
      roadEdge,
      road,
    );
    drawRoad(
      [
        Offset(size.width * 0.73, -8),
        Offset(size.width * 0.71, 36),
        Offset(size.width * 0.74, 88),
        Offset(size.width * 0.75, size.height + 8),
      ],
      thinEdge,
      thinRoad,
    );
    drawRoad(
      [
        Offset(-8, 58),
        Offset(size.width * 0.24, 49),
        Offset(size.width * 0.48, 40),
        Offset(size.width + 8, 29),
      ],
      thinEdge,
      thinRoad,
    );
    drawRoad(
      [
        Offset(12, size.height + 9),
        Offset(40, 115),
        Offset(53, 72),
        Offset(64, -8),
      ],
      thinEdge,
      thinRoad,
    );
    drawRoad(
      [
        Offset(-8, 133),
        Offset(size.width * 0.25, 126),
        Offset(size.width * 0.52, 114),
        Offset(size.width + 8, 105),
      ],
      thinEdge,
      thinRoad,
    );

    final labelStyle = TextStyle(
      color: const Color(0xFFA4ACB8),
      fontSize: size.width < 220 ? 5.8 : 6.4,
      fontWeight: FontWeight.w600,
    );

    void label(String text, Offset offset, [double turns = 0]) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(turns);
      painter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    label('Calle 5', const Offset(25, 41), -0.22);
    label('Calle 7', const Offset(18, 72), -0.20);
    label('Calle 9', const Offset(18, 126), -0.22);
    label('Winston Churchill', Offset(size.width * 0.58, 16), 1.56);
    label('Piantini', Offset(size.width * 0.73, 17), 1.56);
    label('Main St', Offset(size.width * 0.47, 91), -0.15);
    label('Av. 27', Offset(size.width * 0.12, 102), -1.22);
    label('Street 10', Offset(size.width * 0.78, 125), -0.10);
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => false;
}
