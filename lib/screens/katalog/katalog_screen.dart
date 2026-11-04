import 'package:flutter/material.dart';
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
  final TextEditingController _searchController = TextEditingController();

  // Data dummy untuk kategori
  final Map<String, List<BookCardData>> _categories = {
    'Horror': [
      BookCardData(
        id: '1',
        title: 'Seperoi Mie Ayam Setelah Mati',
        author: 'Penulis Horror',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.5,
        hasAudio: true,
        category: 'Horror',
      ),
      BookCardData(
        id: '2',
        title: 'Islam ala Prabowo',
        author: 'Penulis Horror',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.8,
        hasAudio: false,
        category: 'Horror',
      ),
      BookCardData(
        id: '3',
        title: 'Kursi Hitam',
        author: 'Penulis Horror',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.2,
        hasAudio: true,
        category: 'Horror',
      ),
      BookCardData(
        id: '4',
        title: 'Hantu Kuntilanak',
        author: 'Penulis Horror',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.3,
        hasAudio: true,
        category: 'Horror',
      ),
    ],
    'Romance': [
      BookCardData(
        id: '5',
        title: 'Fate Took the Long way Home',
        author: 'Penulis Romance',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.7,
        hasAudio: true,
        category: 'Romance',
      ),
      BookCardData(
        id: '6',
        title: 'Dear J',
        author: 'Penulis Romance',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.6,
        hasAudio: false,
        category: 'Romance',
      ),
      BookCardData(
        id: '7',
        title: 'Hujan',
        author: 'Tere Liye',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.8,
        hasAudio: true,
        category: 'Romance',
      ),
      BookCardData(
        id: '8',
        title: 'Cinta Pertama',
        author: 'Dini Amalia',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.9,
        hasAudio: true,
        category: 'Romance',
      ),
    ],
    'Fantasy': [
      BookCardData(
        id: '9',
        title: 'Laut Bercerita',
        author: 'Leila S. Chudori',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.9,
        hasAudio: true,
        category: 'Fantasy',
      ),
      BookCardData(
        id: '10',
        title: 'Alice Neverland',
        author: 'Penulis Fantasy',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.4,
        hasAudio: false,
        category: 'Fantasy',
      ),
      BookCardData(
        id: '11',
        title: 'Malborough Midnight',
        author: 'Penulis Fantasy',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.3,
        hasAudio: true,
        category: 'Fantasy',
      ),
      BookCardData(
        id: '12',
        title: 'Bumi',
        author: 'Tere Liye',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.8,
        hasAudio: true,
        category: 'Fantasy',
      ),
    ],
    'History': [
      BookCardData(
        id: '13',
        title: 'Janji',
        author: 'Penulis History',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.6,
        hasAudio: true,
        category: 'History',
      ),
      BookCardData(
        id: '14',
        title: 'Sejarah Sumatra',
        author: 'Penulis History',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.5,
        hasAudio: false,
        category: 'History',
      ),
      BookCardData(
        id: '15',
        title: 'Pulang',
        author: 'Penulis History',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.7,
        hasAudio: true,
        category: 'History',
      ),
      BookCardData(
        id: '16',
        title: 'Sejarah Nusantara',
        author: 'Prof. Dr. Slamet',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.8,
        hasAudio: true,
        category: 'History',
      ),
    ],
    'Biography': [
      BookCardData(
        id: '17',
        title: 'I.M Habibie',
        author: 'Penulis Biography',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.8,
        hasAudio: true,
        category: 'Biography',
      ),
      BookCardData(
        id: '18',
        title: 'Hilang dalam Dekapan Semeru',
        author: 'Penulis Biography',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.5,
        hasAudio: false,
        category: 'Biography',
      ),
      BookCardData(
        id: '19',
        title: 'Belum Selesai Tertidur',
        author: 'Penulis Biography',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.4,
        hasAudio: true,
        category: 'Biography',
      ),
      BookCardData(
        id: '20',
        title: 'Kisah Hidup Soekarno',
        author: 'Cindy Adams',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.7,
        hasAudio: true,
        category: 'Biography',
      ),
    ],
    'Philosophy': [
      BookCardData(
        id: '21',
        title: 'Filosofi Teras',
        author: 'Henry Manampiring',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.9,
        hasAudio: true,
        category: 'Philosophy',
      ),
      BookCardData(
        id: '22',
        title: '375 Meja',
        author: 'Penulis Philosophy',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.6,
        hasAudio: false,
        category: 'Philosophy',
      ),
      BookCardData(
        id: '23',
        title: 'Hujan Buli Juni',
        author: 'Penulis Philosophy',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.7,
        hasAudio: true,
        category: 'Philosophy',
      ),
      BookCardData(
        id: '24',
        title: 'Pemikiran Timur',
        author: 'Dr. Wijaya',
        coverAsset: 'assets/cover-buku-hujan.jpg',
        rating: 4.6,
        hasAudio: true,
        category: 'Philosophy',
      ),
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleBookTap(BookCardData book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailBukuScreen(),
      ),
    );
  }

  void _handleSeeAllCategory(String category) {
    final categoryBooks = _categories[category] ?? [];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryBooksScreen(
          category: category,
          initialBooks: categoryBooks,
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
            // Search bar section
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingNormal),
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

            // Kategori list with horizontal scroll - Using BookSection
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.paddingXLarge,
                ),
                children: _categories.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spaceLarge,
                    ),
                    child: BookSection(
                      title: entry.key,
                      books: entry.value,
                      cardSize: BookCardSize.small,
                      onBookTap: _handleBookTap,
                      onSeeAll: () => _handleSeeAllCategory(entry.key),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
