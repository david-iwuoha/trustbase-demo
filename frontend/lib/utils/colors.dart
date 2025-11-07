import 'package:flutter/material.dart';

class TrustBaseColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF0F4C75);
  static const Color accentTeal = Color(0xFF3282B8);
  static const Color successGreen = Color(0xFF00D4AA);
  
  // Neutral Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  
  // Glassmorphism Colors
  static const Color glassBackground = Color.fromRGBO(255, 255, 255, 0.25);
  static const Color glassBorder = Color.fromRGBO(255, 255, 255, 0.18);
  static const Color glassShadow = Color.fromRGBO(31, 38, 135, 0.37);
  
  // Status Colors
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, accentTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color.fromRGBO(255, 255, 255, 0.25),
      Color.fromRGBO(255, 255, 255, 0.1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}