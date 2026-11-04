import 'package:flutter/material.dart';
import '../widgets/app_constants.dart';
import '../utils/text_styles.dart';
import '../utils/color_palettes.dart';
import 'auth/login_screen.dart';
import 'auth/registrasi_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  void nextPage() {
    _pageController.nextPage(
      duration: AppConstants.animationNormal,
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
      backgroundColor: AppColors.lavender,
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
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spaceXXXLarge),
          Text(
            'Selamat Datang',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.oxfordBlue,
            ),
          ),
          const SizedBox(height: AppConstants.spaceSmall),
          Text(
            'Buku favoritmu, kini bersuara.\n'
            'Baca, dengarkan, dan nikmati\n'
            'cerita di mana saja.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.spaceCadet,
            ),
          ),
          const SizedBox(height: AppConstants.spaceXXLarge),
          Transform.translate(
            offset: const Offset(AppConstants.paddingNormal, 0),
            child: Image.asset(
              'assets/tes.jpeg',
              width: 340,
              height: 220,
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          const SizedBox(height: AppConstants.spaceXXXLarge),
          const SizedBox(height: AppConstants.spaceXXLarge),
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeightNormal,
            child: ElevatedButton(
              onPressed: onNext,
              child: const Text('Mulai Menjelajahi'),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spaceXXXLarge),
          Text(
            'Discover',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.oxfordBlue,
            ),
          ),
          const SizedBox(height: AppConstants.spaceSmall),
          Text(
            'Temukan berbagai buku menarik\n'
            'dan nikmati pengalaman membaca\n'
            'dengan cara yang lebih menyenangkan.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.spaceCadet,
            ),
          ),
          const SizedBox(height: AppConstants.spaceXXLarge),
          Transform.translate(
            offset: const Offset(-AppConstants.paddingNormal, 0),
            child: Image.asset(
              'assets/tes1.jpeg',
              width: 340,
              height: 220,
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          const SizedBox(height: AppConstants.spaceXXXLarge),
          const SizedBox(height: AppConstants.spaceXXLarge),
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeightNormal,
            child: ElevatedButton(
              onPressed: onNext,
              child: const Text('Lanjutkan'),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spaceXXXLarge),
          Text(
            'Connect',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.oxfordBlue,
            ),
          ),
          const SizedBox(height: AppConstants.spaceSmall),
          Text(
            'Buat akun dan mulai nikmati\n'
            'pengalaman membaca bersama\n'
            'BukuBicara.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.spaceCadet,
            ),
          ),
          const SizedBox(height: AppConstants.spaceXXLarge),
          Image.asset(
            'assets/dino.png',
            width: 240,
            height: 220,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: AppConstants.spaceXXLarge),
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeightNormal,
            child: ElevatedButton(
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
          ),
          const SizedBox(height: AppConstants.spaceSmall),
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeightNormal,
            child: ElevatedButton(
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
          ),
          const SizedBox(height: AppConstants.spaceSmall),
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeightNormal,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Login dengan Google'),
            ),
          ),
        ],
      ),
    );
  }
}
