import 'package:flutter/material.dart';
import '../../../utils/ryulib/game_engine.dart';
import 'button.dart';

typedef MoveCallback = void Function(int direction);

class Joystick extends GameControl {
  final MoveCallback onMove;

  Joystick({required this.onMove});

  @override
  void onStart(Canvas canvas, Size size, int current) {
    getGameControlGroup()?.addControl(
        Button(
            onDown: () => onMove(BUTTON_POSITION_LEFT),
            onUp: () => onMove(0),
            direction: BUTTON_POSITION_LEFT
        )
    );

    getGameControlGroup()?.addControl(
        Button(
            onDown: () => onMove(BUTTON_POSITION_RIGHT),
            onUp: () => onMove(0),
            direction: BUTTON_POSITION_RIGHT
        )
    );
  }
}