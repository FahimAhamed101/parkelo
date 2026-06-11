import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkealo/views/Feature/Driver/bottom_nav/bottom_nav.dart';

import '../../utils/appColor/app_colors.dart';
import '../../utils/appIcons/app_icons.dart';

class PublishFlowColors {
  static const Color blue = Color(0xFF1F59B8);
  static const Color blueDark = Color(0xFF174FA8);
  static const Color blueSoft = Color(0xFFEAF2FF);
  static const Color pageBg = Color(0xFFF3F7FC);
  static const Color border = Color(0xFFC7D8F1);
  static const Color muted = Color(0xFF6E82B2);
  static const Color hint = Color(0xFF9BAED0);
  static const Color ink = Color(0xFF07183D);
  static const Color green = Color(0xFF08934C);
  static const Color greenSoft = Color(0xFFE8FAF0);
}

class PublishFlowScaffold extends StatelessWidget {
  const PublishFlowScaffold({
    super.key,
    required this.currentStep,
    required this.stepTitle,
    required this.child,
    required this.onContinue,
    this.steps = PublishFlowHeader.defaultSteps,
    this.showBackAction = false,
    this.continueLabel = 'Continue ->',
    this.continueColor,
  });

  final int currentStep;
  final String stepTitle;
  final Widget child;
  final VoidCallback onContinue;
  final List<String> steps;
  final bool showBackAction;
  final String continueLabel;
  final Color? continueColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: PublishFlowColors.blueDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: PublishFlowColors.pageBg,
        body: Column(
          children: [
            PublishFlowHeader(
              currentStep: currentStep,
              stepTitle: stepTitle,
              steps: steps,
              onBack: () => _goBack(context),
            ),
            Expanded(child: child),
          ],
        ),
        bottomNavigationBar: PublishFlowFooter(
          showBackAction: showBackAction,
          continueLabel: continueLabel,
          onBack: () => _goBack(context),
          onContinue: onContinue,
          continueColor: continueColor,
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    if (showBackAction && currentStep > 0) {
      Navigator.pushReplacementNamed(
        context,
        PublishFlowHeader._stepRoutes[currentStep - 1],
      );
      return;
    }

    Navigator.maybePop(context);
  }
}

class PublishFlowHeader extends StatelessWidget {
  const PublishFlowHeader({
    super.key,
    required this.currentStep,
    required this.stepTitle,
    this.steps = defaultSteps,
    required this.onBack,
  });

  static const defaultSteps = [
    'Location',
    'Details',
    'Spaces',
    'Services',
    'Photos',
    'Prices',
    'Review',
  ];

  static const _stepRoutes = [
    '/publish-parking',
    '/publish-parking-details',
    '/publish-parking-spaces',
    '/publish-parking-services',
    '/publish-parking-photos',
    '/publish-parking-prices',
    '/publish-parking-review',
  ];

  final int currentStep;
  final String stepTitle;
  final List<String> steps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: PublishFlowColors.blueDark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 11, 0, 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: onBack,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Publish parking',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Step ${currentStep + 1} of ${steps.length} - $stepTitle',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final progress = ((currentStep + 1) / steps.length).clamp(
                      0.0,
                      1.0,
                    );

