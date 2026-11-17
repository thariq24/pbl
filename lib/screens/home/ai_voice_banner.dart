
import 'package:flutter/material.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';

class AiVoiceBanner extends StatelessWidget {
  const AiVoiceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.oxfordBlue,
            AppColors.yinMnBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dengarkan Buku dengan AI Voice!',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nikmati pengalaman membaca e-book dengan suara AI yang natural.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.lavender,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigasi ke halaman AI Voice
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.oxfordBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Jelajahi Fitur'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.record_voice_over_rounded,
            size: 65,
            color: AppColors.jordyBlue,
          ),
        ],
      ),
    );
  }
}
