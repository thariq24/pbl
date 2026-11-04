import 'package:flutter/material.dart';
import '../providers/audio_player_provider.dart';
import 'mini_audio_player.dart';

/// Overlay wrapper untuk menampilkan mini audio player di halaman manapun
/// Wrap halaman dengan widget ini untuk enable mini player
/// 
/// Mini player akan muncul DI ATAS bottom navigation, tidak menutupinya.
/// 
/// Usage:
/// ```dart
/// AudioPlayerOverlay(
///   child: YourScreen(),
/// )
/// ```
class AudioPlayerOverlay extends StatelessWidget {
  final Widget child;

  const AudioPlayerOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AudioPlayerProvider(),
      builder: (context, _) {
        final provider = AudioPlayerProvider();

        return Stack(
          children: [
            // Main content
            child,

            // Mini audio player overlay (positioned di atas bottom nav)
            if (provider.isVisible)
              MiniAudioPlayer(
                bookTitle: provider.bookTitle,
                author: provider.author,
                coverImage: provider.coverImage,
                isPlaying: provider.isPlaying,
                progress: provider.progress,
                onPlayPause: () => provider.togglePlayPause(),
                onNext: () => provider.nextTrack(),
                onPrevious: () => provider.previousTrack(),
                onClose: () => provider.stop(),
              ),
          ],
        );
      },
    );
  }
}