                    return Stack(
                      children: [
                        Container(
                          height: 3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        Container(
                          height: 3,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Row(
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      Expanded(
                        child: PublishStepPill(
                          label: steps[i],
                          isSelected: i == currentStep,
                          isComplete: i < currentStep,
                          onTap: () => _openStep(context, i),
                        ),
                      ),
                      if (i != steps.length - 1) const SizedBox(width: 5),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openStep(BuildContext context, int step) {
    if (step == currentStep || step < 0 || step >= _stepRoutes.length) return;

    Navigator.pushReplacementNamed(context, _stepRoutes[step]);
  }
}

class PublishStepPill extends StatelessWidget {
  const PublishStepPill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isComplete,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isComplete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? Colors.white : Colors.white.withValues(alpha: 0.16);
    final color = isSelected ? PublishFlowColors.blueDark : Colors.white;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isComplete) ...[
                  Icon(Icons.check_rounded, color: color, size: 10),
                  const SizedBox(width: 1),
                ],
                Text(
                  label,
                  maxLines: 1,
                  style: GoogleFonts.nunito(
                    color: color,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    height: 1,
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

class PublishFlowFooter extends StatelessWidget {
  const PublishFlowFooter({
    super.key,
    required this.showBackAction,
    required this.continueLabel,
    required this.onBack,
    required this.onContinue,
    this.continueColor,
  });

  final bool showBackAction;
  final String continueLabel;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final Color? continueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: PublishFlowColors.blue.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (showBackAction) ...[
                  Expanded(
                    flex: 3,
                    child: _FooterButton(
                      text: '<- Back',
                      onTap: onBack,
                      isPrimary: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  flex: showBackAction ? 5 : 1,
                  child: _FooterButton(
                    text: continueLabel,
                    onTap: onContinue,
                    isPrimary: true,
                    backgroundColor: continueColor,
                  ),
                ),
              ],
            ),
          ),
          const PublishFlowBottomNav(),
        ],
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.text,
    required this.onTap,
    required this.isPrimary,
    this.backgroundColor,
  });

  final String text;
  final VoidCallback onTap;
  final bool isPrimary;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: isPrimary ? 10 : 0,
          shadowColor: isPrimary
              ? PublishFlowColors.blue.withValues(alpha: 0.24)
              : Colors.transparent,
          backgroundColor: isPrimary
              ? backgroundColor ?? PublishFlowColors.blue
              : Colors.white,
          foregroundColor: isPrimary ? Colors.white : PublishFlowColors.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isPrimary
                  ? PublishFlowColors.blue
                  : PublishFlowColors.border,
            ),
          ),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class PublishFlowBottomNav extends StatelessWidget {
  const PublishFlowBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
          boxShadow: AppColors.bottomNavShadow,
        ),
        child: Row(
          children: [
            _NavItem(icon: AppIcons.explore, label: 'Explore', index: 0),
            _NavItem(icon: AppIcons.bookings, label: 'Bookings', index: 1),
            _NavItem(icon: AppIcons.favorites, label: 'Favorites', index: 2),
            _NavItem(icon: AppIcons.home, label: 'Host', index: 3),
            _NavItem(icon: AppIcons.account, label: 'Account', index: 4),
            const _NavItem(
              materialIcon: Icons.settings_outlined,
              label: 'Admin',
              index: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.index,
    this.icon,
    this.materialIcon,
  });

  final String? icon;
  final IconData? materialIcon;
  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == 3;
    final labelColor = isSelected ? AppColors.blue : AppColors.textFaint;
    final iconColor = isSelected ? Colors.white : AppColors.blue;

    final Widget iconWidget = materialIcon != null
        ? Icon(materialIcon, size: 19, color: iconColor)
        : SvgPicture.asset(
            icon!,
            height: 19,
            width: 19,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          );

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _goToTab(context, index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 29,
              height: 29,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: iconWidget,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: labelColor,
                fontSize: 8,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                height: 1,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isSelected ? 18 : 0,
              height: 3,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.gradGreenBar : null,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToTab(BuildContext context, int index) {
    if (index == 3) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/host_bottom_nav',
        (route) => false,
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => BottomNavScreen(initialIndex: index)),
      (route) => false,
    );
  }
}

class PublishFieldLabel extends StatelessWidget {
  const PublishFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.nunito(
        color: PublishFlowColors.muted,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        height: 1,
      ),
    );
  }
}

class PublishHintText extends StatelessWidget {
  const PublishHintText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        color: PublishFlowColors.hint,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
    );
  }
}

class PublishInputBox extends StatelessWidget {
  const PublishInputBox({
    super.key,
    required this.hint,
    this.initialValue,
    this.suffixIcon,
    this.keyboardType,
  });

  final String hint;
  final String? initialValue;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        style: GoogleFonts.nunito(
          color: PublishFlowColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(
            color: PublishFlowColors.hint,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          enabledBorder: _border(PublishFlowColors.border),
          focusedBorder: _border(PublishFlowColors.blue),
        ),
      ),
    );
  }
}

class PublishSelectBox extends StatelessWidget {
  const PublishSelectBox({super.key, required this.hint, this.value});

  final String hint;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasValue ? PublishFlowColors.blue : PublishFlowColors.border,
          width: hasValue ? 1.3 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasValue ? value! : hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: hasValue
                    ? PublishFlowColors.ink
                    : PublishFlowColors.hint,
                fontSize: 14,
                fontWeight: hasValue ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          Icon(
            hasValue ? Icons.close_rounded : Icons.keyboard_arrow_down_rounded,
            color: PublishFlowColors.hint,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class PublishTextArea extends StatelessWidget {
  const PublishTextArea({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: TextField(
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: GoogleFonts.nunito(
          color: PublishFlowColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(
            color: const Color(0xFF6F7D93),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
          enabledBorder: _border(PublishFlowColors.border),
          focusedBorder: _border(PublishFlowColors.blue),
        ),
      ),
    );
  }
}

OutlineInputBorder _border(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 1),
  );
}

class PublishMapPreview extends StatelessWidget {
  const PublishMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 132,
        decoration: const BoxDecoration(color: Color(0xFFEAF2FF)),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: _GridMapPainter()),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: PublishFlowColors.blue.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFFF2D8B),
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tap to place pin',
                      style: GoogleFonts.nunito(
                        color: PublishFlowColors.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 9,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Interactive map',
                  style: GoogleFonts.nunito(
                    color: PublishFlowColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    height: 1,
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

class _GridMapPainter extends CustomPainter {
  const _GridMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFD9E5F7)
      ..strokeWidth = 1;
    final roadPaint = Paint()
      ..color = const Color(0xFFBFD2F0)
      ..strokeWidth = 3;

    for (double x = 0; x <= size.width; x += size.width / 7) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += size.height / 5) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.36, 0),
      Offset(size.width * 0.36, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GridMapPainter oldDelegate) => false;
}

class ParkingPSquare extends StatelessWidget {
  const ParkingPSquare({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF64B7FF), PublishFlowColors.blue],
        ),
        borderRadius: BorderRadius.circular(size * 0.16),
      ),
      child: Text(
        'P',
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: size * 0.52,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  const DashedBorderPainter({
    required this.color,
    required this.radius,
    this.dashWidth = 6,
    this.gap = 4,
    this.strokeWidth = 1.6,
  });

  final Color color;
  final double radius;
  final double dashWidth;
  final double gap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
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
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
