import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final TextCapitalization textCapitalization;

  const AuthTextField({
    super.key,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscured : false,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      textCapitalization: widget.textCapitalization,
      style: TextStyle(
        fontSize: 15,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          fontSize: 14,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                size: 20,
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscured = !_obscured);
                },
              )
            : null,
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
      ),
    );
  }
}
