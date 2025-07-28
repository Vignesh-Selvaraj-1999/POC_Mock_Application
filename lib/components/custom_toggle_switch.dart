import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  /// current state
  final bool value;

  /// callback with the new state (null = disabled)
  final ValueChanged<bool>? onChanged;

  /// track (background) colours
  final Color onTrackColor;
  final Color offTrackColor;
  final Color disabledTrackColor;

  /// thumb (circle) colours
  final Color onThumbColor;
  final Color offThumbColor;
  final Color disabledThumbColor;

  /// size
  final double width;
  final double height;

  /// animation speed
  final Duration duration;

  const CustomToggleSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onTrackColor = Colors.green,
    this.offTrackColor = Colors.grey,
    this.disabledTrackColor = Colors.black26,
    this.onThumbColor = Colors.white,
    this.offThumbColor = Colors.white,
    this.disabledThumbColor = Colors.white54,
    this.width = 52,
    this.height = 28,
    this.duration = const Duration(milliseconds: 200),
  })  : assert(width > height),
        super(key: key);

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.duration, value: widget.value ? 1 : 0);
  }

  @override
  void didUpdateWidget(covariant CustomToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.onChanged == null;
    final Color trackOn  = disabled ? widget.disabledTrackColor : widget.onTrackColor;
    final Color trackOff = disabled ? widget.disabledTrackColor : widget.offTrackColor;
    final Color thumbOn  = disabled ? widget.disabledThumbColor : widget.onThumbColor;
    final Color thumbOff = disabled ? widget.disabledThumbColor : widget.offThumbColor;

    return GestureDetector(
      onTap: disabled ? null : () => widget.onChanged?.call(!widget.value),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final Color trackColor = Color.lerp(trackOff, trackOn, _controller.value)!;
            final Color thumbColor = Color.lerp(thumbOff, thumbOn, _controller.value)!;

            return Stack(
              alignment: Alignment.center,
              children: [
                // track
                AnimatedContainer(
                  duration: widget.duration,
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
                // thumb
                Align(
                  alignment:
                  Alignment.lerp(const Alignment(-1, 0), const Alignment(1, 0), _controller.value)!,
                  child: Container(
                    width: widget.height - 4,
                    height: widget.height - 4,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
