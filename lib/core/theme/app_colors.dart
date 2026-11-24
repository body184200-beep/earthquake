import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF0284C7);
  static const Color primaryDark = Color(0xFF38BDF8);

  // Background colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0B1120);

  // Card colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  // Border colors
  static final Color borderLight = Colors.grey.shade200;
  static const Color borderDark = Color(0xFF334155);

  // Severity colors
  static const Color severityMicro = Color(0xFF10B981); // Emerald (< 2.5)
  static const Color severityMinor = Color(0xFF0EA5E9); // Sky blue (2.5 - 3.9)
  static const Color severityLight = Color(0xFFEAB308); // Amber (4.0 - 4.9)
  static const Color severityModerate = Color(0xFFF97316); // Orange (5.0 - 5.9)
  static const Color severityStrong = Color(0xFFEF4444); // Red (6.0 - 6.9)
  static const Color severitySevere = Color(0xFF881337); // Crimson/Burgundy (>= 7.0)

  static Color getMagnitudeColor(double mag) {
    if (mag < 2.5) return severityMicro;
    if (mag < 4.0) return severityMinor;
    if (mag < 5.0) return severityLight;
    if (mag < 6.0) return severityModerate;
    if (mag < 7.0) return severityStrong;
    return severitySevere;
  }
}
