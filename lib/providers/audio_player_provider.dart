
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerProvider extends ChangeNotifier {
  static final AudioPlayerProvider _instance =
      AudioPlayerProvider._internal();

  factory AudioPlayerProvider() => _instance;

  AudioPlayerProvider._internal() {
    _player.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _player.durationStream.listen((duration) {
      _totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });

    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;

      _isLoading =
          state.processingState == ProcessingState.loading;

      _isBuffering =
          state.processingState == ProcessingState.buffering;

      if (state.processingState == ProcessingState.completed) {
        _position = _totalDuration;
        _isPlaying = false;
      }

      notifyListeners();
    });
  }

  final AudioPlayer _player = AudioPlayer();

  String _bookTitle = '';
  String _author = '';
  String? _coverImage;
  String? _audioUrl;

  bool _isVisible = false;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isBuffering = false;

  String? _errorMessage;

  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;

  double _speed = 1.0;

  // Interval skip audio.
  int _skipInterval = 15;

  // Getters.
  String get bookTitle => _bookTitle;
  String get author => _author;
  String? get coverImage => _coverImage;
  String? get audioUrl => _audioUrl;

  bool get isVisible => _isVisible;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get isBuffering => _isBuffering;

  String? get errorMessage => _errorMessage;

  bool get hasActiveTrack => _bookTitle.isNotEmpty;

  Duration get position => _position;
  Duration get totalDuration => _totalDuration;

  double get speed => _speed;

  int get skipInterval => _skipInterval;

  double get progress {
    if (_totalDuration.inMilliseconds <= 0) {
      return 0.0;
    }

    return (_position.inMilliseconds /
            _totalDuration.inMilliseconds)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  String get currentTime => _formatDuration(_position);
  String get totalTime => _formatDuration(_totalDuration);

  // Memuat dan memutar audio.
  Future<void> playAudio({
    required String bookTitle,
    required String author,
    String? coverImage,
    String? audioUrl,
    String? audioAsset,
    String totalTime = '00:00',
  }) async {
    final normalizedUrl = audioUrl?.trim();
    final normalizedAsset = audioAsset?.trim();

    if ((normalizedUrl == null || normalizedUrl.isEmpty) &&
        (normalizedAsset == null || normalizedAsset.isEmpty)) {
      _errorMessage = 'Sumber audio belum tersedia.';
      _isPlaying = false;
      notifyListeners();
      return;
    }

    _bookTitle = bookTitle;
    _author = author;
    _coverImage = coverImage;
    _audioUrl = normalizedUrl;

    _position = Duration.zero;
    _totalDuration = Duration.zero;

    _isVisible = true;
    _isLoading = true;
    _isBuffering = false;
    _isPlaying = false;
    _errorMessage = null;

    notifyListeners();

    try {
      if (normalizedUrl != null && normalizedUrl.isNotEmpty) {
        await _player.setUrl(normalizedUrl);
      } else {
        await _player.setAsset(normalizedAsset!);
      }

      _totalDuration = _player.duration ?? Duration.zero;
      _position = Duration.zero;
      _isLoading = false;

      notifyListeners();

      unawaited(_player.play());
    } catch (e) {
      _isLoading = false;
      _isPlaying = false;
      _errorMessage = 'Gagal memuat audio: $e';

      notifyListeners();
    }
  }

  // Play / Pause.
  Future<void> togglePlayPause() async {
    if (!hasActiveTrack) return;

    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> pause() async {
    if (!hasActiveTrack || !_isPlaying) return;

    await _player.pause();
  }

  Future<void> resume() async {
    if (!hasActiveTrack || _isPlaying) return;

    _isVisible = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await _player.play();
    } catch (e) {
      _errorMessage = 'Gagal melanjutkan audio: $e';
      notifyListeners();
    }
  }

  // Mengubah posisi audio.
  Future<void> seek(Duration position) async {
    if (!hasActiveTrack) return;

    final target = Duration(
      milliseconds: position.inMilliseconds
          .clamp(0, _totalDuration.inMilliseconds),
    );

    await _player.seek(target);
  }

  // Skip mundur sesuai interval yang dipilih.
  Future<void> skipBackward() async {
    if (!hasActiveTrack) return;

    await seek(
      _position - Duration(seconds: _skipInterval),
    );
  }

  // Skip maju sesuai interval yang dipilih.
  Future<void> skipForward() async {
    if (!hasActiveTrack) return;

    await seek(
      _position + Duration(seconds: _skipInterval),
    );
  }

  // Mengatur interval skip.
  void setSkipInterval(int value) {
    const availableIntervals = [5, 10, 15, 30];

    if (!availableIntervals.contains(value)) return;
    if (_skipInterval == value) return;

    _skipInterval = value;
    notifyListeners();
  }

  // Kompatibilitas dengan slider 0.0 - 1.0.
  void updateProgress(double value) {
    if (!hasActiveTrack) return;
    if (_totalDuration.inMilliseconds <= 0) return;

    final normalized = value.clamp(0.0, 1.0).toDouble();

    final target = Duration(
      milliseconds:
          (_totalDuration.inMilliseconds * normalized).round(),
    );

    unawaited(seek(target));
  }

  // Mengatur kecepatan pemutaran.
  Future<void> setSpeed(double value) async {
    if (value <= 0) return;

    _speed = value;
    await _player.setSpeed(value);

    notifyListeners();
  }

  // Metode lama dipertahankan sementara untuk kompatibilitas.
  Future<void> nextTrack() async {
    if (!hasActiveTrack) return;
    await seek(Duration.zero);
  }

  Future<void> previousTrack() async {
    if (!hasActiveTrack) return;
    await seek(Duration.zero);
  }

  // Menyembunyikan mini player tanpa menghentikan audio.
  void closeMiniPlayer() {
    if (!_isVisible) return;

    _isVisible = false;
    notifyListeners();
  }

  void showMiniPlayer() {
    if (!hasActiveTrack || _isVisible) return;

    _isVisible = true;
    notifyListeners();
  }

  // Menghentikan audio dan mengosongkan sesi.
  Future<void> stop() async {
    await _player.stop();

    _bookTitle = '';
    _author = '';
    _coverImage = null;
    _audioUrl = null;

    _isVisible = false;
    _isPlaying = false;
    _isLoading = false;
    _isBuffering = false;

    _errorMessage = null;

    _position = Duration.zero;
    _totalDuration = Duration.zero;

    notifyListeners();
  }

  String _formatDuration(Duration duration) {
    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');

    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    final hours = duration.inHours;

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }
}
