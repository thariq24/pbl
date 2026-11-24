
import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../services/book_service.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/book_card.dart';
import '../../widgets/book_list.dart';
import '../books/detail_buku_screen.dart';

class CategoryBooksScreen extends StatefulWidget {
  final String category;
  final List<BookCardData>? initialBooks;

  const CategoryBooksScreen({
    super.key,
    required this.category,
    this.initialBooks,
  });

  @override
  State<CategoryBooksScreen> createState() =>
      _CategoryBooksScreenState();
}

class _CategoryBooksScreenState extends State<CategoryBooksScreen> {
  final BookService _bookService = BookService();

  String _sortBy = 'popular';

  List<BookModel> _sortBooks(List<BookModel> books) {
    final sortedBooks = List<BookModel>.from(books);

    switch (_sortBy) {
      case 'popular':
      case 'rating':
        sortedBooks.sort(
          (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0),
        );
        break;

      case 'newest':
        sortedBooks.sort((a, b) {
          final aDate = a.createdAt;
          final bDate = b.createdAt;

          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;

          return bDate.compareTo(aDate);
        });
        break;

      case 'title':
        sortedBooks.sort(
          (a, b) => a.title.compareTo(b.title),
        );
        break;
    }

    return sortedBooks;
  }

  BookCardData _convertToBookCard(BookModel book) {
    return BookCardData(
      id: book.id,
      title: book.title,
      author: book.author,
      coverUrl: book.coverUrl,
      rating: book.rating,
      hasAudio: book.hasAudio,
      category: book.category,
    );
  }

  Future<void> _handleBookTap(BookCardData selectedBook) async {
    try {
      final book = await _bookService.getBookById(selectedBook.id);

      if (!mounted) return;

      if (book == null || !book.isPublished) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku tidak ditemukan atau belum diterbitkan.'),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBukuScreen(book: book),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka detail buku: $e'),
        ),
      );
    }
  }

  void _handleSort(String? value) {
    if (value == null) return;

    setState(() {
      _sortBy = value;
    });
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'popular':
        return 'Terpopuler';
      case 'newest':
        return 'Terbaru';
      case 'rating':
        return 'Rating Tertinggi';
      case 'title':
        return 'Judul A-Z';
      default:
        return '';
    }
  }

  Widget _buildBookContent(List<BookCardData> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingNormal),
          color: AppColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${books.length} Buku Ditemukan',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.oxfordBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _getSortLabel(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spaceSmall),

        Expanded(
          child: books.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_books_outlined,
                        size: AppConstants.iconXXLarge,
                        color: AppColors.grey.withValues(alpha: 0.5),
                      ),
                      const SizedBox(
                        height: AppConstants.spaceMedium,
                      ),
                      Text(
                        'Belum ada buku',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: AppConstants.spaceSmall,
                      ),
                      Text(
                        'Kategori ${widget.category} belum memiliki buku',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : BookList(
                  books: books,
                  layout: BookListLayout.vertical,
                  cardSize: BookCardSize.medium,
                  onBookTap: _handleBookTap,
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.oxfordBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.category,
          style: AppTextStyles.h2.copyWith(
            color: AppColors.oxfordBlue,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.sort,
              color: AppColors.oxfordBlue,
            ),
            onSelected: _handleSort,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'popular',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'popular'
                          ? Icons.check
                          : Icons.trending_up,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(
                      width: AppConstants.spaceSmall,
                    ),
                    const Text('Terpopuler'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'newest',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'newest'
                          ? Icons.check
                          : Icons.new_releases,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(
                      width: AppConstants.spaceSmall,
                    ),
                    const Text('Terbaru'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'rating',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'rating'
                          ? Icons.check
                          : Icons.star,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(
                      width: AppConstants.spaceSmall,
                    ),
                    const Text('Rating Tertinggi'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'title',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'title'
                          ? Icons.check
                          : Icons.sort_by_alpha,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(
                      width: AppConstants.spaceSmall,
                    ),
                    const Text('Judul A-Z'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<BookModel>>(
        stream: _bookService.getPublishedBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppConstants.paddingNormal,
                ),
                child: Text(
                  'Gagal memuat buku: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            final initialBooks = widget.initialBooks ?? [];

            if (initialBooks.isNotEmpty) {
              return _buildBookContent(initialBooks);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final categoryBooks = snapshot.data!
              .where(
                (book) =>
                    book.category.trim().toLowerCase() ==
                    widget.category.trim().toLowerCase(),
              )
              .toList();

          final sortedBooks = _sortBooks(categoryBooks);

          final displayBooks = sortedBooks
              .map(_convertToBookCard)
              .toList();

          return _buildBookContent(displayBooks);
        },
      ),
    );
  }
}
