import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/game_engine.dart';

typedef MoveCallback = void Function(int direction);

const BUTTON_POSITION_LEFT = -1;
const BUTTON_POSITION_RIGHT = 1;

class Joystick extends GameControl {
  final MoveCallback onMove;

  Joystick({required this.onMove});

  @override
  void onStart(Canvas canvas, int current) {
    getGameControlGroup()?.addControl(Button(joystick: this, direction: -1));
    getGameControlGroup()?.addControl(Button(joystick: this, direction: 1));
  }
}

class Button extends GameControl {
  final Joystick joystick;
  final int direction;

  Button({required this.joystick, required this.direction}) {
    switch(direction) {
      case BUTTON_POSITION_LEFT:
        x = 20;
        break;
      case BUTTON_POSITION_RIGHT:
        x = 330;
        break;
    }

    y = 500;
    width = 60;
    height = 60;
    paint.color = Colors.grey.withOpacity(0.1);
  }

  @override
  void tick(Canvas canvas, int current, int term) {
    canvas.drawCircle(Offset(x + 30, y + 30), 30, paint);
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    joystick.onMove(direction);
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    joystick.onMove(0);
  }
}