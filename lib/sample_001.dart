import 'package:flutter/material.dart';
import 'components/animated_circle.dart';
import './utils/ryulib/game_engine.dart';

class Sample001 extends StatelessWidget {
  Sample001({Key? key}) : super(key: key) {
    _gameEngine.getControls().addControl(AnimatedCircle());
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
