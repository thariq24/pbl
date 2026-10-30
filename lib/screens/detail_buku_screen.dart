
import 'package:flutter/material.dart';
import './utils/color_palette.dart';

class DetailBukuScreen extends StatelessWidget {
  const DetailBukuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            tooltip: 'Favorit',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur favorit belum dihubungkan'),
                ),
              );
            },
            icon: const Icon(Icons.favorite_border),
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
                  child: Image.asset(
                    'assets/cover-buku-hujan.jpg',
                    width: 160,
                    height: 230,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text('Cover gagal dimuat'),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Hujan',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.oxfordBlue,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tere Liye',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 14),

            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(icon: Icons.menu_book, text: 'Novel'),
                _InfoChip(
                  icon: Icons.headphones,
                  text: 'Audio tersedia',
                ),
                _InfoChip(icon: Icons.star, text: '4.8'),
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
            const Text(
              'Novel Hujan karya Tere Liye menceritakan kisah Lail dan Esok yang bertemu setelah bencana alam dahsyat menghancurkan sebagian besar dunia. '
              'Di tengah kehilangan dan perjuangan untuk bertahan hidup, keduanya tumbuh bersama dan menjalin hubungan yang penuh kenangan. '
              'Novel ini mengangkat tema persahabatan, cinta, kehilangan, pengorbanan, dan keikhlasan dalam menghadapi masa lalu. '
              'Pada akhirnya, Lail harus menentukan apakah ia ingin mempertahankan kenangannya atau belajar melepaskannya.',
              style: TextStyle(
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
                      context,
                      'Halaman baca ebook belum dihubungkan.',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FormatCard(
                    icon: Icons.headphones,
                    title: 'Audio',
                    subtitle: 'Dengarkan buku',
                    duration: '12 jam 30 menit',
                    onTap: () => _showMessage(
                      context,
                      'Audio buku belum dihubungkan.',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Rp75.000',
              style: TextStyle(
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
                    borderRadius: BorderRadius.circular(8   ),
                  ),
                ),
                onPressed: () => _showMessage(
                  context,
                  'Fitur pembelian buku belum dihubungkan.',
                ),
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Beli Buku'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.jordyBlue,
          ),
        ),
        child: Column(
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
                color: AppColors.grey,
              ),
            ),
            if (duration != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppColors.yinMnBlue,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      duration!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.yinMnBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
