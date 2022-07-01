import 'package:flutter/material.dart';
import '../utils/ryulib/game_engine.dart';

class BoxControl extends GameControl {
  BoxControl() {
    x = 200;
    y = 200;
    width = 50;
    height = 50;
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 6.0;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    canvas.drawRect(Rect.fromLTRB(x, y, x + width, y + height), paint);
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    bringToFront();
  }

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    x = details.localPosition.dx - startX;
    y = details.localPosition.dy - startY;
  }
}
