import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/ryulib/game_engine.dart';

class AnimatedCircle extends GameControl {
  AnimatedCircle() {
    x = 100;
    y = 10;
    width = 50;
    height = 50;
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    var radius = (width / 2)  + 6 * sin(current / 500);
    canvas.drawCircle(Offset(x + width / 2, y + height / 2), radius, paint);
  }
}