import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/game_engine.dart';

class Ship extends GameControl {
  Ship() {
    x = 200;
    y = 500;
    width = 60;
    height = 60;
    paint.color = Colors.blue;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    x = x + _direction;
    canvas.drawCircle(Offset( x + 30, y + 30 ), 30, paint);
  }

  void move(int direction) {
    _direction = direction;
  }

  int _direction = 0;
}