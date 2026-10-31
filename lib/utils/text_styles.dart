import 'package:flutter/material.dart';
import 'color_palettes.dart';

/// Sistem typography konsisten untuk aplikasi BukuBicara
class AppTextStyles {
  // ==================== HEADINGS ====================

  /// Heading 1 - untuk judul besar/halaman utama (24-28px)
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.oxfordBlue,
    height: 1.3,
  );

  /// Heading 2 - untuk judul section (22-24px)
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.oxfordBlue,
    height: 1.3,
  );

  /// Heading 3 - untuk sub-section (19-20px)
  static const TextStyle h3 = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    color: AppColors.oxfordBlue,
    height: 1.4,
  );

  // ==================== TITLES ====================

  /// Title besar - untuk nama buku atau judul konten (20-22px)
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.oxfordBlue,
    height: 1.3,
  );

  /// Title medium - untuk judul card atau list item (16-18px)
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.oxfordBlue,
    height: 1.4,
  );

  /// Title small - untuk label atau caption title (14px)
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.oxfordBlue,
    height: 1.4,
  );

  // ==================== BODY TEXT ====================

  /// Body large - untuk konten utama (16px)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.oxfordBlue,
    height: 1.6,
  );

  /// Body medium - untuk teks standar (14-15px)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.oxfordBlue,
    height: 1.6,
  );

  /// Body small - untuk teks kecil (12-13px)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.oxfordBlue,
    height: 1.5,
  );

  // ==================== CAPTION & LABEL ====================

  /// Caption - untuk metadata, info tambahan (11-12px)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
    height: 1.4,
  );

  /// Label - untuk label form atau button (12-14px)
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.oxfordBlue,
    height: 1.3,
  );

  /// Label small - untuk hint text atau helper (11px)
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
    height: 1.4,
  );

  // ==================== BUTTON ====================

  /// Button text large - untuk button utama (16px)
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  /// Button text medium - untuk button standar (14-15px)
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  /// Button text small - untuk button kecil (12-13px)
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  // ==================== SPECIAL ====================

  /// Link text
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.blue,
    decoration: TextDecoration.underline,
    height: 1.4,
  );

  /// Error text
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.red,
    height: 1.4,
  );

  /// Hint text untuk input field
  static const TextStyle hint = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFF8B99B2),
    height: 1.3,
  );

  /// Author/creator name
  static const TextStyle authorName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
    height: 1.4,
  );

  /// Price text
  static const TextStyle price = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    color: AppColors.oxfordBlue,
    height: 1.3,
  );
}
