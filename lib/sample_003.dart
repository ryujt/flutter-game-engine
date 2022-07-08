import 'package:flutter/material.dart';
import 'components/box.dart';
import 'components/circle.dart';
import './utils/ryulib/game_engine.dart';

class Sample003 extends StatelessWidget {
  Sample003({Key? key}) : super(key: key) {
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