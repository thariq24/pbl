import 'package:flutter/material.dart';

import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/book_card.dart';
import '../books/detail_buku_screen.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  final List<BookCardData> books = const [
    BookCardData(
      id: '1',
      title: 'Laskar Pelangi',
      author: 'Andrea Hirata',
      rating: 4.8,
      hasAudio: true,
    ),
    BookCardData(
      id: '2',
      title: 'Bumi',
      author: 'Tere Liye',
      rating: 4.7,
      hasAudio: true,
    ),
    BookCardData(
      id: '3',
      title: 'Filosofi Teras',
      author: 'Henry Manampiring',
      rating: 4.9,
      hasAudio: false,
    ),
    BookCardData(
      id: '4',
      title: 'Laut Bercerita',
      author: 'Leila S. Chudori',
      rating: 4.8,
      hasAudio: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Trending Books',
                  style: AppTextStyles.h3,
                ),
              ),
              const Icon(
                Icons.trending_up,
                color: AppColors.yinMnBlue,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 250,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 145,
                child: BookCard(
  book: books[index],
  size: BookCardSize.small,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailBukuScreen(),
      ),
    );
  },
),
              );
            },
          ),
        ),
      ],
    );
  }
}