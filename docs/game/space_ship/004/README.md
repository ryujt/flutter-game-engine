# 슈팅 게임만들기 #4


## 학습목표

* 게임 컨트롤 끼리 충돌했는 지를 확인하고 처리하는 방법을 배웁니다.


## 소행성 충돌 테스트

![](./pic-2.png)

### asteroids.dart

``` dart
...
typedef CheckCollisionCallback = bool Function(GameControl target);

class Asteroids extends GameControl {
  final CheckCollisionCallback onCheckCollision;

  Asteroids({required this.onCheckCollision});

  void _createAsteroid(Size size) {
    var _x = _random.nextDouble() * (size.width - ASTEROID_SIZE);
    getGameControlGroup()?.addControl(Asteroid(_x, 0, onCheckCollision));
  }
  ...
}

class Asteroid extends GameControl {
  Asteroid(double ax, double ay, CheckCollisionCallback onCheckCollision)
  {
    ...
    _onCheckCollision = onCheckCollision;
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    ...
    if (_onCheckCollision != null) {
      if (_onCheckCollision!(this)) deleted = true;
    }
  }

  double _speed = 2;
  CheckCollisionCallback? _onCheckCollision;
}
```

### ship.dart

``` dart
...
class Ship extends GameControl {
  ...
  bool checkCollisionAndExplode(GameControl target) {
    var result = checkCollision(target);
    if (result) deleted = true;
    return result;
  }
  ...
}
```
