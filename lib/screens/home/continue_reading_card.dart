import 'package:flutter/material.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';

class ContinueReadingCard extends StatelessWidget {
  final String title;
  final String author;
  final double progress;
  final String chapter;

  const ContinueReadingCard({
    super.key,
    required this.title,
    required this.author,
    required this.progress,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.spaceCadet,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 105,
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              size: 40,
              color: AppColors.yinMnBlue,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LANJUTKAN MEMBACA',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.jordyBlue,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  author,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.lavender,
                  ),
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: AppColors.grey.withValues(alpha: 0.4),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.jordyBlue,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '$chapter • ${(progress * 100).round()}%',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}