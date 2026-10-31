/// Kumpulan fungsi validasi untuk form aplikasi BukuBicara
/// Semua pesan error menggunakan Bahasa Indonesia
class Validators {
  /// Validasi email
  /// Return null jika valid, return pesan error jika tidak valid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    // Trim whitespace
    value = value.trim();

    // Pattern email sederhana tapi cukup ketat
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Validasi password
  /// Minimal 8 karakter
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    return null;
  }

  /// Validasi password dengan persyaratan lebih ketat
  /// Minimal 8 karakter, harus ada huruf dan angka
  static String? validatePasswordStrong(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    // Cek apakah ada huruf
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password harus mengandung huruf';
    }

    // Cek apakah ada angka
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung angka';
    }

    return null;
  }

  /// Validasi konfirmasi password
  /// Bandingkan dengan password asli
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  /// Validasi nama (untuk first name atau last name)
  /// Minimal 2 karakter, tidak boleh hanya spasi
  static String? validateName(String? value, {String fieldName = 'Nama'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    // Trim dan cek apakah setelah trim masih ada isi
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '$fieldName tidak boleh hanya spasi';
    }

    if (trimmed.length < 2) {
      return '$fieldName minimal 2 karakter';
    }

    return null;
  }

  /// Validasi first name
  static String? validateFirstName(String? value) {
    return validateName(value, fieldName: 'Nama depan');
  }

  /// Validasi last name
  static String? validateLastName(String? value) {
    return validateName(value, fieldName: 'Nama belakang');
  }

  /// Validasi username
  /// Minimal 3 karakter, hanya huruf, angka, underscore, dan dash
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }

    final trimmed = value.trim();

    if (trimmed.length < 3) {
      return 'Username minimal 3 karakter';
    }

    // Hanya boleh huruf, angka, underscore, dan dash
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(trimmed)) {
      return 'Username hanya boleh huruf, angka, underscore, dan dash';
    }

    return null;
  }

  /// Validasi input tidak boleh kosong (generic)
  static String? validateNotEmpty(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.trim().isEmpty) {
      return '$fieldName tidak boleh hanya spasi';
    }

    return null;
  }

  /// Validasi nomor telepon Indonesia
  /// Format: 08xx atau +628xx atau 628xx
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    // Hapus spasi dan tanda dash
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    // Minimal 10 digit, maksimal 15 digit
    if (cleaned.length < 10 || cleaned.length > 15) {
      return 'Nomor telepon tidak valid';
    }

    // Cek format Indonesia
    if (!RegExp(r'^(\+?62|0)8[0-9]+$').hasMatch(cleaned)) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  /// Validasi panjang teks minimal
  static String? validateMinLength(
    String? value,
    int minLength, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }

    return null;
  }

  /// Validasi panjang teks maksimal
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return null; // Kosong dianggap valid untuk max length
    }

    if (value.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }

    return null;
  }

  /// Validasi angka (harus berupa angka)
  static String? validateNumber(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (int.tryParse(value) == null && double.tryParse(value) == null) {
      return '$fieldName harus berupa angka';
    }

    return null;
  }
}
