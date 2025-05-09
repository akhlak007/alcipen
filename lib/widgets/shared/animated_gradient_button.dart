import 'package:flutter/material.dart';
import 'package:alcipen/config/theme.dart';

class AnimatedGradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;
  final double height;
  final Gradient gradient;
  final BorderRadius? borderRadius;

  const AnimatedGradientButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isEnabled = true,
    this.height = 50,
    required this.gradient,
    this.borderRadius,
  }) : super(key: key);

  @override
  _AnimatedGradientButtonState createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isEnabled) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.isEnabled) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.isEnabled
                ? widget.gradient
                : LinearGradient(
                    colors: [AppColors.lightGrey, AppColors.lightGrey],
                  ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            boxShadow: widget.isEnabled && _isPressed
                ? [
                    BoxShadow(
                      color: widget.gradient.colors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : widget.isEnabled
                    ? [
                        BoxShadow(
                          color: widget.gradient.colors.first.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.isEnabled ? Colors.white : AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}