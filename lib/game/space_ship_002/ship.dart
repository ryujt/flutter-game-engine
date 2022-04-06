import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/game_engine.dart';

class Ship extends GameControl {
  Ship() {
    x = (375 - 60) / 2;
    y = 500;
    width = 60;
    height = 60;
    paint.color = Colors.blue;
  }

  bool checkCollisionAndExplode(GameControl target) {
    var result = checkCollision(target);
    if (result) deleted = true;
    return result;
  }

  @override
  void tick(Canvas canvas, int current, int term) {
    x = x + _direction;
    canvas.drawCircle(Offset( x + 30, y + 30 ), 30, paint);
  }

  void move(int direction) {
    _direction = direction;
  }

  int _direction = 0;
}