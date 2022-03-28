import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/game_engine.dart';

typedef MoveCallback = void Function(int direction);

class Joystick extends GameControl {
  final MoveCallback onMove;

  Joystick({required this.onMove}) {
    x = 20;
    y = 600;
    width = 60;
    height = 60;
    paint.color = Colors.red;
  }

  @override
  void tick(Canvas canvas, int current, int term) {
    canvas.drawCircle(Offset(x + 30, y + 30), 30, paint);
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    onMove(-1);
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    onMove(0);
  }
}
