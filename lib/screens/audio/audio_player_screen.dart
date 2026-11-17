
import 'package:flutter/material.dart';
import '../../utils/color_palettes.dart';
import 'pengaturan_audio_screen.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.25;
  double speed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        backgroundColor: AppColors.spaceCadet,
        foregroundColor: AppColors.white,
        title: const Text('Audio Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const PengaturanAudioScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/cover-buku-hujan.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.menu_book,
                      size: 80,
                      color: AppColors.yinMnBlue,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Hujan',
              style: TextStyle(
                fontSize: 24,
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

            const SizedBox(height: 30),

            Slider(
              value: progress,
              onChanged: (value) {
                setState(() => progress = value);
              },
              activeColor: AppColors.yinMnBlue,
              inactiveColor: AppColors.jordyBlue,
            ),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('03:15'),
                Text('12:30:00'),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.replay_10),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 60,
                  color: AppColors.yinMnBlue,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                  ),
                  onPressed: () {
                    setState(() => isPlaying = !isPlaying);
                  },
                ),
                IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.forward_10),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.speed,
                  color: AppColors.yinMnBlue,
                ),
                const SizedBox(width: 10),
                DropdownButton<double>(
                  value: speed,
                  items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text('${value}x'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => speed = value);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Bab 1 - Awal Pertemuan',
              style: TextStyle(
                color: AppColors.oxfordBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
