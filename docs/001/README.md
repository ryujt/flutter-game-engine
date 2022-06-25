#  Flutter GameEngine의 소개

## 개요

다용도로 사용할 수 있는 아주 가벼운 게임 엔진입니다.
특수 목적의 Flutter Custom Widget을 개발하다가 만들어진 라이브러리입니다.

> 현재(2022.01.13) 아애와 같은 기능들이 구현되지 않은 상태입니다.
> * 해상도에 영향 받지 않는 좌표계 처리
> * HitArea는 기본 영역으로 대체해서 처리
> * 메시지 루프에 의한 이벤트 버스 구현 안됨

### 사용의 예

![](./pic-07.png)


## 기본 사용법

### main.dart

``` dart
import 'package:flutter/material.dart';
import 'package:temp/sample_000.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameEngine Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // 이 부분만 수정하면 준비된 예제를 모두 테스트해 볼 수 있습니다.
      home: Sample000(),
    );
  }
}
```
* main.dart는 아주 기본적인 앱의 초기화 부분만 구현되어 있습니다.
* home 영역에 Sample000() 부분만 예제에 맞춰서 변경해주시면 테스트하실 수 있도록 하였습니다.
* 현재 준비된 예제는 Sample000(), Sample001(), Sample002(), Sample003(), SpaceShip() 등이 있습니다.


### 간단한 원 그리기

#### 실행결과

![](./pic-03.png)

#### sample_000.dart

``` dart
import 'package:flutter/material.dart';
import 'components/simple_circle.dart';
import 'game_engine.dart';

class Sample000 extends StatelessWidget {
  Sample000({Key? key}) : super(key: key) {
    _gameEngine.getControls().addControl(SimpleCircle());
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
```
* 25: GameEngine 클래스의 인스턴스를 생성합니다.
* 6-9: MyHomePage의 생성자에서 GameEngine을 초기화 합니다.
  * 7: 게임엔진이 처리할 SimpleCircle의 인스턴스를 생성해서 추가합니다.
  * 8: 게임엔진을 시작합니다.
* 17-21: 화면의 body 부분에 게임엔진 위젯을 덮어 씌웁니다. 참고로 게임엔진은 CustomPaint를 이용해서 만들어 져 있습니다.

#### simple_circle.dart

아래는 화면에 원을 그리는 게임 컨트롤 SimpleCircle의 코드입니다.

``` dart
import 'package:flutter/material.dart';
import '../game_engine.dart';

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
```
* 5-13: SimpleCircle의 초기화 부분입니다.
  * 6-7: x, y는 인스턴스의 좌표입니다.
  * 8-9: width, height는 인스턴스의 크기입니다.
  * 10-12: paint는 Canvas의 그리기에 필요한 인스턴스로 색상 등의 속성들을 지정하게 됩니다.
* 15-18: 게임엔진이 주기적으로 모든 게임 컨트롤 인스턴스의 tick() 메소드를 실행하게 됩니다.
  그리기 및 각 객체의 논리적인 구현은 이 메소드를 통해서 처리하면 됩니다.
  * 17: canvas의 drawCircle() 메소드를 이용해서 원을 그립니다.



### 간단한 애니메이션 처리

#### 실행결과

![](./pic-04.png)

#### main.dart

기존 코드와 유사하기 때문에 달라진 부분만 표시하였습니다.

``` dart
...
class MyApp extends StatelessWidget {
  ...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
      home: Sample001(),
    );
  }
}
```

#### sample_001.dart

sample_000.dart과 유사하기 때문에 달라진 부분만 표시하였습니다.

``` dart
...
class Sample001 extends StatelessWidget {
  Sample001({Key? key}) : super(key: key) {
    _gameEngine.getControls().addControl(SimpleCircle());
    _gameEngine.start();
  }
  ...
}
```

### animated_circle.dart

``` dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../game_engine.dart';

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
```
* 12: 원을 채워서 그리기 위해서 fill 옵션을 사용중입니다.
* 15-19: 게임엔진이 주기적으로 모든 게임 컨트롤 인스턴스의 tick() 메소드를 실행하게 됩니다.
  * current: 게임엔진이 시작된 이후로 지난 시간이 밀리초 단위로 전달됩니다.
  * term: 바로 이전에 tick()이 실행 된 이후 지난 시간이 밀리초 단위로 전달됩니다.
  * 17: 원의 크기를 sin() 함수를 이용해서 시간의 흐름 따라 변경합니다.
  * 18: canvas의 drawCircle() 메소드를 이용해서 원을 그립니다.


### Drag & Drop

#### 실행결과

![](./pic-05.png)

#### main.dart

기존 코드와 유사하기 때문에 달라진 부분만 표시하였습니다.

``` dart
...
class MyApp extends StatelessWidget {
  ...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
      home: Sample002(),
    );
  }
}
```

#### sample_002.dart

sample_000.dart과 유사하기 때문에 달라진 부분만 표시하였습니다.

``` dart
...
class Sample002 extends StatelessWidget {
  Sample002({Key? key}) : super(key: key) {
    _gameEngine.getControls().addControl(BoxControl());
    _gameEngine.start();
  }
  ...
}
```

#### box.dart

``` dart
import 'package:flutter/material.dart';
import '../game_engine.dart';

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
```
* 21-23: onHorizontalDragStart()는 BoxControl 인스턴스의 위치에서 터치가 시작되면 실행되는 메소드입니다.
  * 22: 여러 인스턴스가 겹쳐 있으면 가장 위에 있는 인스턴스만 선택됩니다. 선택된 객체를 맨 앞으로 표시하도록 합니다.
* 25-29: onHorizontalDragUpdate()는 터치 이후 위치가 이동되면 실행되는 메소드입니다.
  * 27-28: 현재의 터치된 위치에서 처음 터치한 위치의 값을 뺀만큼 이동한 것이 됩니다.
  * startX, startY는 게임엔진에서 처리해줍니다.

### 충돌 테스트

#### 실행결과

![](./pic-06.png)

#### sample_002.dart

기존 코드에서 CircleControl() 부분을 추가합니다.

``` dart
...
class Sample002 extends StatelessWidget {
  Sample002({Key? key}) : super(key: key) {
    _gameEngine.getControls().addControl(BoxControl());
    _gameEngine.getControls().addControl(CircleControl()); // 추가됨
    _gameEngine.start();
  }
  ...
}
```

#### circle.dart

``` dart
import 'package:flutter/material.dart';
import '../game_engine.dart';

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
```
기본적으로는 BoxControl과 유사합니다. 다른 점에 대해서 설명합니다.
* 20-224 이둥 중인 경우에는 회색으로 표시해서 드래그 중인 것을 알 수 있도록 하고 있습니다.
  실제 원은 계속 그대로 표시되고 회색 원이 새로 나타나서 현재의 위치에 표시 됩니다.
* 30: 드래그가 시작되는 것을 _dragging 플래그를 이용해서 구별하도록 합니다.
* 41: 드래그를 중단합니다.
* 43-44: 드래그 된 위치로 현재 위치를 변경합니다.
  실제 원의 위치가 이제야 변경됩니다.
* 46-49: 현재 인스턴스와 충돌된 모든 인스턴스를 불러옵니다.
  * 48: 충돌한 인스터스의 deleted를 true로 변경하면 게임엔진에 의해서 삭제됩니다.
