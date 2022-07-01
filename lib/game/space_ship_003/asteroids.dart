import 'dart:math';
import 'package:flutter/material.dart';
import '../../../utils/ryulib/game_engine.dart';

const ASTEROID_SIZE = 30.0;

typedef CheckCollisionCallback = bool Function(GameControl target);

class Asteroids extends GameControl {
  final CheckCollisionCallback onCheckCollision;

  Asteroids({required this.onCheckCollision});

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    _term = _term + term;
    while (_term >= _relaseInterval) {
      _term = _term - _relaseInterval;
      _createAsteroid(size);
    }
  }

  void _createAsteroid(Size size) {
    var _x = _random.nextDouble() * (size.width - ASTEROID_SIZE);
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
    width = ASTEROID_SIZE;
    height = ASTEROID_SIZE;
    paint.color = Colors.red;
    _onCheckCollision = onCheckCollision;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    y = y + _speed;
    if (y > size.height) deleted = true;

    const radius = ASTEROID_SIZE / 2;
    canvas.drawCircle(Offset(x + radius, y + radius), radius, paint);

    if (_onCheckCollision != null) {
      if (_onCheckCollision!(this)) deleted = true;
    }
  }

  double _speed = 2;
  CheckCollisionCallback? _onCheckCollision;
}