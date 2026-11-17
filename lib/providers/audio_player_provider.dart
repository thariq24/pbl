import 'package:flutter/foundation.dart';

/// Mengelola satu sesi audio yang digunakan bersama oleh:
/// - MiniAudioPlayer
/// - AudioPlayerScreen
///
/// Catatan:
/// Provider ini masih berupa simulasi. Belum terhubung ke audio engine,
/// ElevenLabs API, atau Firebase.
class AudioPlayerProvider extends ChangeNotifier {
  // Singleton agar seluruh bagian aplikasi mengakses sesi audio yang sama.
  static final AudioPlayerProvider _instance =
      AudioPlayerProvider._internal();

  factory AudioPlayerProvider() => _instance;

  AudioPlayerProvider._internal();

  // Metadata track
  String _bookTitle = '';
  String _author = '';
  String? _coverImage;

  // Status pemutaran
  bool _isVisible = false;
  bool _isPlaying = false;

  // Progress dan durasi
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Getters
  String get bookTitle => _bookTitle;
  String get author => _author;
  String? get coverImage => _coverImage;

  bool get isVisible => _isVisible;
  bool get isPlaying => _isPlaying;

  bool get hasActiveTrack => _bookTitle.isNotEmpty;

  Duration get position => _position;
  Duration get totalDuration => _totalDuration;

  double get progress {
    if (_totalDuration.inMilliseconds <= 0) return 0.0;

    return (_position.inMilliseconds / _totalDuration.inMilliseconds)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  String get currentTime => _formatDuration(_position);
  String get totalTime => _formatDuration(_totalDuration);

  /// Memulai sesi audio baru.
  ///
  /// totalTime menggunakan format:
  /// - mm:ss, contoh: 10:10
  /// - hh:mm:ss, contoh: 01:10:10
  void playAudio({
    required String bookTitle,
    required String author,
    String? coverImage,
    String totalTime = '00:00',
  }) {
    _bookTitle = bookTitle;
    _author = author;
    _coverImage = coverImage;

    _totalDuration = _parseDuration(totalTime);
    _position = Duration.zero;

    _isVisible = true;
    _isPlaying = true;

    notifyListeners();
  }

  /// Mengubah status play/pause.
  void togglePlayPause() {
    if (!hasActiveTrack) return;

    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void pause() {
    if (!hasActiveTrack || !_isPlaying) return;

    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    if (!hasActiveTrack || _isPlaying) return;

    _isPlaying = true;
    _isVisible = true;
    notifyListeners();
  }

  /// Mengubah progress dari 0.0 sampai 1.0.
  ///
  /// Contoh:
  /// updateProgress(0.5) berarti posisi audio berada di tengah durasi.
  void updateProgress(double value) {
    if (!hasActiveTrack) return;

    final normalizedProgress = value.clamp(0.0, 1.0).toDouble();

    if (_totalDuration.inMilliseconds <= 0) {
      _position = Duration.zero;
    } else {
      _position = Duration(
        milliseconds:
            (_totalDuration.inMilliseconds * normalizedProgress).round(),
      );
    }

    notifyListeners();
  }

  /// Memperbarui posisi dan durasi secara langsung.
  ///
  /// Berguna jika nantinya audio engine memberikan posisi aktual.
  void updateTime(String current, String total) {
    if (!hasActiveTrack) return;

    _totalDuration = _parseDuration(total);
    _position = _parseDuration(current);

    if (_totalDuration.inMilliseconds > 0 &&
        _position > _totalDuration) {
      _position = _totalDuration;
    }

    notifyListeners();
  }

  /// Placeholder untuk fitur next track.
  /// Belum mengganti buku karena playlist belum diimplementasikan.
  void nextTrack() {
    if (!hasActiveTrack) return;

    _position = Duration.zero;
    notifyListeners();
  }

  /// Placeholder untuk fitur previous track.
  /// Belum mengganti buku karena playlist belum diimplementasikan.
  void previousTrack() {
    if (!hasActiveTrack) return;

    _position = Duration.zero;
    notifyListeners();
  }

  /// Menyembunyikan Mini Player tanpa menghentikan sesi audio.
  void closeMiniPlayer() {
    if (!_isVisible) return;

    _isVisible = false;
    notifyListeners();
  }

  /// Menampilkan kembali Mini Player jika ada sesi audio.
  void showMiniPlayer() {
    if (!hasActiveTrack || _isVisible) return;

    _isVisible = true;
    notifyListeners();
  }

  /// Menghentikan dan membersihkan seluruh sesi audio.
  void stop() {
    _bookTitle = '';
    _author = '';
    _coverImage = null;

    _isVisible = false;
    _isPlaying = false;

    _position = Duration.zero;
    _totalDuration = Duration.zero;

    notifyListeners();
  }

  Duration _parseDuration(String value) {
    final parts = value.split(':');

    try {
      final numbers = parts.map((part) => int.parse(part)).toList();

      if (numbers.length == 2) {
        // mm:ss
        return Duration(
          minutes: numbers[0],
          seconds: numbers[1],
        );
      }

      if (numbers.length == 3) {
        // hh:mm:ss
        return Duration(
          hours: numbers[0],
          minutes: numbers[1],
          seconds: numbers[2],
        );
      }
    } catch (_) {
      // Format tidak valid akan dianggap sebagai 00:00.
    }

    return Duration.zero;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final hh = hours.toString().padLeft(2, '0');
      return '$hh:$mm:$ss';
    }

    return '${duration.inMinutes.toString().padLeft(2, '0')}:$ss';
  }
}