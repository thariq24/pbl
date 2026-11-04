import 'package:flutter/material.dart';
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
  bool isPlaying = false;
  double progress = 0.25; // 25% dari total durasi
  double speed = 1.0;

  // Simulasi highlight text yang sedang dibacakan
  int highlightedParagraph = 1; // Index paragraf yang sedang dibacakan (0-based)

  // Data buku
  final String bookTitle = 'Hujan Bulan Juni';
  final String bookAuthor = 'Sapardi Djoko Damono';
  final String totalDuration = '10:10';
  
  // Konten buku (placeholder)
  final List<String> bookContent = [
    'Tak ada yang lebih tabah dari hujan bulan Juni dirahasiakannya rintik rindunya kepada pohon berbunga itu.',
    'Tak ada yang lebih bijak dari hujan bulan Juni dihapusnya jejak-jejak kakinya yang ragu-ragu di jalan itu.',
    'Tak ada yang lebih arif dari hujan bulan Juni dibiarkannya yang tak terucapkan diserap akar pohon bunga itu.',
  ];

  String get currentTime {
    final duration = 610; // 10:10 dalam detik
    final current = (duration * progress).toInt();
    final minutes = current ~/ 60;
    final seconds = current % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _onProgressChanged(double value) {
    setState(() {
      progress = value;
    });
  }

  void _previousChapter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pindah ke bab sebelumnya (simulasi)'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _nextChapter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pindah ke bab berikutnya (simulasi)'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showPlaylist() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menampilkan daftar bab (simulasi)'),
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
    return Scaffold(
      backgroundColor: AppColors.lavender,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Book Content Area (Expanded untuk mengambil space tersisa)
            Expanded(
              child: _buildBookContentArea(),
            ),

            // Mini Audio Player (Fixed di bawah)
            _buildMiniAudioPlayer(),
          ],
        ),
      ),
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
          // Back Button
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

          // Title and Author
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookTitle,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.oxfordBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.spaceXSmall),
                Text(
                  bookAuthor,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.spaceCadet,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Headphone Illustration
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.jordyBlue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
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
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0E8), // Abu-abu kehijauan lembut
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ilustrasi kecil di kanan atas
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

            // Book Content dengan highlight
            ...bookContent.asMap().entries.map((entry) {
              int idx = entry.key;
              String paragraph = entry.value;
              bool isHighlighted = idx == highlightedParagraph;

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
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingNormal),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.spaceCadet,
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
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
          // Top Row: Cover, Info, Settings
          Row(
            children: [
              // Cover Buku
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  child: Icon(
                    Icons.menu_book,
                    color: AppColors.yinMnBlue,
                    size: AppConstants.iconLarge,
                  ),
                ),
              ),

              const SizedBox(width: AppConstants.spaceMedium),

              // Info Buku
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookTitle,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.spaceXSmall),
                    Text(
                      bookAuthor,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.jordyBlue,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Settings Button
              IconButton(
                icon: const Icon(Icons.settings),
                color: AppColors.jordyBlue,
                iconSize: AppConstants.iconMedium,
                onPressed: _openSettings,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spaceMedium),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                color: AppColors.white,
                iconSize: AppConstants.iconLarge,
                onPressed: _previousChapter,
              ),

              const SizedBox(width: AppConstants.spaceSmall),

              // Play/Pause Button (Lebih besar)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.yinMnBlue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  color: AppColors.white,
                  iconSize: AppConstants.iconXLarge,
                  onPressed: _togglePlayPause,
                ),
              ),

              const SizedBox(width: AppConstants.spaceSmall),

              IconButton(
                icon: const Icon(Icons.skip_next),
                color: AppColors.white,
                iconSize: AppConstants.iconLarge,
                onPressed: _nextChapter,
              ),

              const SizedBox(width: AppConstants.spaceMedium),

              // Playlist Button
              IconButton(
                icon: const Icon(Icons.playlist_play),
                color: AppColors.jordyBlue,
                iconSize: AppConstants.iconLarge,
                onPressed: _showPlaylist,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spaceSmall),

          // Progress Bar
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
                  overlayColor: AppColors.jordyBlue.withValues(alpha: 0.3),
                ),
                child: Slider(
                  value: progress,
                  onChanged: _onProgressChanged,
                ),
              ),

              // Timestamp
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentTime,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.jordyBlue,
                      ),
                    ),
                    Text(
                      totalDuration,
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
}
