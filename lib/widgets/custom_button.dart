import 'package:flutter/material.dart';
import '../utils/color_palettes.dart';
import '../utils/text_styles.dart';
import 'app_constants.dart';
import 'loading_widget.dart';

/// Enum untuk tipe button
enum ButtonType {
  primary,
  secondary,
  outline,
  text,
}

/// Enum untuk ukuran button
enum ButtonSize {
  small,
  medium,
  large,
}

/// Custom button reusable dengan berbagai variasi
class CustomButton extends StatelessWidget {
  /// Text yang ditampilkan di button
  final String text;

  /// Callback ketika button ditekan
  final VoidCallback? onPressed;

  /// Tipe button (primary, secondary, outline, text)
  final ButtonType type;

  /// Ukuran button (small, medium, large)
  final ButtonSize size;

  /// Apakah button full width
  final bool isFullWidth;

  /// Apakah button dalam state loading
  final bool isLoading;

  /// Icon di sebelah kiri text (opsional)
  final IconData? prefixIcon;

  /// Icon di sebelah kanan text (opsional)
  final IconData? suffixIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isFullWidth = true,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    // Tentukan height berdasarkan size
    double height;
    TextStyle textStyle;
    double iconSize;

    switch (size) {
      case ButtonSize.small:
        height = AppConstants.buttonHeightSmall;
        textStyle = AppTextStyles.buttonSmall;
        iconSize = AppConstants.iconSmall;
        break;
      case ButtonSize.medium:
        height = AppConstants.buttonHeightMedium;
        textStyle = AppTextStyles.buttonMedium;
        iconSize = AppConstants.iconMedium;
        break;
      case ButtonSize.large:
        height = AppConstants.buttonHeightNormal;
        textStyle = AppTextStyles.buttonLarge;
        iconSize = AppConstants.iconMedium;
        break;
    }

    Widget buttonChild = isLoading
        ? const LoadingSmall()
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: iconSize),
                const SizedBox(width: AppConstants.spaceSmall),
              ],
              Flexible(
                child: Text(
                  text,
                  style: textStyle.copyWith(
                    color: _getTextColor(isDisabled),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: AppConstants.spaceSmall),
                Icon(suffixIcon, size: iconSize),
              ],
            ],
          );

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.oxfordBlue,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.3),
            disabledForegroundColor: AppColors.grey,
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: AppConstants.paddingSmall,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusCircular),
            ),
            elevation: 0,
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.secondary:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.jordyBlue,
            foregroundColor: AppColors.oxfordBlue,
            disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.3),
            disabledForegroundColor: AppColors.grey,
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: AppConstants.paddingSmall,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusCircular),
            ),
            elevation: 0,
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.outline:
        button = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.oxfordBlue,
            disabledForegroundColor: AppColors.grey,
            side: BorderSide(
              color: isDisabled
                  ? AppColors.grey.withValues(alpha: 0.3)
                  : AppColors.oxfordBlue,
              width: 1.5,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: AppConstants.paddingSmall,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusCircular),
            ),
          ),
          child: buttonChild,
        );
        break;

      case ButtonType.text:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.yinMnBlue,
            disabledForegroundColor: AppColors.grey,
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: AppConstants.paddingSmall,
            ),
          ),
          child: buttonChild,
        );
        break;
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: button,
    );
  }

  Color _getTextColor(bool isDisabled) {
    if (isDisabled) return AppColors.grey;

    switch (type) {
      case ButtonType.primary:
        return AppColors.white;
      case ButtonType.secondary:
        return AppColors.oxfordBlue;
      case ButtonType.outline:
        return AppColors.oxfordBlue;
      case ButtonType.text:
        return AppColors.yinMnBlue;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppConstants.paddingNormal;
      case ButtonSize.medium:
        return AppConstants.paddingLarge;
      case ButtonSize.large:
        return AppConstants.paddingXLarge;
    }
  }
}

/// Icon button khusus
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = AppConstants.iconNormal,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: size,
        color: color ?? AppColors.oxfordBlue,
      ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Floating action button khusus
class CustomFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool mini;

  const CustomFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.yinMnBlue,
      foregroundColor: AppColors.white,
      tooltip: tooltip,
      mini: mini,
      child: Icon(icon),
    );
  }
}
