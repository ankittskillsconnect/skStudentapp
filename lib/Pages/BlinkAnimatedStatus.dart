import 'package:flutter/material.dart';

class LiveSlidingText extends StatefulWidget {
  final String status;

  const LiveSlidingText({super.key, required this.status});

  @override
  State<LiveSlidingText> createState() => _LiveSlidingTextState();
}

class _LiveSlidingTextState extends State<LiveSlidingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.1, 0.5, 0.9],
                colors: const [
                  Colors.red,
                  Colors.white,
                  Colors.red,
                ],
                transform: GradientTranslation(_animation.value * bounds.width),
              ).createShader(bounds);
            },
            child: Text(
              widget.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GradientTranslation extends GradientTransform {
  final double slidePercent;

  GradientTranslation(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(slidePercent, 0.0, 0.0);
  }
}
