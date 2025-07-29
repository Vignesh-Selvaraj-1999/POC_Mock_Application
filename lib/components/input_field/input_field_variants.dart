import 'package:flutter/material.dart';
import 'input_field_config.dart';

class InputFieldVariants {
  static InputDecoration resolveDecoration(
      BuildContext context,
      InputFieldConfig cfg,
      ) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(cfg.borderRadius),
      borderSide: BorderSide(
        color: cfg.borderColor ?? Colors.grey.shade400,
        width: cfg.borderWidth,
      ),
    );

    switch (cfg.variant) {
      case InputFieldVariant.outlined:
        return InputDecoration(
          hintText: cfg.hint,
          hintStyle: cfg.hintStyle ?? TextStyle(color: Colors.grey.shade500),
          filled: false,
          prefixIcon: cfg.prefixIcon,
          suffixIcon: cfg.suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: BorderSide(
              color: cfg.borderColor ?? Theme.of(context).primaryColor,
              width: cfg.borderWidth + 0.5,
            ),
          ),
          errorBorder: baseBorder.copyWith(
            borderSide: BorderSide(
              color: cfg.errorColor ?? Colors.red,
            ),
          ),
          focusedErrorBorder: baseBorder.copyWith(
            borderSide: BorderSide(
              color: cfg.errorColor ?? Colors.red,
            ),
          ),
          errorStyle: TextStyle(
            color: cfg.errorColor ?? Colors.red,
            fontSize: 12,
          ),
        );

      case InputFieldVariant.primary:
        return InputDecoration(
          hintText: cfg.hint,
          hintStyle: cfg.hintStyle ?? TextStyle(color: Colors.grey.shade500),
          filled: true,
          fillColor: cfg.fillColor ?? Colors.grey.shade100,
          prefixIcon: cfg.prefixIcon,
          suffixIcon: cfg.suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: BorderSide(
              color: cfg.borderColor ?? Theme.of(context).primaryColor,
              width: cfg.borderWidth + 0.5,
            ),
          ),
          errorBorder: baseBorder.copyWith(
            borderSide: BorderSide(color: cfg.errorColor ?? Colors.red),
          ),
          focusedErrorBorder: baseBorder.copyWith(
            borderSide: BorderSide(color: cfg.errorColor ?? Colors.red),
          ),
          errorStyle: TextStyle(
            color: cfg.errorColor ?? Colors.red,
            fontSize: 12,
          ),
        );
    }
  }
}
