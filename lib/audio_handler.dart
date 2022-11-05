import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';

// class AudioPlayer extends StatefulWidget {
//   const AudioPlayer({Key? key}) : super(key: key);
//
//   @override
//   State<AudioPlayer> createState() => _AudioPlayerState();
// }
//
// class _AudioPlayerState extends State<AudioPlayer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//     );
//   }
// }

class AudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler  {
  // The most common callbacks:
  // Future<void> play() async {
  //   // All 'play' requests from all origins route to here. Implement this
  //   // callback to start playing audio appropriate to your app. e.g. music.
  // }

  Future<void> pause() async {}
  Future<void> stop() async {}
  Future<void> seek(Duration position) async {}
  Future<void> skipToQueueItem(int i) async {}
}
