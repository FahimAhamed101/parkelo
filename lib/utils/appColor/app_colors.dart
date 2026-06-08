// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppColors {
  // Parkealo design tokens from the reference PDF.
  static const Color blue = Color(0xFF1A56C4);
  static const Color blueNav = Color(0xFF0D2D6B);
  static const Color blueDk = Color(0xFF0F3A8C);
  static const Color blueLt = Color(0xFFEEF3FC);
  static const Color blueMid = Color(0xFFC8D9F5);
  static const Color blueSky = Color(0xFF3B7EE8);

  static const Color green = Color(0xFF0B8A4C);
  static const Color greenDk = Color(0xFF076336);
  static const Color greenLt = Color(0xFFE8F8F0);
  static const Color greenMid = Color(0xFFA8DDBF);
  static const Color greenAcct = Color(0xFF10B46A);

  static const Color bg = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF6F8FB);
  static const Color surface2 = Color(0xFFECEFF5);
  static const Color border = Color(0xFFE0E8F0);
  static const Color borderMd = Color(0xFFC2D0E4);

  static const Color text = Color(0xFF0D1B3E);
  static const Color textMid = Color(0xFF2D4070);
  static const Color textSub = Color(0xFF5E78A8);
  static const Color textFaint = Color(0xFF9BAFD0);

  static const Color danger = Color(0xFFB8172A);
  static const Color dangerBg = Color(0xFFFEF0F2);
  static const Color dangerBd = Color(0xFFF5C0C7);
  static const Color warn = Color(0xFF8A6200);
  static const Color warnBg = Color(0xFFFFF8E6);
  static const Color warnBd = Color(0xFFF0D080);

  static const Color orange = Color(0xFFEA580C);
  static const Color purple = Color(0xFF7C3AED);
  static const Color amber = Color(0xFFF59E0B);
  static const Color heartRed = Color(0xFFFF6B6B);
  static const Color lightGreen = Color(0xFF4ADE80);
  static const Color starYellow = Color(0xFFFACC15);
  static const Color outerBg = Color(0xFFD6DCE8);
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color nightDark = Color(0xFF1A1A2E);
  static const Color nightMid = Color(0xFF16213E);
  static const Color cardBlue1 = Color(0xFF1E5BB8);
  static const Color cardBlue2 = Color(0xFF2A73D5);

  static const LinearGradient gradHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blueNav, blue, blueSky],
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient gradGreenBar = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [green, greenAcct],
  );

  static const LinearGradient gradPublic = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBlue1, cardBlue2],
  );

  static const LinearGradient gradPrivate = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blueNav, blue],
  );

  static const LinearGradient gradHighlight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blueLt, Color(0xFFDDE8F8)],
  );

  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: blue.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadow => [
    BoxShadow(
      color: blue.withValues(alpha: 0.11),
      blurRadius: 14,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: blue.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: blue.withValues(alpha: 0.18),
      blurRadius: 40,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get bottomNavShadow => [
    BoxShadow(
      color: blue.withValues(alpha: 0.07),
      blurRadius: 16,
      offset: const Offset(0, -2),
    ),
  ];

  // Legacy aliases kept for existing screens.
  static const Color buttonColor = blue;
  static const Color bgPrimary = bg;
  static const Color textColor = blueLt;
  static const Color secondaryTextColor = textSub;
  static const Color DarkBlue = blue;

  static const Color Primary = blue;
  static const Color LightBlue = blueLt;
  static const Color Black = text;
  static const Color DarkGray = textFaint;
  static const Color LightGray = surface2;
  static const Color White = bg;
  static const Color Yellow = starYellow;
  static const Color LightYellow = warnBg;
  static const Color Orange = orange;

  static const Color LightOrange = warnBg;
  static const Color Red = danger;
  static const Color Green = green;
  static const Color LightRed = dangerBg;
  static const Color LightGreen = greenLt;
  static const Color PrimaryBackgroundAiry = surface;
  static const Color Airy = surface;
  static const Color RED = danger;
  static const Color Hover = surface2;

  static const Color DarkThemeBackground = nightDark;
  static const Color DarkThemeSurface = nightMid;
  static const Color DarkThemeOnSurface = Color(0xFFE0E8F0);
  static const Color DarkThemeOnBackground = Color(0xFFE0E8F0);
  static const Color DarkThemeAppBar = nightDark;
  static const Color DarkThemeCard = nightMid;
  static const Color DarkThemeText = Color(0xFFE0E8F0);
  static const Color DarkThemeSecondaryText = textFaint;
  static const Color DarkThemeDivider = Color(0xFF2D4070);
}
