import 'package:audiobooks_minimal/main.dart';
import 'package:flutter/cupertino.dart';

class ProgressBar extends StatefulWidget {
  final double progress;

  const ProgressBar({Key? key, required this.progress}) : super(key: key);

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

  _onTapDown(TapDownDetails details) {
    _seek(details.localPosition.dx);
  }

  _onPanUpdate(DragUpdateDetails details) {
    _seek(details.localPosition.dx);
  }

  _seek(double dx) {
    setState(() {
      double width = _progressBarWidget.currentContext?.size?.width ?? 0;

      double newProgress = dx / width;

      if (!newProgress.isNaN) {
        int? durationMillis = audioHandler.appPlayer.duration?.inMilliseconds;

        if (durationMillis == null) return;

        int newPosition = (durationMillis * newProgress).toInt();

        audioHandler.appPlayer.seek(Duration(milliseconds: newPosition));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = CupertinoTheme.of(context).primaryColor;
    double height = 35;

    int flexInt = (widget.progress * 100000).toInt();

    return GestureDetector(
      key: _progressBarWidget,
      onTapDown: _onTapDown,
      onPanUpdate: _onPanUpdate,
      child: SizedBox(
        height: height,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: flexInt,
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
              flex: 100000 - flexInt,
              child: Container(color: primaryColor.withOpacity(0)),
            ),
          ],
        ),
      ),
    );
  }
}
