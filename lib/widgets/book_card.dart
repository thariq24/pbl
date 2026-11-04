import 'package:flutter/material.dart';
import '../utils/color_palettes.dart';
import '../utils/text_styles.dart';
import 'app_constants.dart';

/// Enum untuk ukuran book card
enum BookCardSize {
  small, // 100x140
  medium, // 120x170
  large, // 160x230
}

/// Model data buku sederhana untuk card
class BookCardData {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final String? coverAsset;
  final double? rating;
  final bool hasAudio;
  final String? category;

  const BookCardData({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    this.coverAsset,
    this.rating,
    this.hasAudio = false,
    this.category,
  });
}

/// Widget kartu buku reusable
class BookCard extends StatelessWidget {
  /// Data buku
  final BookCardData book;

  /// Ukuran card
  final BookCardSize size;

  /// Callback ketika card ditekan
  final VoidCallback? onTap;

  /// Apakah menampilkan info tambahan (rating, audio badge)
  final bool showInfo;

  /// Apakah menampilkan author
  final bool showAuthor;

  const BookCard({
    super.key,
    required this.book,
    this.size = BookCardSize.medium,
    this.onTap,
    this.showInfo = true,
    this.showAuthor = true,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: dimensions['width'],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover buku
            _buildCover(dimensions),

            const SizedBox(height: AppConstants.spaceSmall),

            // Judul buku
            Text(
              book.title,
              style: size == BookCardSize.small
                  ? AppTextStyles.titleSmall
                  : AppTextStyles.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Author (jika showAuthor true)
            if (showAuthor) ...[
              const SizedBox(height: AppConstants.spaceXSmall),
              Text(
                book.author,
                style: AppTextStyles.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Info tambahan (rating, audio badge)
            if (showInfo && (book.rating != null || book.hasAudio)) ...[
              const SizedBox(height: AppConstants.spaceSmall),
              _buildInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCover(Map<String, double> dimensions) {
    return Stack(
      children: [
        // Cover image
        Container(
          width: dimensions['width'],
          height: dimensions['height'],
          decoration: BoxDecoration(
            color: AppColors.lavender,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            child: _buildImage(),
          ),
        ),

        // Audio badge (jika ada audio)
        if (book.hasAudio)
          Positioned(
            top: AppConstants.spaceSmall,
            right: AppConstants.spaceSmall,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingXSmall),
              decoration: BoxDecoration(
                color: AppColors.yinMnBlue,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: const Icon(
                Icons.headphones,
                color: AppColors.white,
                size: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImage() {
    // Prioritas: coverUrl > coverAsset > placeholder
    if (book.coverUrl != null && book.coverUrl!.isNotEmpty) {
      return Image.network(
        book.coverUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
      );
    } else if (book.coverAsset != null && book.coverAsset!.isNotEmpty) {
      return Image.asset(
        book.coverAsset!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lavender,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              color: AppColors.jordyBlue,
              size: size == BookCardSize.small ? 32 : 40,
            ),
            const SizedBox(height: AppConstants.spaceXSmall),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
              ),
              child: Text(
                book.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.yinMnBlue,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Wrap(
      spacing: AppConstants.spaceSmall,
      runSpacing: AppConstants.spaceXSmall,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Rating
        if (book.rating != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 14,
              ),
              const SizedBox(width: AppConstants.spaceXSmall),
              Text(
                book.rating!.toStringAsFixed(1),
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.oxfordBlue,
                ),
              ),
            ],
          ),

        // Category
        if (book.category != null)
          Text(
            book.category!,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Map<String, double> _getDimensions() {
    switch (size) {
      case BookCardSize.small:
        return {
          'width': AppConstants.bookCoverWidthSmall,
          'height': AppConstants.bookCoverHeightSmall,
        };
      case BookCardSize.medium:
        return {
          'width': AppConstants.bookCoverWidthMedium,
          'height': AppConstants.bookCoverHeightMedium,
        };
      case BookCardSize.large:
        return {
          'width': AppConstants.bookCoverWidthLarge,
          'height': AppConstants.bookCoverHeightLarge,
        };
    }
  }
}

/// Book card horizontal - untuk layout list
class BookCardHorizontal extends StatelessWidget {
  final BookCardData book;
  final VoidCallback? onTap;

  const BookCardHorizontal({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          border: Border.all(
            color: AppColors.lavender,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Cover
            Container(
              width: 70,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.lavender,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                child: _buildImage(),
              ),
            ),

            const SizedBox(width: AppConstants.paddingMedium),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    book.title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppConstants.spaceXSmall),

                  // Author
                  Text(
                    book.author,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppConstants.spaceSmall),

                  // Rating dan audio badge
                  Row(
                    children: [
                      if (book.rating != null) ...[
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: AppConstants.spaceXSmall),
                        Text(
                          book.rating!.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spaceSmall),
                      ],
                      if (book.hasAudio)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingSmall,
                            vertical: AppConstants.paddingXSmall,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lavender,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusSmall,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.headphones,
                                color: AppColors.yinMnBlue,
                                size: 14,
                              ),
                              const SizedBox(width: AppConstants.spaceXSmall),
                              Text(
                                'Audio',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.yinMnBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow icon
            const Icon(
              Icons.chevron_right,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (book.coverUrl != null && book.coverUrl!.isNotEmpty) {
      return Image.network(
        book.coverUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else if (book.coverAsset != null && book.coverAsset!.isNotEmpty) {
      return Image.asset(
        book.coverAsset!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.lavender,
      child: const Center(
        child: Icon(
          Icons.menu_book,
          color: AppColors.jordyBlue,
          size: 32,
        ),
      ),
    );
  }
}
