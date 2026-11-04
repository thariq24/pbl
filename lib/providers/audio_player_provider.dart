import 'package:flutter/material.dart';

/// Provider untuk global audio player state
/// Digunakan untuk menampilkan mini audio player di halaman manapun
class AudioPlayerProvider extends ChangeNotifier {
  // Singleton pattern
  static final AudioPlayerProvider _instance = AudioPlayerProvider._internal();
  factory AudioPlayerProvider() => _instance;
  AudioPlayerProvider._internal();

  // Audio state
  bool _isVisible = false;
  bool _isPlaying = false;
  double _progress = 0.0;
  String _bookTitle = '';
  String _author = '';
  String? _coverImage;
  String _currentTime = '00:00';
  String _totalTime = '00:00';

  // Getters
  bool get isVisible => _isVisible;
  bool get isPlaying => _isPlaying;
  double get progress => _progress;
  String get bookTitle => _bookTitle;
  String get author => _author;
  String? get coverImage => _coverImage;
  String get currentTime => _currentTime;
  String get totalTime => _totalTime;

  /// Mulai memutar audio dan tampilkan mini player
  void playAudio({
    required String bookTitle,
    required String author,
    String? coverImage,
  }) {
    _bookTitle = bookTitle;
    _author = author;
    _coverImage = coverImage;
    _isVisible = true;
    _isPlaying = true;
    _progress = 0.0;
    notifyListeners();
  }

  /// Toggle play/pause
  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  /// Update progress
  void updateProgress(double progress) {
    _progress = progress.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Update time display
  void updateTime(String current, String total) {
    _currentTime = current;
    _totalTime = total;
    notifyListeners();
  }

  /// Next track
  void nextTrack() {
    // TODO: Implement next track logic
    _progress = 0.0;
    notifyListeners();
  }

  /// Previous track
  void previousTrack() {
    // TODO: Implement previous track logic
    _progress = 0.0;
    notifyListeners();
  }

  /// Stop dan sembunyikan mini player
  void stop() {
    _isVisible = false;
    _isPlaying = false;
    _progress = 0.0;
    notifyListeners();
  }

  /// Pause audio
  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  /// Resume audio
  void resume() {
    _isPlaying = true;
    notifyListeners();
  }

  /// Close mini player (tetap track di background)
  void closeMiniPlayer() {
    _isVisible = false;
    notifyListeners();
  }

  /// Show mini player kembali
  void showMiniPlayer() {
    _isVisible = true;
    notifyListeners();
  }
}
