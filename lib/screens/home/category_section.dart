import 'package:flutter/material.dart';

import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Horror',
      'icon': Icons.nights_stay_rounded,
    },
    {
      'name': 'Romance',
      'icon': Icons.favorite_rounded,
    },
    {
      'name': 'Fantasy',
      'icon': Icons.auto_awesome_rounded,
    },
    {
      'name': 'History',
      'icon': Icons.history_edu_rounded,
    },
    {
      'name': 'Biography',
      'icon': Icons.person_rounded,
    },
    {
      'name': 'Philosophy',
      'icon': Icons.psychology_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori Buku',
            style: AppTextStyles.h3,
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.lavender.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      color: AppColors.yinMnBlue,
                      size: 30,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      category['name'] as String,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.oxfordBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}