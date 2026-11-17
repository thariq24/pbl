import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/color_palettes.dart';
import '../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/app_constants.dart';
import '../../widgets/loading_widget.dart';
import 'reset_password_screen.dart';
import 'login_screen.dart';

enum OTPVerificationType {
  register,
  forgotPassword,
}

class VerifyOTPScreen extends StatefulWidget {
  final String email;
  final OTPVerificationType verificationType;

  const VerifyOTPScreen({
    super.key,
    required this.email,
    required this.verificationType,
  });

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isLoading = false;
  int _resendCountdown = 60;
  Timer? _resendTimer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendCountdown = 60;
    _canResend = false;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
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
                        'Verify Code',
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
                          'Please enter the 6-digit verification code sent to\n${widget.email}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.spaceXXLarge),

                    // OTP input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return _buildOTPField(index);
                      }),
                    ),

                    const SizedBox(height: AppConstants.spaceXLarge),

                    // Verify button
                    CustomButton(
                      text: 'Verify Code',
                      onPressed: _handleVerifyCode,
                      isLoading: _isLoading,
                      type: ButtonType.primary,
                    ),

                    const SizedBox(height: AppConstants.spaceXLarge),

                    // Resend code section
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Didn\'t receive the code?',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spaceSmall),
                          if (_canResend)
                            TextButton(
                              onPressed: _handleResendCode,
                              child: Text(
                                'Resend Code',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Text(
                              'Resend code in $_resendCountdown seconds',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppConstants.spaceNormal),

                    // Change email button
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Change Email Address',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (_isLoading)
              const LoadingOverlay(message: 'Verifying code...'),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 50,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(
          color: const Color(0xFF52617D),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.h2.copyWith(
          color: AppColors.oxfordBlue,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            // Move to next field
            _otpFocusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            // Move to previous field
            _otpFocusNodes[index - 1].requestFocus();
          }

          // Auto verify when all fields are filled
          if (index == 5 && value.isNotEmpty) {
            _handleVerifyCode();
          }
        },
      ),
    );
  }

  String _getOTPCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _handleVerifyCode() async {
    final otpCode = _getOTPCode();

    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete 6-digit code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi verifikasi
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Check verification type and navigate accordingly
    if (widget.verificationType == OTPVerificationType.register) {
      // Registration verified - go to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      // Forgot password - go to reset password
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: widget.email,
            otpCode: otpCode,
          ),
        ),
      );
    }
  }

  Future<void> _handleResendCode() async {
    setState(() => _isLoading = true);

    // Simulasi resend code
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification code resent to ${widget.email}'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear OTP fields
    for (var controller in _otpControllers) {
      controller.clear();
    }

    // Focus on first field
    _otpFocusNodes[0].requestFocus();

    // Restart timer
    _startResendTimer();
  }
}
