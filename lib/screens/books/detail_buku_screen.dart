
import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../services/library_service.dart';
import '../../utils/color_palettes.dart';
import '../../providers/audio_player_provider.dart';
import '../../widgets/audio_player_overlay.dart';
import '../audio/audio_player_screen.dart';

class DetailBukuScreen extends StatefulWidget {
  const DetailBukuScreen({
    super.key,
    this.book,
  });

  final BookModel? book;

  @override
  State<DetailBukuScreen> createState() => _DetailBukuScreenState();
}

class _DetailBukuScreenState extends State<DetailBukuScreen> {
  final LibraryService _libraryService = LibraryService();

  static const bool _useLocalAudioForTesting = true;

  bool _isSaved = false;
  bool _isCheckingSaved = true;
  bool _isSaving = false;

  BookModel? get book => widget.book;

  String get _title => book?.title ?? 'Hujan';
  String get _author => book?.author ?? 'Tere Liye';

  String get _category {
    final category = book?.category.trim() ?? '';
    return category.isEmpty ? 'Kategori belum tersedia' : category;
  }

  String get _description {
    final description = book?.description.trim() ?? '';
    return description.isEmpty
        ? 'Sinopsis buku belum tersedia.'
        : description;
  }

  String get _rating {
    final rating = book?.rating;
    return rating == null
        ? 'Belum ada rating'
        : rating.toStringAsFixed(1);
  }

  String get _price {
    final price = book?.price;

    if (price == null || price <= 0) {
      return 'Harga belum tersedia';
    }

    return 'Rp${_formatNumber(price)}';
  }

  String _formatNumber(double value) {
    final number = value.toStringAsFixed(0);

    return number.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  String get _coverImage {
    final coverUrl = book?.coverUrl?.trim();
    return coverUrl ?? '';
  }

  @override
  void initState() {
    super.initState();
    _checkSavedStatus();
  }

  Future<void> _checkSavedStatus() async {
    if (book == null) {
      if (mounted) {
        setState(() => _isCheckingSaved = false);
      }
      return;
    }

    try {
      final isSaved = await _libraryService.isBookSaved(book!.id);

      if (!mounted) return;

      setState(() {
        _isSaved = isSaved;
        _isCheckingSaved = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isCheckingSaved = false);
    }
  }

  Future<void> _toggleFavorite() async {
    if (book == null) {
      _showMessage('Data buku tidak tersedia.');
      return;
    }

    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      if (_isSaved) {
        await _libraryService.removeBook(book!.id);

        if (!mounted) return;

        setState(() => _isSaved = false);
        _showMessage('Buku dihapus dari perpustakaan.');
      } else {
        await _libraryService.saveBook(book!.id);

        if (!mounted) return;

        setState(() => _isSaved = true);
        _showMessage('Buku berhasil disimpan ke perpustakaan.');
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage('Gagal memperbarui favorit: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioUrl = book?.audioUrl?.trim();

    final hasAudio = _useLocalAudioForTesting ||
    ((book?.hasAudio ?? false) &&
        audioUrl != null &&
        audioUrl.isNotEmpty);

    return AudioPlayerOverlay(
      child: Scaffold(
        backgroundColor: AppColors.lavender,
        appBar: AppBar(
          backgroundColor: AppColors.spaceCadet,
          foregroundColor: AppColors.white,
          elevation: 0,
          title: const Text(
            'Detail Buku',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              tooltip: _isSaved ? 'Hapus dari Library' : 'Simpan ke Library',
              onPressed: _isCheckingSaved || _isSaving
                  ? null
                  : _toggleFavorite,
              icon: _isSaving || _isCheckingSaved
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Icon(
                      _isSaved ? Icons.favorite : Icons.favorite_border,
                      color: _isSaved ? Colors.redAccent : AppColors.white,
                    ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 160,
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildCover(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                _title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.oxfordBlue,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _author,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.menu_book,
                    text: _category,
                  ),
                  _InfoChip(
                    icon: Icons.headphones,
                    text: hasAudio
                        ? 'Audio tersedia'
                        : 'Audio tidak tersedia',
                  ),
                  _InfoChip(
                    icon: Icons.star,
                    text: _rating,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Sinopsis',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.oxfordBlue,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: AppColors.oxfordBlue,
                ),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 24),

              const Text(
                'Format Buku',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.oxfordBlue,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _FormatCard(
                      icon: Icons.menu_book,
                      title: 'Ebook',
                      subtitle: 'Baca buku',
                      onTap: () => _showMessage(
                        'Halaman baca ebook belum dihubungkan.',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _FormatCard(
                      icon: Icons.headphones,
                      title: 'Audio',
                      subtitle: hasAudio
                          ? 'Dengarkan buku'
                          : 'Audio belum tersedia',
                      duration: 'Durasi belum tersedia',
                      onTap: () {
                        if (!hasAudio) {
                          _showMessage(
                            'Audio untuk buku ini belum tersedia.',
                          );
                          return;
                        }

                        _playAudioBook();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                _price,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.oxfordBlue,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yinMnBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _showMessage(
                    'Fitur pembelian buku belum dihubungkan.',
                  ),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Beli Buku'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover() {
    if (_coverImage.isNotEmpty) {
      return Image.network(
        _coverImage,
        width: 160,
        height: 230,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildCoverPlaceholder();
        },
      );
    }

    if (book == null) {
      return Image.asset(
        'assets/cover-buku-hujan.jpg',
        width: 160,
        height: 230,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildCoverPlaceholder();
        },
      );
    }

    return _buildCoverPlaceholder();
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      width: 160,
      height: 230,
      color: AppColors.jordyBlue,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 48,
            color: AppColors.white,
          ),
          SizedBox(height: 8),
          Text(
            'Cover belum tersedia',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  
Future<void> _playAudioBook() async {
  if (book == null) {
    _showMessage('Data buku tidak tersedia.');
    return;
  }

  final audioProvider = AudioPlayerProvider();

  await audioProvider.playAudio(
    bookTitle: _title,
    author: _author,
    coverImage: _coverImage.isNotEmpty
        ? _coverImage
        : 'assets/cover-buku-hujan.jpg',
    audioAsset: 'assets/audio/sample.mp3',
  );

  if (!mounted) return;

  if (audioProvider.errorMessage != null) {
    _showMessage(audioProvider.errorMessage!);
    return;
  }

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const AudioPlayerScreen(),
    ),
  );
}
}


class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 17,
        color: AppColors.yinMnBlue,
      ),
      label: Text(
        text,
        style: const TextStyle(
          color: AppColors.oxfordBlue,
        ),
      ),
      backgroundColor: AppColors.jordyBlue,
      side: BorderSide.none,
    );
  }
}

class _FormatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? duration;
  final VoidCallback onTap;

  const _FormatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.jordyBlue,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.yinMnBlue,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.oxfordBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey,
              ),
            ),
            if (duration != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.jordyBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.yinMnBlue,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        duration!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.oxfordBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
