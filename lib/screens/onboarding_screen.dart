import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registrasi_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E1F1),
      body: PageView(
        controller: _pageController,
        children: [
          OnboardingPage(onNext: nextPage),
          DiscoverPage(onNext: nextPage),
          const ConnectPage(),
        ],
      ),
    );
  }
}

// ====================
// HALAMAN 1
// ====================

class OnboardingPage extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Text(
            'Selamat Datang',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buku favoritmu, kini bersuara.\n'
            'Baca, dengarkan, dan nikmati\n'
            'cerita di mana saja.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 45),

Transform.translate(
  offset: const Offset(16, 0),
  child: Image.asset(
    'assets/tes.jpeg',
    width: 340,
    height: 220,
    fit: BoxFit.fill,
    alignment: Alignment.center,
  ),
),

const SizedBox(height: 50),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: onNext,
            child: const Text('Mulai Menjelajahi'),
          ),
        ],
      ),
    );
  }
}

// ====================
// HALAMAN 2
// ====================

class DiscoverPage extends StatelessWidget {
  final VoidCallback onNext;

  const DiscoverPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Text(
            'Discover',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Temukan berbagai buku menarik\n'
            'dan nikmati pengalaman membaca\n'
            'dengan cara yang lebih menyenangkan.',
            style: TextStyle(fontSize: 16),
          ),
           const SizedBox(height: 45),

Transform.translate(
  offset: const Offset(-16, 0),
  child: Image.asset(
    'assets/tes1.jpeg',
    width: 340,
    height: 220,
    fit: BoxFit.fill,
    alignment: Alignment.center,
  ),
),

const SizedBox(height: 50),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: onNext,
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );
  }
}

// ====================
// HALAMAN 3
// ====================

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Text(
            'Connect',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buat akun dan mulai nikmati\n'
            'pengalaman membaca bersama\n'
            'BukuBicara.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 45),
          Image.asset(
            'assets/dino.png',
            width: 240,
            height: 220,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 40),
         ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  },
  child: const Text('Register'),
),
          const SizedBox(height: 10),
          ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  },
  child: const Text('Login'),
),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Login dengan Google'),
          ),
        ],
      ),
    );
  }
}