
import 'package:flutter/material.dart';

import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/app_constants.dart';
import 'registrasi_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import 'reset_password_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login sementara: autentikasi Firebase akan diintegrasikan
  // setelah tahap perbaikan UI selesai.
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Login menggunakan Firebase Authentication
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // 2. Periksa apakah email sudah diverifikasi
      final isVerified = await _authService.isEmailVerified();

      if (!mounted) return;

      // 3. Jika belum terverifikasi
      if (!isVerified) {
        await _authService.logout();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email belum diverifikasi. Silakan periksa '
              'kotak masuk email kamu.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );

        return;
      }

      // 4. Jika sudah terverifikasi, masuk ke HomeScreen
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'Akun dengan email tersebut tidak ditemukan.';
          break;

        case 'wrong-password':
          message = 'Password yang kamu masukkan salah.';
          break;

        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;

        case 'invalid-credential':
          message = 'Email atau password yang kamu masukkan salah.';
          break;

        case 'user-disabled':
          message = 'Akun ini telah dinonaktifkan.';
          break;

        case 'too-many-requests':
          message = 'Terlalu banyak percobaan. Coba lagi nanti.';
          break;

        case 'network-request-failed':
          message = 'Periksa koneksi internet kamu.';
          break;

        default:
          message = e.message ?? 'Login gagal. Silakan coba lagi.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong.';
    }

    final emailRegex = RegExp(
      r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Masukkan alamat email yang valid.';
    }

    return null;
  }

  // Validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              AppConstants.paddingXLarge,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppConstants.spaceNormal,
                ),

                // Back button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.oxfordBlue,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),

                const SizedBox(
                  height: AppConstants.spaceXXLarge,
                ),

                // Title
                Center(
                  child: Text(
                    'Login',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.oxfordBlue,
                    ),
                  ),
                ),

                const SizedBox(
                  height: AppConstants.spaceXXLarge,
                ),

                // Login form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email field
                      Text(
                        'E-mail',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.oxfordBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        validator: _validateEmail,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor: AppColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: AppColors.yinMnBlue,
                              width: 1.5,
                            ),
                          ),
                          errorMaxLines: 2,
                        ),
                      ),

                      const SizedBox(
                        height: AppConstants.spaceNormal,
                      ),

                      // Password field
                      Text(
                        'Password',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.oxfordBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        validator: _validatePassword,
                        onFieldSubmitted: (_) => _handleLogin(),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor: AppColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: AppColors.yinMnBlue,
                              width: 1.5,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.grey,
                            ),
                          ),
                          errorMaxLines: 2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Lupa Password?',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: AppConstants.spaceXLarge,
                ),

                // Login button
                CustomButton(
                  text: _isLoading
                      ? 'Memproses...'
                      : 'Masuk ke BukuBicara',
                  onPressed: _isLoading ? () {} : _handleLogin,
                  type: ButtonType.primary,
                ),

                const SizedBox(
                  height: AppConstants.spaceXXLarge,
                ),

                // Divider text
                Center(
                  child: Text(
                    'atau',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),

                const SizedBox(
                  height: AppConstants.spaceNormal,
                ),

                // Google login (disabled for now)
                SizedBox(
                  width: double.infinity,
                  height: AppConstants.buttonHeightNormal,
                  child: OutlinedButton.icon(
                    onPressed: null,
                    icon: Image.asset(
                      'assets/icon/google.png',
                      width: 20,
                      height: 20,
                    ),
                    label: const Text(
                      'Masuk Dengan Google',
                    ),
                  ),
                ),

                const SizedBox(
                  height: AppConstants.spaceXLarge,
                ),

                // Register link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum Punya Akun? ',
                        style: AppTextStyles.bodySmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Register',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: AppConstants.spaceXLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
