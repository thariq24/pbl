import 'package:flutter/material.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/loading_widget.dart';
import 'verify_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingXLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppConstants.spaceNormal),

                      // Back button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.oxfordBlue,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),

                      const SizedBox(height: AppConstants.spaceXXLarge),

                      // Title
                      Center(
                        child: Text(
                          'Forgot Password',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.oxfordBlue,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceNormal),

                      // Description
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingNormal,
                          ),
                          child: Text(
                            'Enter your email address and we will send you a verification code to reset your password.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceXXLarge),

                      // Email field
                      CustomTextField(
                        label: 'E-mail',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleSendCode(),
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),

                      // Send code button
                      CustomButton(
                        text: 'Send Verification Code',
                        onPressed: _handleSendCode,
                        isLoading: _isLoading,
                        type: ButtonType.primary,
                      ),

                      const SizedBox(height: AppConstants.spaceNormal),

                      // Cancel button
                      CustomButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                        type: ButtonType.outline,
                      ),

                      const SizedBox(height: AppConstants.spaceXXLarge),

                      // Help text
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Remember your password?',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Back to Login',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Loading overlay
            if (_isLoading)
              const LoadingOverlay(message: 'Sending verification code...'),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulasi kirim kode
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification code sent to ${_emailController.text}',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to OTP verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOTPScreen(
            email: _emailController.text,
            verificationType: OTPVerificationType.forgotPassword,
          ),
        ),
      );
    }
  }
}
