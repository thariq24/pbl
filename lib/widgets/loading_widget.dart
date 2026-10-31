import 'package:flutter/material.dart';
import '../utils/color_palettes.dart';
import '../utils/text_styles.dart';

/// Widget loading indicator yang konsisten untuk aplikasi BukuBicara
class LoadingWidget extends StatelessWidget {
  /// Pesan yang ditampilkan di bawah loading indicator
  final String? message;

  /// Ukuran loading indicator
  final double size;

  /// Warna loading indicator
  final Color? color;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.yinMnBlue,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading indicator kecil untuk digunakan di dalam widget lain
class LoadingSmall extends StatelessWidget {
  final Color? color;

  const LoadingSmall({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.white,
        ),
      ),
    );
  }
}

/// Loading overlay full screen dengan background semi-transparent
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isLoading;

  const LoadingOverlay({
    super.key,
    this.message,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      color: AppColors.black.withValues(alpha: 0.5),
      child: LoadingWidget(
        message: message,
        color: AppColors.white,
      ),
    );
  }
}

/// Loading indicator untuk area tertentu (bukan full screen)
class LoadingArea extends StatelessWidget {
  final String? message;
  final double? height;

  const LoadingArea({
    super.key,
    this.message,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: LoadingWidget(
        message: message,
        size: 36.0,
      ),
    );
  }
}

/// Loading placeholder untuk list item (shimmer effect sederhana)
class LoadingPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Helper function untuk menampilkan loading dialog
void showLoadingDialog(
  BuildContext context, {
  String? message,
  bool barrierDismissible = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => PopScope(
      canPop: barrierDismissible,
      child: Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.yinMnBlue,
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 20),
                Text(
                  message,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

/// Helper function untuk menutup loading dialog
void hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
