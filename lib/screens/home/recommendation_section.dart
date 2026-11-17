
import 'package:flutter/material.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/book_card.dart';

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  final List<BookCardData> books = const [
    BookCardData(
      id: '5',
      title: 'Atomic Habits',
      author: 'James Clear',
      rating: 4.9,
      hasAudio: true,
    ),
    BookCardData(
      id: '6',
      title: 'Filosofi Teras',
      author: 'Henry Manampiring',
      rating: 4.8,
      hasAudio: false,
    ),
    BookCardData(
      id: '7',
      title: 'Negeri 5 Menara',
      author: 'Ahmad Fuadi',
      rating: 4.7,
      hasAudio: true,
    ),
    BookCardData(
      id: '8',
      title: 'Bumi Manusia',
      author: 'Pramoedya Ananta Toer',
      rating: 4.9,
      hasAudio: false,
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
                  'Rekomendasi e-Book',
                  style: AppTextStyles.h3,
                ),
              ),
              const Icon(
                Icons.auto_awesome_rounded,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
