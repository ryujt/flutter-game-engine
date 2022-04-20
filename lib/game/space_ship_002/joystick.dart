import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/game_engine.dart';

typedef MoveCallback = void Function(int direction);

const BUTTON_RADIUS = 30.0;
const BUTTON_POSITION_LEFT = -1;
const BUTTON_POSITION_RIGHT = 1;

class Joystick extends GameControl {
  final MoveCallback onMove;

  Joystick({required this.onMove});

  @override
  void onStart(Canvas canvas, Size size, int current) {
    getGameControlGroup()?.addControl(Button(joystick: this, direction: -1));
    getGameControlGroup()?.addControl(Button(joystick: this, direction: 1));
  }
}

class Button extends GameControl {
  final Joystick joystick;
  final int direction;

  Button({required this.joystick, required this.direction});

  @override
  void onStart(Canvas canvas, Size size, int current) {
    y = 500;
    width = BUTTON_RADIUS * 2;
    height = BUTTON_RADIUS * 2;
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
    joystick.onMove(direction);
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    joystick.onMove(0);
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    canvas.drawCircle(Offset(x + BUTTON_RADIUS, y + BUTTON_RADIUS), BUTTON_RADIUS, paint);
  }
}