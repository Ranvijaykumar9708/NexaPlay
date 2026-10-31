import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class TVFocusable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool autoFocus;
  final BorderRadius? borderRadius;
  final double scaleFactor;
  final EdgeInsetsGeometry padding;
  final bool showGlow;
  final Color? customGlowColor;

  const TVFocusable({
    super.key,
    required this.child,
    this.onPressed,
    this.focusNode,
    this.autoFocus = false,
    this.borderRadius,
    this.scaleFactor = 1.06,
    this.padding = EdgeInsets.zero,
    this.showGlow = true,
    this.customGlowColor,
  });

  @override
  State<TVFocusable> createState() => _TVFocusableState();
}

class _TVFocusableState extends State<TVFocusable>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _isFocused = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _isFocused) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _animController.forward();
        // Auto scroll into view on TV focus
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && context.mounted) {
            Scrollable.ensureVisible(
              context,
              alignment: 0.5,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
          }
        });
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    _animController.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter ||
          event.logicalKey == LogicalKeyboardKey.gameButtonA) {
        if (widget.onPressed != null) {
          widget.onPressed!();
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(12);
    final glowColor = widget.customGlowColor ?? AppTheme.primaryViolet;

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autoFocus,
      onKeyEvent: _handleKeyEvent,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
          widget.onPressed?.call();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              alignment: Alignment.center,
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  boxShadow: _isFocused && widget.showGlow
                      ? [
                          BoxShadow(
                            color: glowColor.withValues(alpha: 0.65),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: AppTheme.accentCyan.withValues(alpha: 0.45),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Container(
                  foregroundDecoration: _isFocused
                      ? BoxDecoration(
                          borderRadius: radius,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.8,
                          ),
                        )
                      : null,
                  child: child,
                ),
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
