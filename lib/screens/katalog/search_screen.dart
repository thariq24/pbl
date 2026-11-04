import 'package:flutter/material.dart';
import '../../widgets/app_constants.dart';
import '../../utils/text_styles.dart';
import '../../utils/color_palettes.dart';
import '../../widgets/book_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedGenre;
  double? _selectedRating;
  
  // Genre options
  final List<String> _genres = [
    'Semua',
    'Horror',
    'Romance',
    'Fantasy',
    'History',
    'Biography',
    'Philosophy',
  ];
  
  // Rating options
  final List<double> _ratings = [1.0, 2.0, 3.0, 4.0, 4.5, 5.0];
  
  // Dummy book data for search results
  final List<BookCardData> _allBooks = [
    BookCardData(
      id: '1',
      title: 'Misteri Rumah Tua',
      author: 'Budi Santoso',
      rating: 4.5,
      category: 'Horror',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '2',
      title: 'Cinta di Musim Hujan',
      author: 'Siti Nurhaliza',
      rating: 4.8,
      category: 'Romance',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '3',
      title: 'Petualangan Naga',
      author: 'Ahmad Fauzi',
      rating: 4.3,
      category: 'Fantasy',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: false,
    ),
    BookCardData(
      id: '4',
      title: 'Sejarah Nusantara',
      author: 'Prof. Dr. Slamet',
      rating: 4.7,
      category: 'History',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '5',
      title: 'Kisah Hidupku',
      author: 'Rina Marlina',
      rating: 4.2,
      category: 'Biography',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: false,
    ),
    BookCardData(
      id: '6',
      title: 'Pemikiran Timur',
      author: 'Dr. Wijaya',
      rating: 4.6,
      category: 'Philosophy',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '7',
      title: 'Hantu Sekolah',
      author: 'Rini Kusuma',
      rating: 4.1,
      category: 'Horror',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: true,
    ),
    BookCardData(
      id: '8',
      title: 'Cinta Pertama',
      author: 'Dini Amalia',
      rating: 4.9,
      category: 'Romance',
      coverAsset: 'assets/cover-buku-hujan.jpg',
      hasAudio: false,
    ),
  ];
  
  List<BookCardData> get _filteredBooks {
    return _allBooks.where((book) {
      // Search query filter
      final matchesSearch = _searchQuery.isEmpty ||
          book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Genre filter
      final matchesGenre = _selectedGenre == null ||
          _selectedGenre == 'Semua' ||
          book.category == _selectedGenre;
      
      // Rating filter
      final matchesRating = _selectedRating == null ||
          (book.rating != null && book.rating! >= _selectedRating!);
      
      return matchesSearch && matchesGenre && matchesRating;
    }).toList();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _clearFilters() {
    setState(() {
      _selectedGenre = null;
      _selectedRating = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.oxfordBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pencarian Buku',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.oxfordBlue,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingNormal),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari judul buku atau penulis...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.jordyBlue),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.lavender.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingNormal,
                  vertical: AppConstants.paddingSmall,
                ),
              ),
            ),
          ),
          
          // Filters Section
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingNormal),
            color: AppColors.lavender.withValues(alpha: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.oxfordBlue,
                      ),
                    ),
                    if (_selectedGenre != null || _selectedRating != null)
                      TextButton(
                        onPressed: _clearFilters,
                        child: Text(
                          'Hapus Semua',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.jordyBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppConstants.spaceSmall),
                
                // Genre Filter
                Text(
                  'Genre',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.oxfordBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.spaceSmall),
                Wrap(
                  spacing: AppConstants.spaceSmall,
                  runSpacing: AppConstants.spaceSmall,
                  children: _genres.map((genre) {
                    final isSelected = _selectedGenre == genre;
                    return FilterChip(
                      label: Text(genre),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGenre = selected ? genre : null;
                        });
                      },
                      backgroundColor: AppColors.white,
                      selectedColor: AppColors.jordyBlue,
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: isSelected ? AppColors.white : AppColors.oxfordBlue,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.jordyBlue
                            : AppColors.grey.withValues(alpha: 0.3),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: AppConstants.spaceMedium),
                
                // Rating Filter
                Text(
                  'Rating Minimal',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.oxfordBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.spaceSmall),
                Wrap(
                  spacing: AppConstants.spaceSmall,
                  runSpacing: AppConstants.spaceSmall,
                  children: _ratings.map((rating) {
                    final isSelected = _selectedRating == rating;
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: AppConstants.iconXSmall,
                            color: isSelected ? AppColors.white : Colors.amber,
                          ),
                          const SizedBox(width: AppConstants.spaceXSmall),
                          Text(rating.toString()),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedRating = selected ? rating : null;
                        });
                      },
                      backgroundColor: AppColors.white,
                      selectedColor: AppColors.jordyBlue,
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: isSelected ? AppColors.white : AppColors.oxfordBlue,
                        fontWeight: FontWeight.w500,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.jordyBlue
                            : AppColors.grey.withValues(alpha: 0.3),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // Results Section
          Expanded(
            child: _filteredBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: AppConstants.iconXXLarge,
                          color: AppColors.grey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: AppConstants.spaceMedium),
                        Text(
                          'Tidak ada hasil',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spaceSmall),
                        Text(
                          'Coba ubah kata kunci atau filter pencarian',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppConstants.paddingNormal),
                    children: [
                      Text(
                        '${_filteredBooks.length} Buku Ditemukan',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.oxfordBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spaceMedium),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: AppConstants.spaceMedium,
                          mainAxisSpacing: AppConstants.spaceMedium,
                        ),
                        itemCount: _filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = _filteredBooks[index];
                          return BookCard(
                            book: book,
                            size: BookCardSize.small,
                            onTap: () {
                              // Navigate to book detail
                            },
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
