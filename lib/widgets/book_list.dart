import 'package:flutter/material.dart';
import '../utils/color_palettes.dart';
import '../utils/text_styles.dart';
import 'app_constants.dart';
import 'book_card.dart';
import 'empty_state.dart';
import 'loading_widget.dart';

/// Enum untuk layout book list
enum BookListLayout {
  horizontal, // Scroll horizontal
  vertical, // List vertikal
  grid, // Grid 2-3 kolom
}

/// Widget untuk menampilkan daftar buku
class BookList extends StatelessWidget {
  /// Daftar buku
  final List<BookCardData> books;

  /// Layout list (horizontal, vertical, grid)
  final BookListLayout layout;

  /// Ukuran book card
  final BookCardSize cardSize;

  /// Callback ketika card ditekan
  final void Function(BookCardData book)? onBookTap;

  /// Apakah dalam state loading
  final bool isLoading;

  /// Judul section (opsional untuk horizontal list)
  final String? title;

  /// Action text di sebelah title (opsional)
  final String? actionText;

  /// Callback ketika action text ditekan
  final VoidCallback? onActionTap;

  /// Jumlah kolom untuk grid layout
  final int gridColumns;

  /// Aspect ratio untuk grid
  final double gridAspectRatio;

  /// Apakah menampilkan info tambahan di card
  final bool showCardInfo;

  /// Apakah menampilkan author di card
  final bool showAuthor;

  /// Widget empty state custom (opsional)
  final Widget? emptyWidget;

  const BookList({
    super.key,
    required this.books,
    this.layout = BookListLayout.horizontal,
    this.cardSize = BookCardSize.medium,
    this.onBookTap,
    this.isLoading = false,
    this.title,
    this.actionText,
    this.onActionTap,
    this.gridColumns = 2,
    this.gridAspectRatio = 0.6,
    this.showCardInfo = true,
    this.showAuthor = true,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (title + action)
        if (title != null) ...[
          _buildHeader(),
          const SizedBox(height: AppConstants.spaceMedium),
        ],

        // Content
        if (isLoading)
          _buildLoading()
        else if (books.isEmpty)
          _buildEmpty()
        else
          _buildContent(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingNormal,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: AppTextStyles.h3,
          ),
          if (actionText != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(
                actionText!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.yinMnBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (layout) {
      case BookListLayout.horizontal:
        return _buildHorizontalList();
      case BookListLayout.vertical:
        return _buildVerticalList();
      case BookListLayout.grid:
        return _buildGrid();
    }
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: _getHorizontalListHeight(),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingNormal,
        ),
        itemCount: books.length,
        separatorBuilder: (context, index) => const SizedBox(
          width: AppConstants.spaceMedium,
        ),
        itemBuilder: (context, index) {
          return BookCard(
            book: books[index],
            size: cardSize,
            onTap: onBookTap != null ? () => onBookTap!(books[index]) : null,
            showInfo: showCardInfo,
            showAuthor: showAuthor,
          );
        },
      ),
    );
  }

  Widget _buildVerticalList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingNormal,
      ),
      itemCount: books.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: AppConstants.spaceMedium,
      ),
      itemBuilder: (context, index) {
        return BookCardHorizontal(
          book: books[index],
          onTap: onBookTap != null ? () => onBookTap!(books[index]) : null,
        );
      },
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingNormal,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridColumns,
          childAspectRatio: gridAspectRatio,
          crossAxisSpacing: AppConstants.spaceMedium,
          mainAxisSpacing: AppConstants.spaceNormal,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(
            book: books[index],
            size: cardSize,
            onTap: onBookTap != null ? () => onBookTap!(books[index]) : null,
            showInfo: showCardInfo,
            showAuthor: showAuthor,
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    if (layout == BookListLayout.horizontal) {
      return SizedBox(
        height: _getHorizontalListHeight(),
        child: const LoadingArea(),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(AppConstants.paddingXLarge),
        child: LoadingWidget(),
      );
    }
  }

  Widget _buildEmpty() {
    if (emptyWidget != null) {
      return emptyWidget!;
    }

    if (layout == BookListLayout.horizontal) {
      return SizedBox(
        height: _getHorizontalListHeight(),
        child: const Center(
          child: Text(
            'Belum ada buku',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    } else {
      return const EmptyCatalog();
    }
  }

  double _getHorizontalListHeight() {
    // Tinggi cover + spacing + title (2 lines) + author + info
    double coverHeight;
    switch (cardSize) {
      case BookCardSize.small:
        coverHeight = AppConstants.bookCoverHeightSmall;
        break;
      case BookCardSize.medium:
        coverHeight = AppConstants.bookCoverHeightMedium;
        break;
      case BookCardSize.large:
        coverHeight = AppConstants.bookCoverHeightLarge;
        break;
    }

    // Estimasi tinggi text (title 2 lines + author + spacing)
    double textHeight = 80;

    return coverHeight + textHeight;
  }
}

/// Section buku dengan title dan horizontal list
class BookSection extends StatelessWidget {
  final String title;
  final List<BookCardData> books;
  final void Function(BookCardData book)? onBookTap;
  final VoidCallback? onSeeAll;
  final bool isLoading;
  final BookCardSize cardSize;

  const BookSection({
    super.key,
    required this.title,
    required this.books,
    this.onBookTap,
    this.onSeeAll,
    this.isLoading = false,
    this.cardSize = BookCardSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return BookList(
      books: books,
      layout: BookListLayout.horizontal,
      cardSize: cardSize,
      onBookTap: onBookTap,
      isLoading: isLoading,
      title: title,
      actionText: onSeeAll != null ? 'Lihat Semua' : null,
      onActionTap: onSeeAll,
    );
  }
}

/// Widget untuk menampilkan buku trending dengan nomor ranking
class TrendingBookList extends StatelessWidget {
  final List<BookCardData> books;
  final void Function(BookCardData book)? onBookTap;
  final bool isLoading;

  const TrendingBookList({
    super.key,
    required this.books,
    this.onBookTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(AppConstants.paddingXLarge),
        child: LoadingWidget(),
      );
    }

    if (books.isEmpty) {
      return const EmptyCatalog();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.paddingNormal),
      itemCount: books.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: AppConstants.spaceMedium,
      ),
      itemBuilder: (context, index) {
        return _TrendingBookItem(
          rank: index + 1,
          book: books[index],
          onTap: onBookTap != null ? () => onBookTap!(books[index]) : null,
        );
      },
    );
  }
}

class _TrendingBookItem extends StatelessWidget {
  final int rank;
  final BookCardData book;
  final VoidCallback? onTap;

  const _TrendingBookItem({
    required this.rank,
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
          border: Border.all(color: AppColors.lavender),
        ),
        child: Row(
          children: [
            // Ranking number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: rank <= 3 ? AppColors.yinMnBlue : AppColors.jordyBlue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: rank <= 3 ? AppColors.white : AppColors.oxfordBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppConstants.paddingMedium),

            // Cover
            Container(
              width: 60,
              height: 85,
              decoration: BoxDecoration(
                color: AppColors.lavender,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
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
                  Text(
                    book.title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.spaceXSmall),
                  Text(
                    book.author,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.rating != null) ...[
                    const SizedBox(height: AppConstants.spaceSmall),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: AppConstants.spaceXSmall),
                        Text(
                          book.rating!.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
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
          size: 24,
        ),
      ),
    );
  }
}
