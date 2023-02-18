import 'package:flutter/cupertino.dart';

/// Base widget for progress bars

class ProgressBar extends StatefulWidget {
  final double progress;
  final Function(double) onSeek;

  const ProgressBar({Key? key, required this.progress, required this.onSeek})
      : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  final List<double> _colorFilterMatrix = [
    -1, 0, 0, 0,
    255, // inverts colors under the filter
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
  ];

  late final GlobalKey _progressBarWidget = GlobalKey();
  final double _progressBarHeight = 35;

  _onTapDown(TapDownDetails details) {
    _seek(details.localPosition.dx);
  }

  _onPanUpdate(DragUpdateDetails details) {
    _seek(details.localPosition.dx);
  }

  _seek(double dx) {
    double progressBarWidth =
        _progressBarWidget.currentContext?.size?.width ?? 0;
    double newProgress = dx / progressBarWidth;

    if (newProgress.isNaN) return;

    widget.onSeek(newProgress);
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = CupertinoTheme.of(context).primaryColor;
    int magicNumber = 100000;

    int flex = (widget.progress * magicNumber).toInt();

    return GestureDetector(
      key: _progressBarWidget,
      onTapDown: _onTapDown,
      onPanUpdate: _onPanUpdate,
      child: SizedBox(
        height: _progressBarHeight,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: flex,
              child: Container(
                color: primaryColor.withOpacity(0),
                child: ClipRect(
                  child: BackdropFilter(
                      filter: ColorFilter.matrix(_colorFilterMatrix),
                      child: Container()),
                ),
              ),
            ),
            Flexible(
              flex: magicNumber - flex,
              child: Container(color: primaryColor.withOpacity(0)),
            ),
          ],
        ),
      ),
    );
  }
}
