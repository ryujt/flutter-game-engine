# 슈팅 게임만들기 #4


## 학습목표

* Joystick을 두 개의 버튼을 포함하여 좌우로 우주선이 이동할 수 있도록 합니다.


## 구현

### Joystick class

``` dart
import 'package:flutter/material.dart';
import '../../game_engine.dart';

typedef MoveCallback = void Function(int direction);

const BUTTON_SIZE = 60.0;
const BUTTON_POSITION_LEFT = -1;
const BUTTON_POSITION_RIGHT = 1;

class Joystick extends GameControl {
  final MoveCallback onMove;

  Joystick({required this.onMove});

  @override
  void onStart(Canvas canvas, Size size, int current) {
    getGameControlGroup()?.addControl(Button(joystick: this, direction: BUTTON_POSITION_LEFT));
    getGameControlGroup()?.addControl(Button(joystick: this, direction: BUTTON_POSITION_RIGHT));
  }
}
```

### Button class

``` dart
class Button extends GameControl {
  final Joystick joystick;
  final int direction;

  Button({required this.joystick, required this.direction});

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
    joystick.onMove(direction);
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    joystick.onMove(0);
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    const radius = BUTTON_SIZE / 2;
    canvas.drawCircle(Offset(x + radius, y + radius), radius, paint);
  }
}
```