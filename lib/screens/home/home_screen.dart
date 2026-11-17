import 'package:flutter/material.dart';
import 'continue_reading_card.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import 'home_header.dart';
import '../../widgets/bottom_nav.dart';
import 'trending_section.dart';
import 'category_section.dart';
import 'recommendation_section.dart';
import 'ai_voice_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(userName: 'Pengguna'),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Temukan buku dan mulai dengarkan cerita favoritmu.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari buku favoritmu...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.lavender.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Continue Reading
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Lanjutkan Membaca',
                  style: AppTextStyles.h3,
                ),
              ),

              const SizedBox(height: 12),

              const ContinueReadingCard(
                title: 'Laskar Pelangi',
                author: 'Andrea Hirata',
                chapter: 'Bab 5',
                progress: 0.65,
              ),

              const SizedBox(height: 28),

              const TrendingSection(),

              const SizedBox(height: 28),

              const CategorySection(),

              const SizedBox(height: 28),

              const RecommendationSection(),

              const SizedBox(height: 28),

              const AiVoiceBanner(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: BukuBicaraBottomNav.withSearch,
      ),
    );
  }
}