import 'package:flutter/material.dart';

import 'package:temp/sample_001.dart';
import 'package:temp/sample_002.dart';

import 'package:temp/game/space_ship_001/space_ship.dart';

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
      home: Sample002(),
    );
  }
}