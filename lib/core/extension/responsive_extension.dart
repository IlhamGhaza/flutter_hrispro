import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < 600;
  bool get isSmallTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isLargeTablet => screenWidth >= 900;

  // Adaptive values based on screen size
  double responsive(double mobile, double smallTablet, double largeTablet) {
    if (isLargeTablet) return largeTablet;
    if (isSmallTablet) return smallTablet;
    return mobile;
  }

  // Dynamic width scale based on a design width of 390
  double scaleW(double size) {
    double scale = screenWidth / 390;
    // Don't scale up infinitely on large tablets
    if (scale > 1.5) scale = 1.5;
    return size * scale;
  }

  // Dynamic text scale
  double scaleT(double size) {
    double scale = screenWidth / 390;
    if (scale > 1.25) scale = 1.25;
    return size * scale;
  }
}
