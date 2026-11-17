
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/app_constants.dart';
import '../../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.resetPassword(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Jika email terdaftar, tautan reset password akan '
            'dikirim. Silakan periksa kotak masuk email kamu.',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );

      _emailController.clear();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'user-not-found':
          message = 'Jika email terdaftar, tautan reset password akan dikirim.';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan. Coba lagi nanti.';
          break;
        case 'network-request-failed':
          message = 'Periksa koneksi internet kamu.';
          break;
        default:
          message = e.message ??
              'Gagal mengirim tautan reset password.';
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
                    'Reset Password',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.oxfordBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(
                  height: AppConstants.spaceNormal,
                ),

                // Description
                Text(
                  'Lupa password akun BukuBicara kamu? '
                  'Jangan khawatir. Masukkan alamat email '
                  'yang terdaftar dan kami akan mengirimkan '
                  'tautan untuk membuat password baru.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.oxfordBlue,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(
                  height: AppConstants.spaceXXLarge,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        textInputAction: TextInputAction.done,
                        enabled: !_isLoading,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        validator: _validateEmail,
                        onFieldSubmitted: (_) =>
                            _handleResetPassword(),
                        decoration: InputDecoration(
                          hintText: 'Masukkan email terdaftar',
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
                    ],
                  ),
                ),

                const SizedBox(
                  height: AppConstants.spaceXLarge,
                ),

                // Reset button
                CustomButton(
                  text: _isLoading
                      ? 'Mengirim...'
                      : 'Kirim Tautan Reset',
                  onPressed:
                      _isLoading ? () {} : _handleResetPassword,
                  type: ButtonType.primary,
                ),

                const SizedBox(
                  height: AppConstants.spaceNormal,
                ),

                // Back to login
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Kembali ke Login',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.oxfordBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
