import 'package:flutter/material.dart';

class AppColors {
  // Brand & Primary
  static const Color primary = Color(0xFF5B3DE8);
  static const Color primaryDark = Color(0xFF4526D1);
  static const Color primaryLight = Color(0xFF7B61FF);

  // Backgrounds & Gradients
  static const Color backgroundTop = Color(0xFFF3EEFF);
  static const Color backgroundMiddle = Color(0xFFF8F5FF);
  static const Color backgroundBottom = Colors.white;

  static const LinearGradient screenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundTop,
      backgroundMiddle,
      backgroundBottom,
    ],
    stops: [0.0, 0.4, 1.0],
  );

  // Neutral & Surfaces
  static const Color surface = Colors.white;
  static const Color keypadButtonBg = Color(0xFFF3F0FE);
  static const Color inputFieldBg = Color(0xFFFFFFFF);
  static const Color borderSubtle = Color(0xFFE9E5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF19182C);
  static const Color textSecondary = Color(0xFF5C5B72);
  static const Color textMuted = Color(0xFF9E9CAF);
  static const Color textPlaceholder = Color(0xFFB5B3C7);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}
