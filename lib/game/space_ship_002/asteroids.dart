import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../game_engine.dart';

typedef CheckCollisionCallback = bool Function(GameControl target);

class Asteroids extends GameControl {
  final CheckCollisionCallback onCheckCollision;

  Asteroids({required this.onCheckCollision});

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    _term = _term + term;
    while (_term >= _relaseInterval) {
      _term = _term - _relaseInterval;
      _createAsteroid();
    }
  }

  void _createAsteroid() {
    // screen: (375, 590), Asteroid: (30, 30)
    var _x = _random.nextDouble() * (375.0 - 30.0);
    getGameControlGroup()?.addControl(Asteroid(_x, 0, onCheckCollision));
  }

  int _relaseInterval = 500;
  int _term = 0;
  var _random = Random();
}

class Asteroid extends GameControl {
  Asteroid(double ax, double ay, CheckCollisionCallback onCheckCollision)
  {
    x = ax;
    y = ay;
    width = 30;
    height = 30;
    paint.color = Colors.red;
    _onCheckCollision = onCheckCollision;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    y = y + _speed;
    if (y > 590) deleted = true;
    canvas.drawCircle(Offset( x + 15, y + 15 ), 15, paint);

    if (_onCheckCollision != null) {
      if (_onCheckCollision!(this)) deleted = true;
    }
  }

  double _speed = 2;
  CheckCollisionCallback? _onCheckCollision;
}