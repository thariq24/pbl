import 'package:flutter/material.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/loading_widget.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otpCode;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otpCode,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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

                      // Back button (disabled to prevent going back)
                      IconButton(
                        onPressed: null,
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.grey,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),

                      const SizedBox(height: AppConstants.spaceXXLarge),

                      // Title
                      Center(
                        child: Text(
                          'Reset Password',
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
                            'Create a new password for your account.\nMake sure it\'s strong and secure.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceXXLarge),

                      // Email display (read-only)
                      Container(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusSmall,
                          ),
                          border: Border.all(
                            color: const Color(0xFF52617D),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: AppColors.grey,
                              size: AppConstants.iconMedium,
                            ),
                            const SizedBox(width: AppConstants.spaceSmall),
                            Expanded(
                              child: Text(
                                widget.email,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceNormal),

                      // New Password
                      CustomTextField(
                        label: 'New Password',
                        hintText: 'Enter new password',
                        controller: _newPasswordController,
                        isPassword: true,
                        validator: Validators.validatePasswordStrong,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: AppConstants.spaceXSmall),

                      // Password requirements
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppConstants.paddingXSmall,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPasswordRequirement(
                              'At least 8 characters',
                              _newPasswordController.text.length >= 8,
                            ),
                            _buildPasswordRequirement(
                              'Contains letters',
                              RegExp(r'[a-zA-Z]')
                                  .hasMatch(_newPasswordController.text),
                            ),
                            _buildPasswordRequirement(
                              'Contains numbers',
                              RegExp(r'[0-9]')
                                  .hasMatch(_newPasswordController.text),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceMedium),

                      // Confirm Password
                      CustomTextField(
                        label: 'Confirm Password',
                        hintText: 'Confirm new password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                          value,
                          _newPasswordController.text,
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleResetPassword(),
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),

                      // Reset password button
                      CustomButton(
                        text: 'Reset Password',
                        onPressed: _handleResetPassword,
                        isLoading: _isLoading,
                        type: ButtonType.primary,
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),

                      // Help text
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.grey,
                              size: 20,
                            ),
                            const SizedBox(height: AppConstants.spaceSmall),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingNormal,
                              ),
                              child: Text(
                                'After resetting your password, you will be redirected to the login page.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey,
                                ),
                                textAlign: TextAlign.center,
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
              const LoadingOverlay(message: 'Resetting password...'),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? Colors.green : AppColors.grey,
          ),
          const SizedBox(width: AppConstants.spaceXSmall),
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: isMet ? Colors.green : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulasi reset password
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
              ),
              const SizedBox(height: AppConstants.spaceNormal),
              Text(
                'Password Reset Successful!',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spaceSmall),
              Text(
                'Your password has been successfully reset. You can now login with your new password.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: 'Go to Login',
              onPressed: () {
                // Navigate to login and clear all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              type: ButtonType.primary,
            ),
          ],
        ),
      );
    }
  }
}
