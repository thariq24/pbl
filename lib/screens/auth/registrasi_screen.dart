import 'package:flutter/material.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/loading_widget.dart';
import 'login_screen.dart';
import 'verify_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

                      // Back button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.oxfordBlue,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),

                      // Title
                      Center(
                        child: Text(
                          'Register',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.oxfordBlue,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),

                      // First Name and Last Name
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'First Name',
                              hintText: 'Nama depan',
                              controller: _firstNameController,
                              validator: Validators.validateFirstName,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spaceMedium),
                          Expanded(
                            child: CustomTextField(
                              label: 'Last Name',
                              hintText: 'Nama belakang',
                              controller: _lastNameController,
                              validator: Validators.validateLastName,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppConstants.spaceNormal),

                      // Email
                      CustomTextField(
                        label: 'E-mail',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: AppConstants.spaceNormal),

                      // Password
                      CustomTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        isPassword: true,
                        validator: Validators.validatePasswordStrong,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: AppConstants.spaceXSmall),

                      // Password hint
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppConstants.paddingXSmall,
                        ),
                        child: Text(
                          'Must contain 8 characters with letters and numbers.',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceMedium),

                      // Confirm Password
                      CustomTextField(
                        label: 'Confirm Password',
                        hintText: 'Confirm your password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: (value) => Validators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (_agreeToTerms) {
                            _handleRegister();
                          }
                        },
                      ),

                      const SizedBox(height: AppConstants.spaceNormal),

                      // Terms and conditions checkbox
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: AppColors.yinMnBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spaceSmall),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text(
                                  'By continuing, you agree to our ',
                                  style: AppTextStyles.labelSmall,
                                ),
                                GestureDetector(
                                  onTap: _showTermsOfService,
                                  child: Text(
                                    'Terms of Service',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' and ',
                                  style: AppTextStyles.labelSmall,
                                ),
                                GestureDetector(
                                  onTap: _showPrivacyPolicy,
                                  child: Text(
                                    'Privacy Policy',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(
                                  '.',
                                  style: AppTextStyles.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),

                      // Register button
                      CustomButton(
                        text: 'Create Account',
                        onPressed: _agreeToTerms ? _handleRegister : null,
                        isLoading: _isLoading,
                        type: ButtonType.primary,
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),

                      // Divider with text
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingSmall,
                            ),
                            child: Text(
                              'or register with',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: AppConstants.spaceNormal),

                      // Google register button
                      SizedBox(
                        width: double.infinity,
                        height: AppConstants.buttonHeightNormal,
                        child: OutlinedButton.icon(
                          onPressed: _handleGoogleRegister,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.oxfordBlue,
                            side: const BorderSide(
                              color: AppColors.oxfordBlue,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusCircular,
                              ),
                            ),
                          ),
                          icon: Image.asset(
                            'assets/icon/google.png',
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.g_mobiledata,
                                size: 24,
                              );
                            },
                          ),
                          label: Text(
                            'Register with Google',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: AppColors.oxfordBlue,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),

                      // Login link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppTextStyles.bodySmall,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Login',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.spaceXLarge),
                    ],
                  ),
                ),
              ),
            ),

            // Loading overlay
            if (_isLoading)
              const LoadingOverlay(message: 'Creating account...'),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to Terms of Service and Privacy Policy'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      // Simulasi register
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Navigate to OTP verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOTPScreen(
            email: _emailController.text,
            verificationType: OTPVerificationType.register,
          ),
        ),
      );
    }
  }

  Future<void> _handleGoogleRegister() async {
    setState(() => _isLoading = true);

    // Simulasi Google register
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google register belum diimplementasikan'),
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Syarat dan ketentuan layanan BukuBicara akan ditampilkan di sini.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Kebijakan privasi BukuBicara akan ditampilkan di sini.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
