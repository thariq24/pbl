
import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../services/library_service.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/book_card.dart';
import '../../widgets/book_list.dart';
import '../books/detail_buku_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryService = LibraryService();

    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Perpustakaan Saya',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.oxfordBlue,
          ),
        ),
      ),
      body: StreamBuilder<List<BookModel>>(
        stream: libraryService.getSavedBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppConstants.paddingNormal,
                ),
                child: Text(
                  'Gagal memuat perpustakaan: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return _buildEmptyState();
          }

          final bookCards = books.map((book) {
            return BookCardData(
              id: book.id,
              title: book.title,
              author: book.author,
              coverUrl: book.coverUrl,
              rating: book.rating,
              hasAudio: book.hasAudio,
              category: book.category,
            );
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  AppConstants.paddingNormal,
                ),
                child: Text(
                  '${books.length} Buku Tersimpan',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.oxfordBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: BookList(
                  books: bookCards,
                  layout: BookListLayout.vertical,
                  cardSize: BookCardSize.medium,
                  onBookTap: (selectedBook) {
                    final book = books.firstWhere(
                      (item) => item.id == selectedBook.id,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBukuScreen(
                          book: book,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.paddingLarge,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: AppConstants.iconXXLarge,
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
            const SizedBox(
              height: AppConstants.spaceMedium,
            ),
            Text(
              'Perpustakaan Masih Kosong',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.oxfordBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: AppConstants.spaceSmall,
            ),
            Text(
              'Simpan buku favoritmu melalui halaman detail buku. '
              'Buku yang disimpan akan muncul di sini.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
