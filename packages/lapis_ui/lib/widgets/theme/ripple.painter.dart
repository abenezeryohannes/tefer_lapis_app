import 'dart:math';

import 'package:flutter/material.dart';

class RipplePainter extends CustomPainter {
  const RipplePainter(this.color, this.radiusMultiplier, this.center);

  @override
  void paint(Canvas canvas, Size size) {    
    // final Offset center = new Offset(size.width/2.0, size.height/2.0);

    final double radius = _calcRadius(size) * radiusMultiplier;

    final Paint paint = new Paint();  
    paint.shader = _gradientShader(radius);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 20.0);

    canvas.drawCircle(center, radius, paint);
  }

  double _calcRadius(final Size size) {
    return max(size.width, size.height);
  }

  Shader _gradientShader(final double radius) {
    return LinearGradient(
      colors: <Color>[color[1], color[0]],
      stops: const <double>[0.0, 0.4],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter
    ).createShader(new Rect.fromCircle(center: Offset.zero, radius: radius));  
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


  final List<Color> color;
  final double radiusMultiplier;
  final Offset center;
}