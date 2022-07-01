import 'package:flutter/material.dart';
import '../utils/ryulib/game_engine.dart';

typedef VolumeSliderCallback = void Function(double volume);

class VolumeSlider extends StatelessWidget {
  final VolumeSliderCallback onChanged;
  final double min;
  final double max;
  final double width;
  final double height;

  VolumeSlider({required this.onChanged, required this.min, required this.max, required this.width, required this.height}) {
    _sliderThumb = SliderThumb(this);
    _gameEngine.getControls().addControl(_sliderThumb);
    _gameEngine.start();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: _gameEngine.getCustomPaint()
    );
  }

  void setVolume(double value) {
    _sliderThumb.setVolume(value);
  }

  late SliderThumb _sliderThumb;
  final _gameEngine = GameEngine();
}

class SliderThumb extends GameControl {
  SliderThumb(VolumeSlider volumeSlider) {
    _volumeSlider = volumeSlider;
    _size = _volumeSlider!.max - _volumeSlider!.min;
    _height = _volumeSlider!.height;

    x = 10;
    y = _volumeSlider!.height;
    width = 20;
    height = 20;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2;

    _path.moveTo(_volumeSlider!.width / 2, _volumeSlider!.height);
    _path.lineTo((_volumeSlider!.width / 2) - 5, 0);
    _path.lineTo((_volumeSlider!.width / 2) + 5, 0);
    _path.lineTo(_volumeSlider!.width / 2, _volumeSlider!.height);
    _path.lineTo(_volumeSlider!.width / 2, 0);
  }

  @override
  void tick(Canvas canvas, Size size, int current, int term) {
    paint.color = Colors.grey;
    paint.style = PaintingStyle.fill;
    canvas.drawPath(_path, paint);

    paint.color = Colors.grey;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x + width / 2, y + height / 2), width / 2, paint);

    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(x + width / 2, y + height / 2), width / 2, paint);
  }

  void setVolume(double value) {
    y = _height - value * _height / _size;
  }

  void onHorizontalDragStart(DragStartDetails details) {
    bringToFront();
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    y = details.localPosition.dy - startY;
    if (y < 0) y = 0;
    if (y > _height) y = _height;

    double volume = _size * (_height - y) / _height;
    if (volume < _volumeSlider!.min) volume = _volumeSlider!.min;
    if (volume > _volumeSlider!.max) volume = _volumeSlider!.max;
    _volumeSlider?.onChanged(volume);
  }

  final _path = Path();
  double _height = 0;
  double _size = 0;
  VolumeSlider? _volumeSlider;
}
