import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/color_palettes.dart';
import '../utils/text_styles.dart';
import '../utils/app_constants.dart';

/// Custom text field reusable dengan berbagai konfigurasi
class CustomTextField extends StatefulWidget {
  /// Label field
  final String? label;

  /// Hint text
  final String? hintText;

  /// Controller untuk text field
  final TextEditingController? controller;

  /// Fungsi validator
  final String? Function(String?)? validator;

  /// Apakah password field (obscure text)
  final bool isPassword;

  /// Keyboard type
  final TextInputType keyboardType;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Callback suffix icon
  final VoidCallback? onSuffixIconTap;

  /// Max lines
  final int maxLines;

  /// Max length
  final int? maxLength;

  /// Apakah read only
  final bool readOnly;

  /// Apakah enabled
  final bool enabled;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// On changed callback
  final ValueChanged<String>? onChanged;

  /// On submitted callback
  final ValueChanged<String>? onSubmitted;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Focus node
  final FocusNode? focusNode;

  /// Apakah menampilkan character counter
  final bool showCounter;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
    this.showCounter = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label.copyWith(
              color: AppColors.oxfordBlue,
            ),
          ),
          const SizedBox(height: AppConstants.spaceSmall),
        ],

        // Text field
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscureText && widget.isPassword,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.hint,
            filled: true,
            fillColor: widget.enabled ? AppColors.white : AppColors.lavender,
            
            // Prefix icon
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.grey,
                    size: AppConstants.iconMedium,
                  )
                : null,

            // Suffix icon
            suffixIcon: _buildSuffixIcon(),

            // Counter
            counterText: widget.showCounter ? null : '',

            // Border
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              borderSide: const BorderSide(
                color: Color(0xFF52617D),
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              borderSide: const BorderSide(
                color: Color(0xFF52617D),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              borderSide: const BorderSide(
                color: AppColors.yinMnBlue,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              borderSide: BorderSide(
                color: AppColors.grey.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),

            // Padding
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: widget.maxLines > 1
                  ? AppConstants.paddingMedium
                  : AppConstants.paddingSmall,
            ),

            // Error style
            errorStyle: AppTextStyles.error,
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // Jika password field, tampilkan toggle visibility
    if (widget.isPassword) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.grey,
          size: AppConstants.iconMedium,
        ),
      );
    }

    // Jika ada suffix icon custom
    if (widget.suffixIcon != null) {
      if (widget.onSuffixIconTap != null) {
        return IconButton(
          onPressed: widget.onSuffixIconTap,
          icon: Icon(
            widget.suffixIcon,
            color: AppColors.grey,
            size: AppConstants.iconMedium,
          ),
        );
      } else {
        return Icon(
          widget.suffixIcon,
          color: AppColors.grey,
          size: AppConstants.iconMedium,
        );
      }
    }

    return null;
  }
}

/// Search text field dengan style khusus
class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText ?? 'Cari buku...',
        hintStyle: AppTextStyles.hint,
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.grey,
          size: AppConstants.iconMedium,
        ),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  controller!.clear();
                  if (onClear != null) onClear!();
                  if (onChanged != null) onChanged!('');
                },
                icon: const Icon(
                  Icons.clear,
                  color: AppColors.grey,
                  size: AppConstants.iconMedium,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCircular),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingNormal,
          vertical: AppConstants.paddingMedium,
        ),
      ),
      style: AppTextStyles.bodyMedium,
    );
  }
}
