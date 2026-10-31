import 'package:flutter/material.dart';
import '../utils/color_palettes.dart';
import '../utils/text_styles.dart';
import '../utils/app_constants.dart';

/// Widget untuk menampilkan kondisi data kosong
class EmptyState extends StatelessWidget {
  /// Icon yang ditampilkan
  final IconData icon;

  /// Judul pesan kosong
  final String title;

  /// Deskripsi pesan kosong
  final String description;

  /// Text tombol aksi (opsional)
  final String? actionText;

  /// Callback ketika tombol aksi ditekan
  final VoidCallback? onAction;

  /// Ukuran icon
  final double iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
    this.iconSize = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: iconSize + 40,
              height: iconSize + 40,
              decoration: BoxDecoration(
                color: AppColors.lavender,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: AppColors.jordyBlue,
              ),
            ),

            const SizedBox(height: AppConstants.spaceXLarge),

            // Title
            Text(
              title,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spaceSmall),

            // Description
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            // Action button (jika ada)
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppConstants.spaceXLarge),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yinMnBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingXLarge,
                    vertical: AppConstants.paddingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusMedium,
                    ),
                  ),
                ),
                child: Text(
                  actionText!,
                  style: AppTextStyles.buttonMedium,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state khusus untuk library kosong
class EmptyLibrary extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyLibrary({
    super.key,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.library_books_outlined,
      title: 'Library Kosong',
      description:
          'Kamu belum memiliki buku di library.\nMulai tambahkan buku favoritmu!',
      actionText: onExplore != null ? 'Jelajahi Buku' : null,
      onAction: onExplore,
    );
  }
}

/// Empty state khusus untuk hasil pencarian tidak ditemukan
class EmptySearchResult extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onClearSearch;

  const EmptySearchResult({
    super.key,
    this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'Tidak Ditemukan',
      description: searchQuery != null
          ? 'Tidak ada hasil untuk "$searchQuery".\nCoba kata kunci lain.'
          : 'Tidak ada hasil yang ditemukan.\nCoba kata kunci lain.',
      actionText: onClearSearch != null ? 'Hapus Pencarian' : null,
      onAction: onClearSearch,
      iconSize: 70.0,
    );
  }
}

/// Empty state khusus untuk katalog kosong
class EmptyCatalog extends StatelessWidget {
  final String? category;

  const EmptyCatalog({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.menu_book_outlined,
      title: 'Belum Ada Buku',
      description: category != null
          ? 'Belum ada buku di kategori $category.\nSegera hadir!'
          : 'Belum ada buku tersedia.\nSegera hadir!',
    );
  }
}

/// Empty state khusus untuk riwayat kosong
class EmptyHistory extends StatelessWidget {
  const EmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.history,
      title: 'Belum Ada Riwayat',
      description:
          'Riwayat bacaanmu akan muncul di sini.\nMulai baca buku sekarang!',
    );
  }
}

/// Empty state khusus untuk favorit kosong
class EmptyFavorites extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyFavorites({
    super.key,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: 'Belum Ada Favorit',
      description:
          'Tandai buku favoritmu untuk\nmenemukan mereka dengan mudah di sini.',
      actionText: onExplore != null ? 'Jelajahi Buku' : null,
      onAction: onExplore,
    );
  }
}

/// Empty state khusus untuk download kosong
class EmptyDownloads extends StatelessWidget {
  const EmptyDownloads({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.cloud_download_outlined,
      title: 'Belum Ada Unduhan',
      description:
          'Buku yang kamu unduh akan muncul di sini.\nUnduh buku untuk dibaca secara offline.',
    );
  }
}

/// Empty state khusus untuk notifikasi kosong
class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.notifications_none,
      title: 'Tidak Ada Notifikasi',
      description: 'Kamu akan melihat notifikasi terbaru di sini.',
      iconSize: 70.0,
    );
  }
}
