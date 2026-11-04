import 'package:flutter/material.dart';
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
  State<CategoryBooksScreen> createState() => _CategoryBooksScreenState();
}

class _CategoryBooksScreenState extends State<CategoryBooksScreen> {
  late List<BookCardData> _books;
  bool _isLoading = false;
  String _sortBy = 'popular'; // popular, newest, rating, title

  @override
  void initState() {
    super.initState();
    _books = widget.initialBooks ?? [];
    if (_books.isEmpty) {
      _loadBooks();
    }
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);

    // Simulasi load data dari API
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data - dalam implementasi real, ini dari API
    final dummyBooks = _generateDummyBooks(widget.category);

    if (mounted) {
      setState(() {
        _books = dummyBooks;
        _isLoading = false;
      });
    }
  }

  List<BookCardData> _generateDummyBooks(String category) {
    // Generate 12 buku dummy untuk kategori
    return List.generate(12, (index) {
      return BookCardData(
        id: '${category.toLowerCase()}_$index',
        title: '$category Book ${index + 1}',
        author: 'Author ${index + 1}',
        rating: 4.0 + (index % 10) * 0.1,
        category: category,
        coverAsset: 'assets/cover-buku-hujan.jpg',
        hasAudio: index % 2 == 0,
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
      case 'popular':
        // Simulasi sort by popularity (bisa based on rating)
        _books.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'newest':
        // Simulasi sort by newest (reverse order untuk dummy)
        _books = _books.reversed.toList();
        break;
      case 'rating':
        _books.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'title':
        _books.sort((a, b) => a.title.compareTo(b.title));
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
          widget.category,
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
                value: 'popular',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'popular' ? Icons.check : Icons.trending_up,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(width: AppConstants.spaceSmall),
                    const Text('Terpopuler'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'newest',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'newest' ? Icons.check : Icons.new_releases,
                      size: AppConstants.iconSmall,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(width: AppConstants.spaceSmall),
                    const Text('Terbaru'),
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
                        '${_books.length} Buku Ditemukan',
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

                // Books List - Using BookList with vertical layout
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
                          books: _books,
                          layout: BookListLayout.vertical,
                          cardSize: BookCardSize.medium,
                          onBookTap: _handleBookTap,
                        ),
                ),
              ],
            ),
    );
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
}
