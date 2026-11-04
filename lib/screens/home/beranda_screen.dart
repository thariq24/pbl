import 'package:flutter/material.dart';
import '../../widgets/app_constants.dart';
import '../../utils/text_styles.dart';
import '../../utils/color_palettes.dart';
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
  // Dummy data untuk buku populer
  final List<BookCardData> _popularBooks = [
    BookCardData(
      id: '1',
      title: 'Filosofi Teras',
      author: 'Henry Manampiring',
      rating: 4.9,
      category: 'Philosophy',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '2',
      title: 'Laut Bercerita',
      author: 'Leila S. Chudori',
      rating: 4.8,
      category: 'Fiction',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '3',
      title: 'Hujan',
      author: 'Tere Liye',
      rating: 4.7,
      category: 'Romance',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '4',
      title: 'Bumi',
      author: 'Tere Liye',
      rating: 4.8,
      category: 'Fantasy',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
  ];

  // Dummy data untuk buku terbaru
  final List<BookCardData> _recentBooks = [
    BookCardData(
      id: '5',
      title: 'Cinta di Musim Hujan',
      author: 'Siti Nurhaliza',
      rating: 4.6,
      category: 'Romance',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '6',
      title: 'Petualangan Naga',
      author: 'Ahmad Fauzi',
      rating: 4.5,
      category: 'Fantasy',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: false,
    ),
    BookCardData(
      id: '7',
      title: 'Sejarah Nusantara',
      author: 'Prof. Dr. Slamet',
      rating: 4.8,
      category: 'History',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '8',
      title: 'Kisah Hidup Soekarno',
      author: 'Cindy Adams',
      rating: 4.7,
      category: 'Biography',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
  ];

  void _handleBookTap(BookCardData book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailBukuScreen(),
      ),
    );
  }

  void _handleSeeAllPopular() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllBooksScreen(
          listType: BookListType.popular,
          initialBooks: _popularBooks,
        ),
      ),
    );
  }

  void _handleSeeAllRecent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllBooksScreen(
          listType: BookListType.recent,
          initialBooks: _recentBooks,
        ),
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
                padding: const EdgeInsets.all(AppConstants.paddingNormal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppConstants.spaceSmall),
                    Text(
                      'Selamat Datang!',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.oxfordBlue,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceXSmall),
                    Text(
                      'Temukan ribuan audiobook menarik',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.spaceCadet,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spaceSmall),

              // Banner Section
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingNormal,
                ),
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.yinMnBlue, AppColors.jordyBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
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
                          const SizedBox(height: AppConstants.spaceXSmall),
                          Text(
                            'Nikmati berbagai audiobook berkualitas',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConstants.spaceMedium),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
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

              // Buku Populer Section - Using BookSection
              BookSection(
                title: 'Buku Populer',
                books: _popularBooks,
                cardSize: BookCardSize.small,
                onBookTap: _handleBookTap,
                onSeeAll: _handleSeeAllPopular,
              ),

              const SizedBox(height: AppConstants.spaceLarge),

              // Buku Terbaru Section - Using BookSection
              BookSection(
                title: 'Buku Terbaru',
                books: _recentBooks,
                cardSize: BookCardSize.small,
                onBookTap: _handleBookTap,
                onSeeAll: _handleSeeAllRecent,
              ),

              const SizedBox(height: AppConstants.paddingXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
