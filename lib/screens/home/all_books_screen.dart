
import 'package:flutter/material.dart';

import '../../services/book_service.dart';
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
  final BookService _bookService = BookService();

  late List<BookCardData> _books;
  bool _isLoading = false;
  String _sortBy = 'default';

  @override
  void initState() {
    super.initState();

    _books = List<BookCardData>.from(widget.initialBooks ?? []);

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

    try {
      final books = await _bookService.getPublishedBooks().first;

      if (!mounted) return;

      final bookCards = books.map((book) {
        return BookCardData(
          id: book.id,
          title: book.title,
          author: book.author,
          coverUrl: book.coverUrl,
          rating: book.rating,
          category: book.category,
          hasAudio: book.hasAudio,
        );
      }).toList();

      setState(() {
        _books = bookCards;
        _sortBooks();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memuat daftar buku.'),
        ),
      );
    }
  }

  // Membuka detail sesuai buku yang dipilih.
  Future<void> _handleBookTap(BookCardData selectedBook) async {
    try {
      final book = await _bookService.getBookById(selectedBook.id);

      if (!mounted) return;

      if (book == null || !book.isPublished) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku tidak ditemukan atau belum dipublikasikan.'),
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
        const SnackBar(
          content: Text('Gagal memuat detail buku. Silakan coba lagi.'),
        ),
      );
    }
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
        if (widget.listType == BookListType.popular) {
          _books.sort(
            (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0),
          );
        } else if (widget.listType == BookListType.recent) {
          // Urutan awal Buku Terbaru sudah berasal dari Beranda.
          // Jangan dibalik karena akan mengubah urutan terbaru.
        }
        break;

      case 'rating':
        _books.sort(
          (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0),
        );
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
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.oxfordBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _pageTitle,
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
              _buildSortItem('default', 'Default', Icons.filter_list),
              _buildSortItem('rating', 'Rating Tertinggi', Icons.star),
              _buildSortItem('title', 'Judul A-Z', Icons.sort_by_alpha),
              _buildSortItem('author', 'Penulis A-Z', Icons.person),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    AppConstants.paddingNormal,
                  ),
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

                Expanded(
                  child: _books.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.library_books_outlined,
                                size: AppConstants.iconXXLarge,
                                color: AppColors.grey.withValues(
                                  alpha: 0.5,
                                ),
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

  PopupMenuItem<String> _buildSortItem(
    String value,
    String label,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            _sortBy == value ? Icons.check : icon,
            size: AppConstants.iconSmall,
            color: AppColors.yinMnBlue,
          ),
          const SizedBox(width: AppConstants.spaceSmall),
          Text(label),
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
