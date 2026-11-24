
import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../services/book_service.dart';
import '../../utils/color_palettes.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/book_card.dart';
import '../../widgets/book_list.dart';
import '../../widgets/custom_text_field.dart';

import 'search_screen.dart';
import 'category_books_screen.dart';
import '../books/detail_buku_screen.dart';

class KatalogScreen extends StatefulWidget {
  const KatalogScreen({super.key});

  @override
  State<KatalogScreen> createState() => _KatalogScreenState();
}

class _KatalogScreenState extends State<KatalogScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final BookService _bookService = BookService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mengubah BookModel menjadi BookCardData.
  BookCardData _convertToBookCard(BookModel book) {
    return BookCardData(
      id: book.id,
      title: book.title,
      author: book.author,
      coverUrl: book.coverUrl,
      coverAsset: 'assets/cover-buku-hujan.jpg',
      rating: book.rating,
      hasAudio: book.hasAudio,
      category: book.category,
    );
  }

  // Mengelompokkan buku berdasarkan kategori.
  Map<String, List<BookCardData>> _groupBooksByCategory(
    List<BookModel> books,
  ) {
    final Map<String, List<BookCardData>> categories = {};

    for (final book in books) {
      final category = book.category.trim().isEmpty
          ? 'Lainnya'
          : book.category;

      categories.putIfAbsent(category, () => []);
      categories[category]!.add(_convertToBookCard(book));
    }

    return categories;
  }

  
  Future<void> _handleBookTap(BookCardData selectedBook) async {
    try {
      // Ambil data lengkap buku berdasarkan ID Firestore.
      final book = await _bookService.getBookById(selectedBook.id);

      if (!mounted) return;

      if (book == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data buku tidak ditemukan.'),
          ),
        );
        return;
      }

      // Buka halaman detail dengan data buku yang dipilih.
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


  void _handleSeeAllCategory(
    String category,
    List<BookCardData> books,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryBooksScreen(
          category: category,
          initialBooks: books,
        ),
      ),
    );
  }

  // Tampilan ketika belum ada buku.
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingNormal),
        child: Text(
          'Belum ada buku yang tersedia.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Tampilan ketika terjadi error.
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.paddingNormal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat katalog buku.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
            // Search bar section.
            Padding(
              padding: const EdgeInsets.all(
                AppConstants.paddingNormal,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: SearchTextField(
                    controller: _searchController,
                    hintText: 'Cari buku, penulis, atau genre...',
                  ),
                ),
              ),
            ),

            // Mengambil data buku dari Cloud Firestore.
            Expanded(
              child: StreamBuilder<List<BookModel>>(
                stream: _bookService.getPublishedBooks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildErrorState(
                      snapshot.error.toString(),
                    );
                  }

                  final books = snapshot.data ?? [];

                  if (books.isEmpty) {
                    return _buildEmptyState();
                  }

                  final categories =
                      _groupBooksByCategory(books);

                  final categoryNames =
                      categories.keys.toList()..sort();

                  return ListView(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.paddingXLarge,
                    ),
                    children: categoryNames.map((category) {
                      final categoryBooks =
                          categories[category]!;

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.spaceLarge,
                        ),
                        child: BookSection(
                          title: category,
                          books: categoryBooks,
                          cardSize: BookCardSize.small,
                          onBookTap: _handleBookTap,
                          onSeeAll: () =>
                              _handleSeeAllCategory(
                            category,
                            categoryBooks,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
