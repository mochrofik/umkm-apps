import 'package:flutter/material.dart';

class ButtonLoading extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const ButtonLoading({
    super.key,
    this.color = Colors.white,
    this.size = 24,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
