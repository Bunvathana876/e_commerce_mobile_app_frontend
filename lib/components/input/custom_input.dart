import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// "−  2  +" quantity control, shared by Product Detail and Cart.
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove_rounded,
            onTap: onMinus,
            isDark: isDark,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ),
          _StepButton(icon: Icons.add_rounded, onTap: onPlus, isDark: isDark),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _StepButton({
    required this.icon,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? const Color(0xFF60A5FA) : AppColors.primary,
        ),
      ),
    );
  }
}

/// Commercial reusable input field with focus state, validation, and theme adaptivity.
class CustomInputField extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomInputField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 13.5,
                color: isDark
                    ? AppColors.darkTextMuted
                    : const Color(0xFF94A3B8),
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : const Color(0xFF64748B),
                    )
                  : null,
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
