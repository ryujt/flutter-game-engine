import 'package:flutter/material.dart';
import '../utils/ryulib/game_engine.dart';

class SimpleCircle extends GameControl {
  SimpleCircle() {
    x = 10;
    y = 10;
    width = 50;
    height = 50;
    paint.color = Colors.red;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 6.0;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    canvas.drawCircle(Offset(x + width / 2, y + height / 2), width / 2, paint);
  }
}