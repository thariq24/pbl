
import 'dart:async';

import 'package:flutter/material.dart';

import '../../providers/audio_player_provider.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/app_constants.dart';
import 'pengaturan_audio_screen.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayerProvider _audioProvider = AudioPlayerProvider();

  // Konten masih berupa placeholder.
  // Sinkronisasi teks dengan audio akan dibuat pada tahap berikutnya.
  final List<String> bookContent = [
    'Tak ada yang lebih tabah dari hujan bulan Juni dirahasiakannya rintik rindunya kepada pohon berbunga itu.',
    'Tak ada yang lebih bijak dari hujan bulan Juni dihapusnya jejak-jejak kakinya yang ragu-ragu di jalan itu.',
    'Tak ada yang lebih arif dari hujan bulan Juni dibiarkannya yang tak terucapkan diserap akar pohon bunga itu.',
  ];

  int highlightedParagraph = 1;

  void _togglePlayPause() {
    unawaited(_audioProvider.togglePlayPause());
  }

  void _onProgressChanged(double value) {
    _audioProvider.updateProgress(value);
  }

  void _skipBackward() {
    unawaited(_audioProvider.skipBackward());
  }

  void _skipForward() {
    unawaited(_audioProvider.skipForward());
  }

  void _showPlaylist() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daftar bab belum tersedia.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PengaturanAudioScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _audioProvider,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.lavender,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),

                Expanded(
                  child: _buildBookContentArea(),
                ),

                _buildMiniAudioPlayer(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingNormal,
        vertical: AppConstants.paddingMedium,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: AppColors.oxfordBlue,
              onPressed: () => Navigator.pop(context),
            ),
          ),

          const SizedBox(width: AppConstants.spaceMedium),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _audioProvider.bookTitle,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.oxfordBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.spaceXSmall),
                Text(
                  _audioProvider.author,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.spaceCadet,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(
              AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.jordyBlue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(
                AppConstants.radiusMedium,
              ),
            ),
            child: const Icon(
              Icons.headphones,
              color: AppColors.yinMnBlue,
              size: AppConstants.iconXLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookContentArea() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingNormal,
      ),
      padding: const EdgeInsets.all(
        AppConstants.paddingLarge,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0E8),
        borderRadius: BorderRadius.circular(
          AppConstants.radiusXLarge,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.volume_up,
                  color: AppColors.yinMnBlue.withValues(alpha: 0.3),
                  size: AppConstants.iconLarge,
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spaceNormal),

            ...bookContent.asMap().entries.map((entry) {
              final idx = entry.key;
              final paragraph = entry.value;
              final isHighlighted = idx == highlightedParagraph;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.spaceNormal,
                ),
                child: Text.rich(
                  TextSpan(
                    text: paragraph,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.black,
                      height: 1.8,
                      backgroundColor: isHighlighted
                          ? AppColors.jordyBlue.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniAudioPlayer() {
    final progress = _audioProvider.progress;

    return Container(
      margin: const EdgeInsets.all(
        AppConstants.paddingNormal,
      ),
      padding: const EdgeInsets.all(
        AppConstants.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.spaceCadet,
        borderRadius: BorderRadius.circular(
          AppConstants.radiusXLarge,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildCover(),

              const SizedBox(width: AppConstants.spaceMedium),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _audioProvider.bookTitle,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: AppConstants.spaceXSmall,
                    ),
                    Text(
                      _audioProvider.author,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.jordyBlue,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.settings),
                color: AppColors.jordyBlue,
                iconSize: AppConstants.iconMedium,
                onPressed: _openSettings,
              ),
            ],
          ),

          if (_audioProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _audioProvider.errorMessage!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: AppConstants.spaceMedium),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tombol mundur sesuai interval.
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Mundur ${_audioProvider.skipInterval} detik',
                    icon: const Icon(Icons.fast_rewind_rounded),
                    color: AppColors.white,
                    iconSize: AppConstants.iconLarge,
                    onPressed: _skipBackward,
                  ),
                ],
              ),

              const SizedBox(width: AppConstants.spaceSmall),

              // Tombol Play/Pause.
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.yinMnBlue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _audioProvider.isLoading ||
                            _audioProvider.isBuffering
                        ? Icons.hourglass_empty
                        : _audioProvider.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                  ),
                  color: AppColors.white,
                  iconSize: AppConstants.iconXLarge,
                  onPressed: _audioProvider.isLoading
                      ? null
                      : _togglePlayPause,
                ),
              ),

              const SizedBox(width: AppConstants.spaceSmall),

              // Tombol maju sesuai interval.
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Maju ${_audioProvider.skipInterval} detik',
                    icon: const Icon(Icons.fast_forward_rounded),
                    color: AppColors.white,
                    iconSize: AppConstants.iconLarge,
                    onPressed: _skipForward,
                  ),
                ],
              ),

              const SizedBox(width: AppConstants.spaceMedium),

              // Tombol playlist.
              IconButton(
                icon: const Icon(Icons.playlist_play),
                color: AppColors.jordyBlue,
                iconSize: AppConstants.iconLarge,
                onPressed: _showPlaylist,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spaceSmall),

          Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 12,
                  ),
                  activeTrackColor: AppColors.jordyBlue,
                  inactiveTrackColor: AppColors.oxfordBlue,
                  thumbColor: AppColors.white,
                  overlayColor: AppColors.jordyBlue.withValues(
                    alpha: 0.3,
                  ),
                ),
                child: Slider(
                  value: progress,
                  min: 0,
                  max: 1,
                  onChanged: _audioProvider.totalDuration.inMilliseconds > 0
                      ? _onProgressChanged
                      : null,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _audioProvider.currentTime,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.jordyBlue,
                      ),
                    ),
                    Text(
                      _audioProvider.totalTime,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.jordyBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    final coverImage = _audioProvider.coverImage;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(
          AppConstants.radiusSmall,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          AppConstants.radiusSmall,
        ),
        child: coverImage == null || coverImage.isEmpty
            ? const Icon(
                Icons.menu_book,
                color: AppColors.yinMnBlue,
                size: AppConstants.iconLarge,
              )
            : coverImage.startsWith('http')
                ? Image.network(
                    coverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _coverPlaceholder();
                    },
                  )
                : Image.asset(
                    coverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _coverPlaceholder();
                    },
                  ),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return const Icon(
      Icons.menu_book,
      color: AppColors.yinMnBlue,
      size: AppConstants.iconLarge,
    );
  }
}
