import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputFieldVariant { primary, outlined }

class InputFieldConfig {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? labelPadding;
  final InputFieldVariant variant;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final bool isObscure;
  final String obscureChar;
  final bool readOnly;
  final bool enabled;
  final bool expands;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? errorColor;
  final double borderRadius;
  final double borderWidth;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool isRequired;

  const InputFieldConfig({
    this.controller,
    this.focusNode,
    this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.labelPadding,
    this.variant = InputFieldVariant.primary,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.isObscure = false,
    this.obscureChar = '*',
    this.readOnly = false,
    this.enabled = true,
    this.expands = false,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.fillColor,
    this.borderColor,
    this.errorColor,
    this.borderRadius = 8.0,
    this.borderWidth = 1.5,
    this.autovalidateMode,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.isRequired = false,
  });
}
