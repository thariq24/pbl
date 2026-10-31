import 'package:flutter/material.dart';

/// Helper class untuk membuat aplikasi responsive
/// Mendukung berbagai ukuran layar smartphone
class Responsive {
  /// Mendapatkan lebar layar
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Mendapatkan tinggi layar
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Mendapatkan padding atas dari safe area
  static double topPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Mendapatkan padding bawah dari safe area
  static double bottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Cek apakah layar adalah layar kecil (< 360px)
  static bool isSmallScreen(BuildContext context) {
    return screenWidth(context) < 360;
  }

  /// Cek apakah layar adalah layar medium (360px - 400px)
  static bool isMediumScreen(BuildContext context) {
    final width = screenWidth(context);
    return width >= 360 && width < 400;
  }

  /// Cek apakah layar adalah layar besar (>= 400px)
  static bool isLargeScreen(BuildContext context) {
    return screenWidth(context) >= 400;
  }

  /// Menghitung ukuran relatif terhadap lebar layar
  /// Baseline: 375px (iPhone SE/8)
  static double widthRatio(BuildContext context, double size) {
    final baseWidth = 375.0;
    return (screenWidth(context) / baseWidth) * size;
  }

  /// Menghitung ukuran relatif terhadap tinggi layar
  /// Baseline: 667px (iPhone SE/8)
  static double heightRatio(BuildContext context, double size) {
    final baseHeight = 667.0;
    return (screenHeight(context) / baseHeight) * size;
  }

  /// Padding horizontal standar sesuai ukuran layar
  static double horizontalPadding(BuildContext context) {
    if (isSmallScreen(context)) {
      return 16.0;
    } else if (isMediumScreen(context)) {
      return 20.0;
    } else {
      return 24.0;
    }
  }

  /// Padding vertikal standar sesuai ukuran layar
  static double verticalPadding(BuildContext context) {
    if (isSmallScreen(context)) {
      return 12.0;
    } else if (isMediumScreen(context)) {
      return 16.0;
    } else {
      return 20.0;
    }
  }

  /// Font size responsif
  static double fontSize(BuildContext context, double size) {
    if (isSmallScreen(context)) {
      return size * 0.9;
    } else if (isLargeScreen(context)) {
      return size * 1.05;
    } else {
      return size;
    }
  }

  /// Spacing responsif
  static double spacing(BuildContext context, double size) {
    if (isSmallScreen(context)) {
      return size * 0.85;
    } else {
      return size;
    }
  }
}
