import 'package:flutter/material.dart';
import 'game_engine.dart';

class Sample000 extends StatelessWidget {
  Sample000({Key? key}) : super(key: key) {
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
