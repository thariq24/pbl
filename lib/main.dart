import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/onboarding_screen.dart';
// import 'screens/home/home_screen.dart'; // Uncomment for testing
import 'utils/color_palettes.dart';

void main() {
  // Set orientasi portrait only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BukuBicara',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: ThemeData(
        primaryColor: AppColors.oxfordBlue,
        scaffoldBackgroundColor: AppColors.lavender,
        fontFamily: 'Roboto',
        
        // Color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.yinMnBlue,
          primary: AppColors.yinMnBlue,
          secondary: AppColors.jordyBlue,
          surface: AppColors.white,
        ),
        
        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lavender,
          foregroundColor: AppColors.oxfordBlue,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Color(0xFF52617D),
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Color(0xFF52617D),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: AppColors.yinMnBlue,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
        ),
        
        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.oxfordBlue,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        
        // Text button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.yinMnBlue,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
        
        // Outlined button theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.oxfordBlue,
            side: const BorderSide(
              color: AppColors.oxfordBlue,
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        
        // Divider theme
        dividerTheme: const DividerThemeData(
          color: AppColors.grey,
          thickness: 1,
          space: 1,
        ),
        
        // Checkbox theme
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.yinMnBlue;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.white),
          side: const BorderSide(
            color: AppColors.grey,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        
        // Dialog theme
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        
        // Snackbar theme
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.oxfordBlue,
          contentTextStyle: TextStyle(color: AppColors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        
        // Use Material 3
        useMaterial3: true,
      ),
      
      // Home screen
      // Use OnboardingScreen for first launch, HomeScreen for testing main app
      home: const OnboardingScreen(),
      // home: const HomeScreen(), // Uncomment for testing katalog & navigation
      
      // Disable debug banner
      debugShowMaterialGrid: false,
    );
  }
}
