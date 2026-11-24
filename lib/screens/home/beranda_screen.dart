
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/book_model.dart';
import '../../services/auth_service.dart';
import '../../services/book_service.dart';
import '../../utils/text_styles.dart';
import '../../utils/color_palettes.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/book_card.dart';
import '../../widgets/book_list.dart';
import 'all_books_screen.dart';
import '../books/detail_buku_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final AuthService _authService = AuthService();
  final BookService _bookService = BookService();

  // Mengubah BookModel menjadi data untuk tampilan kartu buku.
  BookCardData _convertToBookCard(BookModel book) {
    return BookCardData(
      id: book.id,
      title: book.title,
      author: book.author,
      coverUrl: book.coverUrl,
      rating: book.rating,
      category: book.category,
      hasAudio: book.hasAudio,
    );
  }

  // Membuka detail buku berdasarkan ID Firestore.
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

  // Navigasi ke seluruh buku populer.
  void _handleSeeAllPopular(List<BookCardData> books) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllBooksScreen(
          listType: BookListType.popular,
          initialBooks: books,
        ),
      ),
    );
  }

  // Navigasi ke seluruh buku terbaru.
  void _handleSeeAllRecent(List<BookCardData> books) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllBooksScreen(
          listType: BookListType.recent,
          initialBooks: books,
        ),
      ),
    );
  }

  // Tampilan ketika data buku gagal dimuat.
  Widget _buildBookError() {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.paddingNormal),
      child: Text(
        'Gagal memuat daftar buku. Periksa koneksi internet Anda.',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  // Tampilan ketika belum ada buku yang dipublikasikan.
  Widget _buildEmptyBooks() {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.paddingNormal),
      child: Text(
        'Belum ada buku yang dipublikasikan.',
        style: TextStyle(color: AppColors.spaceCadet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(
                  AppConstants.paddingNormal,
                ),
                child: StreamBuilder<User?>(
                  stream: _authService.userChanges,
                  builder: (context, snapshot) {
                    final displayName =
                        snapshot.data?.displayName?.trim();

                    final greeting =
                        displayName != null && displayName.isNotEmpty
                            ? 'Halo, $displayName!'
                            : 'Selamat Datang!';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: AppConstants.spaceSmall,
                        ),
                        Text(
                          greeting,
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.oxfordBlue,
                          ),
                        ),
                        const SizedBox(
                          height: AppConstants.spaceXSmall,
                        ),
                        Text(
                          'Senang melihatmu kembali. Yuk, temukan audiobook menarik!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.spaceCadet,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: AppConstants.spaceSmall),

              // Banner Section
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingNormal,
                ),
                padding: const EdgeInsets.all(
                  AppConstants.paddingLarge,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.yinMnBlue,
                      AppColors.jordyBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusLarge,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dengarkan Kapan Saja',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(
                            height: AppConstants.spaceXSmall,
                          ),
                          Text(
                            'Nikmati berbagai audiobook berkualitas',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: AppConstants.spaceMedium,
                    ),
                    Container(
                      padding: const EdgeInsets.all(
                        AppConstants.paddingMedium,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMedium,
                        ),
                      ),
                      child: const Icon(
                        Icons.headphones,
                        size: AppConstants.iconXLarge,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spaceLarge),

              // Firestore Book Sections
              StreamBuilder<List<BookModel>>(
                stream: _bookService.getPublishedBooks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                          ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(
                        AppConstants.paddingLarge,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildBookError();
                  }

                  final books = snapshot.data ?? [];

                  if (books.isEmpty) {
                    return _buildEmptyBooks();
                  }

                  // Buku populer: rating tertinggi.
                  final popularModels = List<BookModel>.from(books)
                    ..sort(
                      (a, b) =>
                          (b.rating ?? 0).compareTo(a.rating ?? 0),
                    );

                  // Buku terbaru: tanggal publikasi terbaru.
                  final recentModels = List<BookModel>.from(books)
                    ..sort(
                      (a, b) =>
                          (b.createdAt ??
                                  DateTime.fromMillisecondsSinceEpoch(0))
                              .compareTo(
                            a.createdAt ??
                                DateTime.fromMillisecondsSinceEpoch(0),
                          ),
                    );

                  final popularBooks =
                      popularModels.map(_convertToBookCard).toList();

                  final recentBooks =
                      recentModels.map(_convertToBookCard).toList();

                  return Column(
                    children: [
                      // Buku Populer
                      BookSection(
                        title: 'Buku Populer',
                        books: popularBooks,
                        cardSize: BookCardSize.small,
                        onBookTap: _handleBookTap,
                        onSeeAll: () =>
                            _handleSeeAllPopular(popularBooks),
                      ),

                      const SizedBox(
                        height: AppConstants.spaceLarge,
                      ),

                      // Buku Terbaru
                      BookSection(
                        title: 'Buku Terbaru',
                        books: recentBooks,
                        cardSize: BookCardSize.small,
                        onBookTap: _handleBookTap,
                        onSeeAll: () =>
                            _handleSeeAllRecent(recentBooks),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: AppConstants.paddingXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
