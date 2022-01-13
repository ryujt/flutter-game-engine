import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameEngine {
  GameEngine() {
    //
  }

  void start() {
    _scheduler.start();
  }

  void stop() {
    _scheduler.stop();
  }

  Widget getCustomPaint() {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Obx(() {
        _refresh.value;
        return CustomPaint(
            painter: GamePainter(_controls, _scheduler._tick.value, _scheduler._term),
        );
      })
    );
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _selectedControl = _controls.selectControl(details.localPosition.dx, details.localPosition.dy);
    if (_selectedControl == null) return;

    _selectedControl!.onHorizontalDragStart(details);
    _selectedControl!._startX = details.localPosition.dx - _selectedControl!.x;
    _selectedControl!._startY = details.localPosition.dy - _selectedControl!.y;

    _refresh.value++;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _selectedControl?.onHorizontalDragUpdate(details);
    _refresh.value++;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _selectedControl?.onHorizontalDragEnd(details);
    _refresh.value++;
  }

  GameControlGroup getControls() { return _controls; }

  GameControl? _selectedControl = null;
  GameControlGroup _controls = GameControlGroup();
  Scheduler _scheduler = Scheduler();

  final _refresh = RxInt(0);
}

class Scheduler {
  void start() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 5), (timer) {
      int tick = _stopwatch.elapsedMilliseconds;
      if (tick > _oldTick) {
        _term = tick - _oldTick;
      } else {
        _term = 0;
      }
      _oldTick = _tick.value;
      _tick.value = tick;
    });
  }

  void stop() {
    _timer?.cancel();
  }

  var _tick = RxInt(0);
  int _oldTick = 0;
  int _term = 0;

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer = null;
}

class GamePainter extends CustomPainter {
  GameControlGroup controlGroup;
  int current;
  int term;
  GamePainter(this.controlGroup, this.current, this.term);

  @override
  void paint(Canvas canvas, Size size) {
    controlGroup.tick(canvas, current, term);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GameControl {
  void tick(Canvas canvas, int current, int term) {}

  void onHorizontalDragStart(DragStartDetails details) {}
  void onHorizontalDragUpdate(DragUpdateDetails details) {}
  void onHorizontalDragEnd(DragEndDetails details) {}

  // TODO: HitArea
  /// 주어진 좌표가 내 안에 있는가?
  bool checkArea(double tx, double ty) {
    return
      (tx >= x) && (tx <= (x + width)) &&
      (ty >= y) && (ty <= (y + height));
  }

  void sendToBack() {
    if (_gameControlGroup == null) return;

    _gameControlGroup!._controls.remove(this);
    _gameControlGroup!._controls.insert(0, this);
  }

  void bringToFront() {
    if (_gameControlGroup == null) return;

    _gameControlGroup!._controls.remove(this);
    _gameControlGroup!._controls.add(this);
  }

  GameControl? checkCollision(GameControl target) {
    if (_gameControlGroup == null) return null;
    for (var control in _gameControlGroup!._controls) {
      if (control == this) continue;
      if (_controlCollision(this, control)) return control;
    }
    return null;
  }

  List<GameControl> checkCollisions() {
    List<GameControl> list = <GameControl>[];
    if (_gameControlGroup == null) return list;
    for (var control in _gameControlGroup!._controls) {
      if (control == this) continue;
      if (_controlCollision(this, control)) list.add(control);
    }
    return list;
  }

  bool _controlCollision(GameControl a, GameControl b) {
    return
      _lineCollision(a.x, a.x + a.width,  b.x, b.x + b.width) &&
      _lineCollision(a.y, a.y + a.height, b.y, b.y + b.height);
  }

  bool _lineCollision(double s1, double e1, double s2, double e2) {
    return _lineCollisionSub(s1, e1, s2, e2) || _lineCollisionSub(s2, e2, s1, e1);
  }

  bool _lineCollisionSub(double s1, double e1, double s2, double e2) {
    return ((s2 >= s1) && (s2 <= e1)) || ((e2 >= s1) && (e2 <= e1));
  }

  double x = 0;
  double y = 0;
  double width = 32;
  double height = 32;
  bool visible = true;

  Paint _paint = Paint();
  Paint get paint => _paint;

  bool _deleted = false;
  bool get deleted => _deleted;
  set deleted(bool value) {
    _deleted = value;

    // 동작 중인 컨트롤를 리스트에서 바로 삭제하면 index 에러가 발생한다. (배치 처리)
    _gameControlGroup?.addDeleteControl(this);
  }

  double _startX = 0;
  double get startX => _startX;

  double _startY = 0;
  double get startY => _startY;

  GameControlGroup? _gameControlGroup = null;
}

class GameControlGroup extends GameControl {
  void addControl(GameControl control) {
    control._gameControlGroup = this;
    _controls.add(control);
  }

  void addDeleteControl(GameControl control) {
    _deletedControls.add(control);
  }

  GameControl? selectControl(double x, double y) {
    for (var i=_controls.length-1; i>=0; i--) {
      if (_controls[i].checkArea(x, y)) return _controls[i];
    }
    return null;
  }

  @override
  void tick(Canvas canvas, int current, int term) {
    for (var control in _controls) {
      if (control.deleted == false) control.tick(canvas, current, term);
    }
    _deleteControls();
  }

  void _deleteControls() {
    for (var control in _deletedControls) {
      _controls.remove(control);
    }
    _deletedControls.clear();
  }

  List<GameControl> _controls = <GameControl>[];
  List<GameControl> _deletedControls = <GameControl>[];
}