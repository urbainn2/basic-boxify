import 'dart:math';
import 'package:flutter/material.dart';
import 'package:boxify/core.dart';
import 'package:boxify/enums/enums.dart';

class SeekBar extends StatefulWidget {
  final SeekBarType type;
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    super.key,
    required this.type,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      thumbColor: Colors.white,

      /// color or the slider when it is active
      activeTrackColor: Colors.white,

      /// color of the slider when it is being dragged
      overlayColor: Core.appColor.primary,

      /// doesn't seem to do anything
      inactiveTrackColor: Colors.grey,

      trackHeight: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxPos = widget.duration.inMilliseconds.toDouble();
    var value = widget.position.inMilliseconds.toDouble();
    if (value > maxPos) {
      value = 0;
    }
    final double bottomPostion;
    final double leftPosition;
    final double rightPosition;

    if (widget.type == SeekBarType.small) {
      bottomPostion = -3.0;
      leftPosition = 2.0;
      rightPosition =
          2.0; // a farther from 0 negative number seems to make it wider, away from the slider
    } else {
      bottomPostion = 0.0;
      leftPosition = -20.0;
      rightPosition =
          -20.0; // a farther from 0 negative number seems to make it wider, away from the slider
    }

    // double screenWidth = MediaQuery.of(context).size.width;
    // double sliderWidth =
    //     max(0, screenWidth - 40 * 2 - 10 * 2); // subtracts the required padding

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // THE SLIDER THUMB WIDGET
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 10,
            // width: sliderWidth,
            child: SliderTheme(
              data: _sliderThemeData.copyWith(
                thumbShape: HiddenThumbComponentShape(),
                activeTrackColor: Core.appColor.primary,
                inactiveTrackColor: Colors.grey.shade300,
              ),
              child: ExcludeSemantics(
                child: Slider(
                  max: maxPos,
                  value: value,
                  onChanged: (value) {
                    setState(() {
                      _dragValue = value;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(Duration(milliseconds: value.round()));
                    }
                  },
                  onChangeEnd: (value) {
                    if (widget.onChangeEnd != null) {
                      widget
                          .onChangeEnd!(Duration(milliseconds: value.round()));
                    }
                    _dragValue = null;
                  },
                ),
              ),
            ),
          ),
        ),
        // THE SLIDER TRACK
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 10,
            // width: sliderWidth,
            child: SliderTheme(
              data: _sliderThemeData.copyWith(
                inactiveTrackColor: Colors.grey,
              ),
              child: Slider(
                min: 0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble(),
                ),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null;
                },
              ),
            ),
          ),
        ),
        // THE LEFT TIME ELAPSED
        Positioned(
          left: leftPosition,
          bottom: bottomPostion,
          child: Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                    .firstMatch('$_elapsed')
                    ?.group(1) ??
                '$_elapsed',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey[100], fontSize: 12),
          ),
        ),
        // THE RIGHT TIME TOTAL
        Positioned(
          right: rightPosition,
          bottom: bottomPostion,
          child: Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                    .firstMatch('${widget.duration}')
                    ?.group(1) ??
                '${widget.duration}',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey[100], fontSize: 12),
          ),
        ),
      ],
    );
  }

  // Duration get _remaining => widget.duration - widget.position;
  Duration get _elapsed => widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}
