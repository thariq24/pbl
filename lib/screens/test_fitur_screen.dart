
import 'package:flutter/material.dart';
import 'detail_buku_screen.dart';
import 'pengaturan_audio_screen.dart';

class TestFiturScreen extends StatelessWidget {
  const TestFiturScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes Fitur BukuBicara'),
        backgroundColor: const Color(0xFFD9E1F1),
        foregroundColor: const Color(0xFF20345B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DetailBukuScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.menu_book),
              label: const Text('Buka Detail Buku'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PengaturanAudioScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.headphones),
              label: const Text('Buka Pengaturan Audio'),
            ),
          ],
        ),
      ),
    );
  }
}
