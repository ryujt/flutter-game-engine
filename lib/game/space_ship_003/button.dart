import 'package:flutter/material.dart';
import '../../utils/ryulib/game_engine.dart';

typedef NotificationCallback = void Function();

const BUTTON_SIZE = 60.0;
const BUTTON_POSITION_LEFT = -1;
const BUTTON_POSITION_RIGHT = 1;

class Button extends GameControl {
  final NotificationCallback onDown;
  final NotificationCallback onUp;
  final int direction;

  Button({required this.onDown, required this.onUp, required this.direction});

  @override
  void onStart(Canvas canvas, Size size, int current) {
    y = size.height - BUTTON_SIZE * 2;
    width = BUTTON_SIZE ;
    height = BUTTON_SIZE;
    paint.color = Colors.grey.withOpacity(0.1);

    const BUTTON_MARGIN = 20.0;
    switch(direction) {
      case BUTTON_POSITION_LEFT:
        x = BUTTON_MARGIN;
        break;
      case BUTTON_POSITION_RIGHT:
        x = size.width - width - BUTTON_MARGIN;
        break;
    }
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    onDown();
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    onUp();
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    const radius = BUTTON_SIZE / 2;
    canvas.drawCircle(Offset(x + radius, y + radius), radius, paint);
  }
}