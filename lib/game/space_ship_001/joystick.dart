import 'package:flutter/material.dart';
import '../../../utils/ryulib/game_engine.dart';

const BUTTON_SIZE = 60.0;
const BUTTON_POSITION_LEFT = -1;
const BUTTON_POSITION_RIGHT = 1;

typedef MoveCallback = void Function(int direction);

class Joystick extends GameControl {
  final MoveCallback onMove;

  Joystick({required this.onMove});

  @override
  void onStart(Canvas canvas, Size size, int current) {
    x = 20;
    y = size.height - BUTTON_SIZE * 2;
    width = BUTTON_SIZE;
    height = BUTTON_SIZE;
    paint.color = Colors.red.withOpacity(0.1);
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    const radius = BUTTON_SIZE / 2;
    canvas.drawCircle(Offset(x + radius, y + radius), radius, paint);
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    onMove(BUTTON_POSITION_LEFT);
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    onMove(0);
  }
}
