import 'dart:math';
import 'package:flutter/material.dart';
import 'game_engine.dart';

class Sample001 extends StatelessWidget {
  Sample001({Key? key}) : super(key: key) {
    _gameEngine.getControls().addControl(SimpleCircle());
    _gameEngine.getControls().addControl(AnimatedCircle());
    _gameEngine.getControls().addControl(BoxControl());
    _gameEngine.getControls().addControl(CircleControl());
    _gameEngine.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("GameEngine Demo"),
        ),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: _gameEngine.getCustomPaint()
        )
    );
  }

  final _gameEngine = GameEngine();
}

class SimpleCircle extends GameControl {
  SimpleCircle() {
    x = 10;
    y = 10;
    width = 50;
    height = 50;
    paint.color = Colors.red;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 6.0;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    canvas.drawCircle(Offset(x + width / 2, y + height / 2), width / 2, paint);
  }
}

class AnimatedCircle extends GameControl {
  AnimatedCircle() {
    x = 100;
    y = 10;
    width = 50;
    height = 50;
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    var radius = (width / 2)  + 6 * sin(current / 500);
    canvas.drawCircle(Offset(x + width / 2, y + height / 2), radius, paint);
  }
}

class BoxControl extends GameControl {
  BoxControl() {
    x = 200;
    y = 200;
    width = 50;
    height = 50;
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 6.0;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    canvas.drawRect(Rect.fromLTRB(x, y, x + width, y + height), paint);
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    bringToFront();
  }

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    x = details.localPosition.dx - startX;
    y = details.localPosition.dy - startY;
  }
}

class CircleControl extends GameControl {
  CircleControl() {
    x = 100;
    y = 100;
    width = 50;
    height = 50;
    paint.color = Colors.greenAccent;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 6.0;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    paint.color = Colors.greenAccent;
    canvas.drawCircle(Offset(x + width / 2, y + height / 2), width / 2, paint);

    if (_dragging) {
      paint.color = Colors.grey;
      var center = Offset(_dragX + width / 2, _dragY + height / 2);
      canvas.drawCircle(center, width / 2, paint);
    }
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    bringToFront();
    _dragging = true;
  }

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragX = details.localPosition.dx - startX;
    _dragY = details.localPosition.dy - startY;
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    _dragging = false;

    x = _dragX;
    y = _dragY;

    List<GameControl> list = checkCollisions();
    for (var control in list) {
      control.deleted = true;
    }
  }

  double _dragX = 0;
  double _dragY = 0;
  bool _dragging = false;
}