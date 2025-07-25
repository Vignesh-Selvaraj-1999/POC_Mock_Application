import 'package:flutter/material.dart';

/// Shapes the button can take.
enum ButtonShape { rectangle, stadium, circle }

class CustomButton extends StatelessWidget {
  // ─── visuals ──────────────────────────────────────────────────────────────
  final String text;
  final TextStyle? textStyle;
  final Widget? icon;
  final IconPosition iconPosition;
  final double iconSpacing;

  final ButtonShape shape;          // NEW
  final double borderRadius;        // still here for rectangle
  final EdgeInsetsGeometry padding;
  final double elevation;
  final bool fullWidth;
  final Gradient? gradient;
  final Color backgroundColor;
  final Color disabledColor;
  final Color textColor;
  final Color disabledTextColor;

  // ─── behaviour ────────────────────────────────────────────────────────────
  final bool isLoading;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    this.textStyle,
    this.icon,
    this.iconPosition = IconPosition.start,
    this.iconSpacing = 8.0,
    this.shape = ButtonShape.rectangle,           // NEW
    this.borderRadius = 8.0,                      // keeps working
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    this.elevation = 2.0,
    this.fullWidth = false,
    this.gradient,
    this.backgroundColor = Colors.blue,
    this.disabledColor = Colors.grey,
    this.textColor = Colors.white,
    this.disabledTextColor = Colors.white70,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || isLoading;

    // pick background colour
    final Color effectiveBg = disabled
        ? disabledColor
        : gradient == null
        ? backgroundColor
        : Colors.transparent;

    // compose child (spinner or text+icon)
    final Widget child = isLoading
        ? SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor:
        AlwaysStoppedAnimation(disabled ? disabledTextColor : textColor),
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconPosition == IconPosition.start
          ? _buildPrefix()
          : _buildSuffix(),
    );

    // decide border radius based on desired shape
    BorderRadius? radius;
    if (shape == ButtonShape.rectangle) {
      radius = BorderRadius.circular(borderRadius);
    } else if (shape == ButtonShape.stadium) {
      radius = BorderRadius.circular(999); // pill
    }

    // decide decoration shape
    final BoxDecoration decoration = shape == ButtonShape.circle
        ? BoxDecoration(
      shape: BoxShape.circle,
      color: effectiveBg,
      gradient: disabled ? null : gradient,
      boxShadow: _shadow(),
    )
        : BoxDecoration(
      color: effectiveBg,
      gradient: disabled ? null : gradient,
      borderRadius: radius,
      boxShadow: _shadow(),
    );

    return Opacity(
      opacity: disabled ? 0.6 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: shape == ButtonShape.circle ? null : radius,
          customBorder:
          shape == ButtonShape.circle ? const CircleBorder() : null,
          onTap: disabled ? null : onPressed,
          child: Container(
            width: fullWidth
                ? double.infinity
                : (shape == ButtonShape.circle ? 56 : null),
            height: shape == ButtonShape.circle ? 56 : null,
            padding: shape == ButtonShape.circle ? null : padding,
            decoration: decoration,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  List<BoxShadow>? _shadow() =>
      elevation > 0 ? [BoxShadow(color: Colors.black26, blurRadius: elevation)] : null;

  List<Widget> _buildPrefix() => [
    if (icon != null) icon!,
    if (icon != null) SizedBox(width: iconSpacing),
    Text(text, style: textStyle ?? TextStyle(color: textColor, fontSize: 16)),
  ];

  List<Widget> _buildSuffix() => [
    Text(text, style: textStyle ?? TextStyle(color: textColor, fontSize: 16)),
    if (icon != null) SizedBox(width: iconSpacing),
    if (icon != null) icon!,
  ];
}

/// Where to render the icon relative to the text.
enum IconPosition { start, end }
