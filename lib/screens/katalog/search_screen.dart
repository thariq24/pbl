
import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../services/book_service.dart';
import '../../utils/text_styles.dart';
import '../../utils/color_palettes.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/book_card.dart';
import '../books/detail_buku_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final BookService _bookService = BookService();

  String _searchQuery = '';
  String? _selectedGenre;
  double? _selectedRating;

  final List<double> _ratings = [
    1.0,
    2.0,
    3.0,
    4.0,
    4.5,
    5.0,
  ];

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
      rating: book.rating,
      category: book.category,
      hasAudio: book.hasAudio,
    );
  }

  // Membuka detail berdasarkan ID buku Firestore.
  Future<void> _handleBookTap(BookCardData selectedBook) async {
    try {
      final book = await _bookService.getBookById(selectedBook.id);

      if (!mounted) return;

      if (book == null || !book.isPublished) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Buku tidak ditemukan atau belum dipublikasikan.',
            ),
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
          content: Text(
            'Gagal memuat detail buku. Silakan coba lagi.',
          ),
        ),
      );
    }
  }

  // Menghapus seluruh pencarian dan filter.
  void _clearFilters() {
    setState(() {
      _selectedGenre = null;
      _selectedRating = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  // Memfilter buku berdasarkan judul, penulis, genre, dan rating.
  List<BookModel> _filterBooks(
    List<BookModel> books,
  ) {
    return books.where((book) {
      final query = _searchQuery.trim().toLowerCase();

      final matchesSearch = query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);

      final matchesGenre = _selectedGenre == null ||
          book.category.toLowerCase() ==
              _selectedGenre!.toLowerCase();

      final matchesRating = _selectedRating == null ||
          (book.rating != null &&
              book.rating! >= _selectedRating!);

      return matchesSearch && matchesGenre && matchesRating;
    }).toList();
  }

  // Tampilan ketika tidak ditemukan buku.
  Widget _buildEmptyResults() {
    return Center(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
          'Pencarian Buku',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.oxfordBlue,
          ),
        ),
      ),
      body: StreamBuilder<List<BookModel>>(
        stream: _bookService.getPublishedBooks(),
        builder: (context, snapshot) {
          final books = snapshot.data ?? [];

          // Mengambil genre secara dinamis dari Firestore.
          final genres = books
              .map((book) => book.category.trim())
              .where((category) => category.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

          final filteredBooks = _filterBooks(books);

          return Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(
                  AppConstants.paddingNormal,
                ),
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
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.jordyBlue,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.lavender.withValues(
                      alpha: 0.3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMedium,
                      ),
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
                padding: const EdgeInsets.all(
                  AppConstants.paddingNormal,
                ),
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
                        if (_selectedGenre != null ||
                            _selectedRating != null ||
                            _searchQuery.isNotEmpty)
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

                    const SizedBox(
                      height: AppConstants.spaceSmall,
                    ),

                    // Genre Filter
                    Text(
                      'Genre',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.oxfordBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: AppConstants.spaceSmall,
                    ),

                    Wrap(
                      spacing: AppConstants.spaceSmall,
                      runSpacing: AppConstants.spaceSmall,
                      children: [
                        'Semua',
                        ...genres,
                      ].map((genre) {
                        final isSelected = genre == 'Semua'
                            ? _selectedGenre == null
                            : _selectedGenre == genre;

                        return FilterChip(
                          label: Text(genre),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (genre == 'Semua' || !selected) {
                                _selectedGenre = null;
                              } else {
                                _selectedGenre = genre;
                              }
                            });
                          },
                          backgroundColor: AppColors.white,
                          selectedColor: AppColors.jordyBlue,
                          labelStyle: AppTextStyles.caption.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.oxfordBlue,
                            fontWeight: FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.jordyBlue
                                : AppColors.grey.withValues(
                                    alpha: 0.3,
                                  ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(
                      height: AppConstants.spaceMedium,
                    ),

                    // Rating Filter
                    Text(
                      'Rating Minimal',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.oxfordBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: AppConstants.spaceSmall,
                    ),

                    Wrap(
                      spacing: AppConstants.spaceSmall,
                      runSpacing: AppConstants.spaceSmall,
                      children: _ratings.map((rating) {
                        final isSelected =
                            _selectedRating == rating;

                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: AppConstants.iconXSmall,
                                color: isSelected
                                    ? AppColors.white
                                    : Colors.amber,
                              ),
                              const SizedBox(
                                width: AppConstants.spaceXSmall,
                              ),
                              Text(rating.toString()),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRating =
                                  selected ? rating : null;
                            });
                          },
                          backgroundColor: AppColors.white,
                          selectedColor: AppColors.jordyBlue,
                          labelStyle: AppTextStyles.caption.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.oxfordBlue,
                            fontWeight: FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.jordyBlue
                                : AppColors.grey.withValues(
                                    alpha: 0.3,
                                  ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Results Section
              Expanded(
                child: snapshot.connectionState ==
                            ConnectionState.waiting &&
                        !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : snapshot.hasError
                        ? Center(
                            child: Text(
                              'Gagal memuat data buku. Periksa koneksi internet.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : filteredBooks.isEmpty
                            ? _buildEmptyResults()
                            : ListView(
                                padding: const EdgeInsets.all(
                                  AppConstants.paddingNormal,
                                ),
                                children: [
                                  Text(
                                    '${filteredBooks.length} Buku Ditemukan',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.oxfordBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppConstants.spaceMedium,
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65,
                                      crossAxisSpacing:
                                          AppConstants.spaceMedium,
                                      mainAxisSpacing:
                                          AppConstants.spaceMedium,
                                    ),
                                    itemCount: filteredBooks.length,
                                    itemBuilder: (context, index) {
                                      final book = filteredBooks[index];

                                      return BookCard(
                                        book: _convertToBookCard(book),
                                        size: BookCardSize.small,
                                        onTap: () {
                                          _handleBookTap(
                                            _convertToBookCard(book),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}
