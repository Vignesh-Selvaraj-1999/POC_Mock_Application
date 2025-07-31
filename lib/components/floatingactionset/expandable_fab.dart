import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final IconData icon;
  final FloatingActionButtonLocation? location;

  const ExpandableFab({
    Key? key,
    required this.children,
    this.duration = const Duration(milliseconds: 250),
    this.icon = Icons.add,
    this.location,
  }) : super(key: key);

  static const defaultLocation = FloatingActionButtonLocation.endFloat;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  void _toggle() {
    if (_isOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => _isOpen = !_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        ...List.generate(widget.children.length, (index) {
          final child = widget.children[index];
          return AnimatedBuilder(
            animation: _expandAnimation,
            builder: (_, __) {
              return Positioned(
                bottom: 70.0 * _expandAnimation.value * (index + 1),
                right: 0,
                child: Transform.scale(
                  scale: _expandAnimation.value,
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: child,
                  ),
                ),
              );
            },
          );
        }),
        FloatingActionButton(
          heroTag: null,
          onPressed: _toggle,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: _isOpen ? 0.125 : 0,
            child: Icon(_isOpen ? Icons.close : widget.icon),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
