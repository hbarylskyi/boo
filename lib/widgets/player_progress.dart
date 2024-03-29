import 'dart:async';

import 'package:audiobooks_minimal/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

class PlayerProgress extends StatefulWidget {
  const PlayerProgress({Key? key}) : super(key: key);

  @override
  State<PlayerProgress> createState() => _PlayerProgressState();
}

class _PlayerProgressState extends State<PlayerProgress> {
  late final StreamSubscription _positionStream;
  late final StreamSubscription _durationStream;

  Duration _position = const Duration(seconds: 0);
  Duration _duration = const Duration(seconds: 0);

  @override
  void initState() {
    super.initState();

    _positionStream = audioHandler.appPlayer.positionStream.listen((event) {
      setState(() {
        _position = event;
      });
    });

    _durationStream = audioHandler.appPlayer.durationStream.listen((event) {
      setState(() {
        if (event == null) return;
        _duration = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
    _durationStream.cancel();
  }

  _seek(double newProgressPercentage) {
    int? currentFileDuration = audioHandler.appPlayer.duration?.inMilliseconds;

    if (currentFileDuration == null) return;

    int newPosition =
        (currentFileDuration * newProgressPercentage).toInt();

    // TODO move to audio service
    audioHandler.appPlayer.seek(Duration(milliseconds: newPosition));
  }

  @override
  Widget build(BuildContext context) {
    double percentage = _position.inMilliseconds / _duration.inMilliseconds;
    double progress = percentage.isNaN ? 0 : percentage;

    return ProgressBar(progress: progress, onSeek: _seek);
  }
}
