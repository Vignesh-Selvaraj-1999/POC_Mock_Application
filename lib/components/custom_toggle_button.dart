import 'package:flutter/material.dart';

enum ToggleShape { rectangle, stadium, circle }

class CustomToggleButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  // appearance
  final String onText;
  final String offText;
  final TextStyle? textStyle;
  final Widget? onIcon;
  final Widget? offIcon;
  final double iconSpacing;

  final Color onColor;
  final Color offColor;
  final Color disabledColor;
  final Color onTextColor;
  final Color offTextColor;

  final double elevation;
  final double disabledElevation;

  final ToggleShape shape;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool fullWidth;

  const CustomToggleButton({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onText = 'ON',
    this.offText = 'OFF',
    this.textStyle,
    this.onIcon,
    this.offIcon,
    this.iconSpacing = 6,
    this.onColor = Colors.green,
    this.offColor = Colors.grey,
    this.disabledColor = Colors.black26,
    this.onTextColor = Colors.white,
    this.offTextColor = Colors.white,
    this.elevation = 2,
    this.disabledElevation = 0,
    this.shape = ToggleShape.rectangle,
    this.borderRadius = 8,
    this.padding =
    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.fullWidth = false,
  }) : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.value ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant CustomToggleButton old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.onChanged == null;
    final Color bgOn = disabled ? widget.disabledColor : widget.onColor;
    final Color bgOff = disabled ? widget.disabledColor : widget.offColor;
    final Color textOn = widget.onTextColor;
    final Color textOff = widget.offTextColor;

    BorderRadius? radius;
    if (widget.shape == ToggleShape.rectangle) {
      radius = BorderRadius.circular(widget.borderRadius);
    } else if (widget.shape == ToggleShape.stadium) {
      radius = BorderRadius.circular(999);
    }

    return GestureDetector(
      onTap: disabled
          ? null
          : () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (ctx, _) {
          final Color bg = Color.lerp(bgOff, bgOn, _controller.value)!;
          final double elev = disabled
              ? widget.disabledElevation
              : widget.elevation * _controller.value;

          final Widget icon = _controller.value < 0.5
              ? widget.offIcon ?? const SizedBox.shrink()
              : widget.onIcon ?? const SizedBox.shrink();

          final String label = _controller.value < 0.5
              ? widget.offText
              : widget.onText;

          final Color textColor = _controller.value < 0.5
              ? textOff
              : textOn;

          final BoxDecoration decoration =
          widget.shape == ToggleShape.circle
              ? BoxDecoration(
            shape: BoxShape.circle,
            color: bg,
            boxShadow: elev > 0
                ? [
              BoxShadow(
                color: Colors.black26,
                blurRadius: elev,
              )
            ]
                : null,
          )
              : BoxDecoration(
            color: bg,
            borderRadius: radius,
            boxShadow: elev > 0
                ? [
              BoxShadow(
                color: Colors.black26,
                blurRadius: elev,
              )
            ]
                : null,
          );

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: widget.shape == ToggleShape.circle
                ? null
                : widget.padding,
            width: widget.fullWidth
                ? double.infinity
                : (widget.shape == ToggleShape.circle ? 56 : null),
            height:
            widget.shape == ToggleShape.circle ? 56 : null,
            decoration: decoration,
            child: Center(
              child: widget.shape == ToggleShape.circle
                  ? icon
                  : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon,
                  if (icon != null)
                    SizedBox(width: widget.iconSpacing),
                  Text(
                    label,
                    style: widget.textStyle ??
                        TextStyle(
                            color: textColor,
                            fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
