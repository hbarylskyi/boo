import 'dart:async';
import 'package:audiobooks_minimal/main.dart';
import 'package:blur/blur.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'boo_audio_handler.dart';
import '../memory/memory_service.dart';

class BooksPlayer extends StatefulWidget {
  const BooksPlayer({Key? key}) : super(key: key);

  @override
  State<BooksPlayer> createState() => _BooksPlayerState();
}

//TODO encapsulate appPlayer
class _BooksPlayerState extends State<BooksPlayer> {
  late StreamSubscription _playerStateStream;
  late StreamSubscription _playbackEventStream;
  late StreamSubscription _sequenceStateStream;
  late StreamSubscription _speedStream;
  late StreamSubscription _positionStream;
  late StreamSubscription _durationStream;

  var appPlayer = audioHandler.appPlayer;

  final MemoryService _memory = MemoryService();
  late Timer _timer;
  bool _playing = false;
  String? _chapterName;
  String? _bookTitle;
  double _speed = 1;
  Duration? _duration;
  Duration _position = const Duration(seconds: 0);

  @override
  void initState() {
    super.initState();

    _sequenceStateStream = appPlayer.sequenceStateStream.listen((event) {
      var tag = event?.currentSource?.tag as MediaItem;

      setState(() {
        _chapterName = tag.title;
        _bookTitle = tag.artist;
        _duration = event?.currentSource?.duration;
      });
    });

    _playerStateStream = appPlayer.playerStateStream.listen((event) {
      setState(() {
        _playing = event.playing;
      });
    });

    _playbackEventStream = appPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        // TODO implement
      }
    });

    _speedStream = appPlayer.speedStream.listen((speedVal) {
      setState(() {
        _speed = speedVal;
      });
    });

    _positionStream = appPlayer.positionStream.listen((event) {
      setState(() {
        _position = event;
      });
    });

    _durationStream = appPlayer.durationStream.listen((event) {
      setState(() {
        _duration = event;
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!appPlayer.playing) return;

      _memory.setLastPlayedChapterPosition(appPlayer.position);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _playerStateStream.cancel();
    _playbackEventStream.cancel();
    _sequenceStateStream.cancel();
    _speedStream.cancel();
    _durationStream.cancel();
    _positionStream.cancel();
  }

  // OverlayEntry _createOverlayItem() {
  //   OverlayEntry oe = OverlayEntry(builder: (context) {
  //     return Positioned(
  //       height: 100,
  //       width: 100,
  //       child: SizedBox(height: 100, width: 100, child: Text('whatever!')),
  //     );
  //   });
  //
  //   Future.delayed(Duration(seconds: 5), () => oe.remove());
  //
  //   return oe;
  // }

  var height = 20;
  @override
  Widget build(BuildContext context) {
    var duration = _duration?.inSeconds;
    Color? primaryColor = CupertinoTheme.of(context).primaryColor;
    Color? primaryContrastingColor =
        CupertinoTheme.of(context).primaryContrastingColor;

    String speedText = '';

    if (_speed != 1) {
      var rounded = _speed.toStringAsFixed(2);
      speedText = ' x$rounded';
    }

    int value =
        (_position.inMilliseconds / _duration!.inMilliseconds * 100).toInt();

    int maxValue = 100;

    return Container(
      color: primaryColor,
      child: SafeArea(
        top: false,
        child: Column(children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('$_bookTitle - $_chapterName',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: primaryContrastingColor, fontSize: 14)),
                    ),
                    Text('($duration) $speedText',
                        style: TextStyle(
                            color: primaryContrastingColor, fontSize: 14)),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: value,
                      child: Container(
                        color: Colors.black87.withOpacity(0),
                        child: ClipRect(
                          child: BackdropFilter(
                              filter: const ColorFilter.matrix([
                                -1, 0, 0, 0,
                                255, // inverts colors under the filter
                                0, -1, 0, 0, 255, //
                                0, 0, -1, 0, 255, //
                                0, 0, 0, 1, 0, //
                              ]),
                              child: Container()),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: maxValue - value,
                      child: Container(
                        color: Colors.black87.withOpacity(0),
                      ),
                    ),
                    // Flexible(
                    //   flex: widget.maxValue - value,
                    //   child: Container(
                    //     color: Colors.black.withOpacity(0.3),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoButton(
                      child: Icon(CupertinoIcons.backward,
                          color: primaryContrastingColor),
                      onPressed: () => audioHandler.speedDown()),
                  CupertinoButton(
                      child: Icon(CupertinoIcons.arrow_counterclockwise,
                          color: primaryContrastingColor),
                      onPressed: () {
                        int position = appPlayer.position.inSeconds;

                        audioHandler.seek(Duration(seconds: position - 15));
                      }),
                  CupertinoButton(
                      child: Icon(
                          _playing
                              ? CupertinoIcons.pause
                              : CupertinoIcons.play_arrow,
                          color: primaryContrastingColor),
                      onPressed: () async {
                        _playing
                            ? await audioHandler.pause()
                            : await audioHandler.play();
                      }),
                  CupertinoButton(
                      child: Icon(
                        CupertinoIcons.arrow_clockwise,
                        color: primaryContrastingColor,
                      ),
                      onPressed: () {
                        int position = appPlayer.position.inSeconds;

                        appPlayer.seek(Duration(seconds: position + 15));
                      }),
                  CupertinoButton(
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Icon(CupertinoIcons.backward,
                            color: primaryContrastingColor),
                      ),
                      onPressed: () => audioHandler.speedUp()),
                  // GestureDetector(
                  //   onTapDown: (details) =>
                  //       audioHandler.speedUpLongPressStart(),
                  //   onTapUp: (details) => audioHandler.speedUpLongPressStop(),
                  //   // onPressed: audioHandler.speedUp,
                  //   child: RotatedBox(
                  //     quarterTurns: 2,
                  //     child: Icon(CupertinoIcons.backward,
                  //         color: primaryContrastingColor),
                  //   ),
                  // ),
                ]),
          ),
        ]),
      ),
    );
  }
}
