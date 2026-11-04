import 'package:flutter/material.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/book_card.dart';
import '../../widgets/book_list.dart';
import '../books/detail_buku_screen.dart';

enum BookListType {
  popular,
  recent,
  trending,
}

class AllBooksScreen extends StatefulWidget {
  final BookListType listType;
  final List<BookCardData>? initialBooks;

  const AllBooksScreen({
    super.key,
    required this.listType,
    this.initialBooks,
  });

  @override
  State<AllBooksScreen> createState() => _AllBooksScreenState();
}

class _AllBooksScreenState extends State<AllBooksScreen> {
  late List<BookCardData> _books;
  bool _isLoading = false;
  String _sortBy = 'default'; // default, rating, title, author

  @override
  void initState() {
    super.initState();
    _books = widget.initialBooks ?? [];
    if (_books.isEmpty) {
      _loadBooks();
    }
  }

  String get _pageTitle {
    switch (widget.listType) {
      case BookListType.popular:
        return 'Buku Populer';
      case BookListType.recent:
        return 'Buku Terbaru';
      case BookListType.trending:
        return 'Sedang Trending';
    }
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);

    // Simulasi load data dari API
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data - dalam implementasi real, ini dari API
    final dummyBooks = _generateDummyBooks();

    if (mounted) {
      setState(() {
        _books = dummyBooks;
        _isLoading = false;
      });
    }
  }

  List<BookCardData> _generateDummyBooks() {
    // Generate 20 buku dummy
    final categories = ['Horror', 'Romance', 'Fantasy', 'History', 'Biography', 'Philosophy'];
    
    return List.generate(20, (index) {
      final category = categories[index % categories.length];
      return BookCardData(
        id: 'book_$index',
        title: 'Book Title ${index + 1}',
        author: 'Author Name ${index + 1}',
        rating: 3.5 + (index % 15) * 0.1,
        category: category,
        coverAsset: 'assets/cover-buku-hujan.jpg',
        hasAudio: index % 3 != 0,
      );
    });
  }

  void _handleBookTap(BookCardData book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailBukuScreen(),
      ),
    );
  }

  void _handleSort(String? value) {
    if (value == null) return;

    setState(() {
      _sortBy = value;
      _sortBooks();
    });
  }

  void _sortBooks() {
    switch (_sortBy) {
      case 'default':
        // Reset to original order
        if (widget.listType == BookListType.popular) {
          _books.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        } else if (widget.listType == BookListType.recent) {
          _books = _books.reversed.toList();
        }
        break;
      case 'rating':
        _books.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'title':
        _books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'author':
        _books.sort((a, b) => a.author.compareTo(b.author));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.oxfordBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _pageTitle,
          style: AppTextStyles.h2.copyWith(
            color: AppColors.oxfordBlue,
          ),
        ),
        actions: [
          // Sort dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: AppColors.oxfordBlue),
            onSelected: _handleSort,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'default',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'default' ? Icons.check : Icons.filter_list,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(width: AppConstants.spaceSmall),
                    const Text('Default'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'rating',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'rating' ? Icons.check : Icons.star,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(width: AppConstants.spaceSmall),
                    const Text('Rating Tertinggi'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'title',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'title' ? Icons.check : Icons.sort_by_alpha,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(width: AppConstants.spaceSmall),
                    const Text('Judul A-Z'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'author',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'author' ? Icons.check : Icons.person,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(width: AppConstants.spaceSmall),
                    const Text('Penulis A-Z'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info bar
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingNormal),
                  color: AppColors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_books.length} Buku',
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

                // Books Grid - Using BookList
                Expanded(
                  child: _books.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.library_books_outlined,
                                size: AppConstants.iconXXLarge,
                                color: AppColors.grey.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: AppConstants.spaceMedium),
                              Text(
                                'Belum ada buku',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spaceSmall),
                              Text(
                                'Tidak ada buku untuk ditampilkan',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : BookList(
                          books: _books,
                          layout: BookListLayout.vertical,
                          cardSize: BookCardSize.medium,
                          gridColumns: 2,
                          gridAspectRatio: 0.65,
                          onBookTap: _handleBookTap,
                        ),
                ),
              ],
            ),
    );
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'default':
        return 'Default';
      case 'rating':
        return 'Rating Tertinggi';
      case 'title':
        return 'Judul A-Z';
      case 'author':
        return 'Penulis A-Z';
      default:
        return '';
    }
  }
}
