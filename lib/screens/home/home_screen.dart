import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/audio_player_overlay.dart';
import 'beranda_screen.dart';
import '../katalog/katalog_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // Screens for each tab (sesuai urutan BukuBicaraBottomNav.defaultItems)
  // 0: Beranda, 1: Jelajahi (Katalog), 2: Library, 3: Profil
  final List<Widget> _screens = [
    const BerandaScreen(),
    const KatalogScreen(),
    const LibraryScreen(),
    const ProfileScreen(),
  ];
  
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AudioPlayerOverlay(
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: _currentIndex,
          onTap: _onTabChanged,
          items: BukuBicaraBottomNav.defaultItems,
        ),
      ),
    );
  }
}

// Placeholder Library Screen
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpustakaan Saya'),
      ),
      body: const Center(
        child: Text('Library Screen - Coming Soon'),
      ),
    );
  }
}

// Placeholder Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: const Center(
        child: Text('Profile Screen - Coming Soon'),
      ),
    );
  }
}
