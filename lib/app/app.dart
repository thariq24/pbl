import 'package:flutter/material.dart';

import '../screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

class BukuBicaraApp extends StatelessWidget {
  const BukuBicaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BukuBicara',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      home: const OnboardingScreen(),
    );
  }
}