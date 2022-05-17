import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameEngine {
  GameEngine() {
    _controls._gameEngine = this;
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
    controlGroup.repeat(canvas, size, current, term);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GameControl {
  /**
   * 게임 엔진이 주기적으로 실행하는 메소드 (타임 슬라이스)
   */
  void repeat(Canvas canvas, Size size, int current, int term) {
    if (_started == false) {
      _started = true;
      onStart(canvas, size, current);
    }

    if (visible) tick(canvas, size, current, term);
  }

  /**
   * 게임 컨트롤의 그리기와 프로세스 구현을 상속받아서 처리한다.
   * @param canvas 게임엔진 화면 그리기 겍체
   * @param size 게임 엔진의 화면 크기
   * @param current 게임엔진이 시작된 이후 흐른 시간 (ms)
   * @param term 이전 tick과의 간격 (ms)
   */
  void tick(Canvas canvas, Size size, int current, int term) {}

  /**
   * 게임 엔진에서 처음으로 tick이 실행되기 전 한 번만 발생
   * @param canvas 게임엔진 화면 그리기 겍체
   * @param size 게임 엔진의 화면 크기
   * @param current 게임엔진이 시작된 이후 흐른 시간 (ms)
   */
  void onStart(Canvas canvas, Size size, int current) {}

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
    _gameControlGroup?._sendToBackControls.add(this);
  }

  void bringToFront() {
    _gameControlGroup?._bringToFrontControls.add(this);
  }

  bool checkCollision(GameControl target) {
    return _controlCollision(this, target);
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

  GameEngine? getGameEngine() { return _gameEngine; }

  GameControlGroup? getGameControlGroup() { return _gameControlGroup; }

  bool _controlCollision(GameControl a, GameControl b) {
    if (a.deleted) return false;
    if (b.deleted) return false;

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

  GameEngine? _gameEngine;

  double x = 0;
  double y = 0;
  double width = 32;
  double height = 32;
  bool visible = true;

  Paint _paint = Paint();
  Paint get paint => _paint;

  bool _started = false;
  bool _deleted = false;
  bool get deleted => _deleted;
  set deleted(bool value) {
    _deleted = value;

    // 동작 중인 컨트롤를 리스트에서 바로 삭제하면 index 에러가 발생한다. (배치 처리)
    _gameControlGroup?.deleteControl(this);
  }

  double _startX = 0;
  double get startX => _startX;

  double _startY = 0;
  double get startY => _startY;

  GameControlGroup? _gameControlGroup;
}

class GameControlGroup extends GameControl {
  void addControl(GameControl control) {
    control._gameEngine = _gameEngine;
    control._gameControlGroup = this;
    _tobeAddControls.add(control);
  }

  void deleteControl(GameControl control) {
    _deletedControls.add(control);
  }

  GameControl? selectControl(double x, double y) {
    for (var i=_controls.length-1; i>=0; i--) {
      if (_controls[i] is GameControlGroup) {
        var control = (_controls[i] as GameControlGroup).selectControl(x, y);
        if (control != null) return control;
      } else {
        if (_controls[i].checkArea(x, y)) return _controls[i];
      }
    }
    return null;
  }

  @override
  void repeat(Canvas canvas, Size size,int current, int term) {
    super.repeat(canvas, size, current, term);
    for (var control in _controls) {
      if (control.deleted == false) control.repeat(canvas, size, current, term);
    }
    _arrangeControls();
  }

  void _arrangeControls() {
    for (var control in _tobeAddControls) {
      _controls.add(control);
    }
    _tobeAddControls.clear();

    for (var control in _deletedControls) {
      _controls.remove(control);
    }
    _deletedControls.clear();

    for (var control in _sendToBackControls) {
      _controls.remove(control);
      _controls.insert(0, control);
    }
    _sendToBackControls.clear();

    for (var control in _bringToFrontControls) {
      _controls.remove(control);
      _controls.add(control);
    }
    _bringToFrontControls.clear();
  }

  List<GameControl> _controls = <GameControl>[];
  List<GameControl> _tobeAddControls = <GameControl>[];
  List<GameControl> _deletedControls = <GameControl>[];
  List<GameControl> _sendToBackControls = <GameControl>[];
  List<GameControl> _bringToFrontControls = <GameControl>[];
}