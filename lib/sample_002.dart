import 'package:flutter/material.dart';
import 'components/volume_slider.dart';

class Sample002 extends StatelessWidget {
  Sample002({Key? key}) : super(key: key) {
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
            child: VolumeSlider(
                min: 0,
                max: 100,
                width: 40,
                height: 200,
                onChanged: (double volume) { print(volume); },
              )
        )
    );
  }
}

