import 'package:flutter/material.dart';
import '../utils/color_palettes.dart';
import '../widgets/app_constants.dart';
import '../screens/audio/audio_player_screen.dart';

/// Mini Audio Player Global - Floating player untuk BukuBicara
/// Konsep: Compact, modern, dengan glassmorphism effect
/// 
/// Features:
/// - Floating di bottom dengan safe area
/// - Glassmorphism dengan backdrop blur effect
/// - Waveform animation indicator
/// - Slide up gesture untuk expand ke full player
/// - Tap untuk navigate ke AudioPlayerScreen
class MiniAudioPlayer extends StatefulWidget {
  final String bookTitle;
  final String author;
  final String? coverImage;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onClose;
  final double progress; // 0.0 to 1.0

  const MiniAudioPlayer({
    super.key,
    required this.bookTitle,
    required this.author,
    this.coverImage,
    this.isPlaying = false,
    required this.onPlayPause,
    this.onNext,
    this.onPrevious,
    this.onClose,
    this.progress = 0.0,
  });

  @override
  State<MiniAudioPlayer> createState() => _MiniAudioPlayerState();
}

class _MiniAudioPlayerState extends State<MiniAudioPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  bool _isDragging = false;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _navigateToFullPlayer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AudioPlayerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get bottom navigation height
    final bottomNavHeight = AppConstants.bottomNavHeight;
    
    return Positioned(
      left: AppConstants.paddingNormal,
      right: AppConstants.paddingNormal,
      bottom: bottomNavHeight + AppConstants.paddingSmall, // Di atas bottom nav
      child: GestureDetector(
        onVerticalDragStart: (_) => setState(() => _isDragging = true),
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragOffset += details.delta.dy;
            // Clamp untuk swipe up effect
            if (_dragOffset < -50) {
              _dragOffset = -50;
            }
          });
        },
        onVerticalDragEnd: (details) {
          if (_dragOffset < -30) {
            // Swipe up detected - navigate to full player
            _navigateToFullPlayer();
          }
          setState(() {
            _isDragging = false;
            _dragOffset = 0;
          });
        },
        onTap: _navigateToFullPlayer,
        child: Transform.translate(
          offset: Offset(0, _dragOffset),
          child: AnimatedContainer(
            duration: AppConstants.animationFast,
            child: _buildPlayerContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.spaceCadet,
            AppColors.oxfordBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.jordyBlue.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        child: Stack(
          children: [
            // Glassmorphism background overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.white.withValues(alpha: 0.05),
                    AppColors.white.withValues(alpha: 0.01),
                  ],
                ),
              ),
            ),

            // Progress indicator bar di top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildProgressBar(),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.paddingMedium,
                right: AppConstants.paddingMedium,
                top: AppConstants.paddingMedium + 3, // 3px for progress bar
                bottom: AppConstants.paddingMedium,
              ),
              child: Row(
                children: [
                  // Cover dengan waveform overlay
                  _buildCoverWithWave(),

                  const SizedBox(width: AppConstants.spaceSmall),

                  // Book info
                  Expanded(
                    child: _buildBookInfo(),
                  ),

                  const SizedBox(width: AppConstants.spaceSmall),

                  // Controls
                  _buildControls(),
                ],
              ),
            ),

            // Swipe up indicator
            if (_isDragging)
              Positioned(
                top: 4,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.oxfordBlue.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXLarge),
          topRight: Radius.circular(AppConstants.radiusXLarge),
        ),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widget.progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.jordyBlue,
                AppColors.yinMnBlue,
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.radiusXLarge),
              topRight: Radius.circular(AppConstants.radiusXLarge),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoverWithWave() {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          // Cover image
          Container(
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              border: Border.all(
                color: AppColors.jordyBlue.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall - 1),
              child: widget.coverImage != null
                  ? Image.asset(
                      widget.coverImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildCoverPlaceholder();
                      },
                    )
                  : _buildCoverPlaceholder(),
            ),
          ),

          // Animated waveform overlay when playing
          if (widget.isPlaying)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.oxfordBlue.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Center(
                  child: _buildWaveformIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      color: AppColors.lavender,
      child: const Icon(
        Icons.headphones,
        color: AppColors.yinMnBlue,
        size: 24,
      ),
    );
  }

  Widget _buildWaveformIndicator() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(4, (index) {
            double animValue = _waveController.value;
            // Stagger animation untuk setiap bar
            double delay = index * 0.2;
            double height = 12 + 8 * ((animValue + delay) % 1.0).clamp(0.0, 1.0);

            return Container(
              width: 2.5,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: AppColors.jordyBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildBookInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.bookTitle,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 12,
              color: AppColors.jordyBlue,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.author,
                style: TextStyle(
                  color: AppColors.jordyBlue,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button (optional)
        if (widget.onPrevious != null)
          _buildControlButton(
            icon: Icons.skip_previous_rounded,
            onPressed: widget.onPrevious!,
            size: 24,
          ),

        const SizedBox(width: 4),

        // Play/Pause button (prominent)
        _buildPlayPauseButton(),

        const SizedBox(width: 4),

        // Next button (optional)
        if (widget.onNext != null)
          _buildControlButton(
            icon: Icons.skip_next_rounded,
            onPressed: widget.onNext!,
            size: 24,
          ),

        const SizedBox(width: 8),

        // Close button
        _buildControlButton(
          icon: Icons.close_rounded,
          onPressed: widget.onClose ?? () {},
          size: 20,
        ),
      ],
    );
  }

  Widget _buildPlayPauseButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.jordyBlue,
            AppColors.yinMnBlue,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.jordyBlue.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPlayPause,
          borderRadius: BorderRadius.circular(18),
          child: Icon(
            widget.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: AppColors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 24,
  }) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Icon(
            icon,
            color: AppColors.jordyBlue,
            size: size,
          ),
        ),
      ),
    );
  }
}
