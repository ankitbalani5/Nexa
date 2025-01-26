import 'package:flutter/material.dart';

import '../Constant.dart';

class ThumbsUpAnimation extends StatefulWidget {
  final VoidCallback onTap;
  bool tapped;
  ThumbsUpAnimation({Key? key, required this.onTap, this.tapped = false}) : super(key: key);

  @override
  _ThumbsUpAnimationState createState() => _ThumbsUpAnimationState();
}

class _ThumbsUpAnimationState extends State<ThumbsUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  // bool tapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void _startAnimation() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tapped = !widget.tapped;
        setState(() {

        });
        widget.onTap();
        _startAnimation();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.tapped
            ? const Icon(
          Icons.thumb_up,
          color: Constant.bgOrangeLite,
          size: 18.0,
        ) : const Icon(
          Icons.thumb_up_alt_outlined,
          size: 18,
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
