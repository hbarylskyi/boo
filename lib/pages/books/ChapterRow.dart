import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../common/Chapter.dart';
import '../../cubits/CurrentAudioSourceCubit.dart';
import '../../main.dart';
import '../../widgets/player_progress.dart';

class ChapterRow extends StatelessWidget {
  Chapter chapter;
  CurrentAudioSourceCubit currentAudioSourceCubit = CurrentAudioSourceCubit();

  ChapterRow({super.key, required this.chapter});

  onDispose() {
    currentAudioSourceCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            CupertinoButton(
                onPressed: () => audioHandler.playChapter(chapter),
                child: Text(chapter.name)),

            BlocBuilder<CurrentAudioSourceCubit, IndexedAudioSource?>(
                bloc: currentAudioSourceCubit,
                builder: (BuildContext context, currentAudioSource) {
                  String? path = currentAudioSource?.tag?.id;

                  if (path != null) {
                    bool isPlaying = File(path).uri == chapter.file.uri;

                    if (isPlaying) {
                      return PlayerProgress();
                    }
                  }

                  return Container();
                }),

            // Text('currentAudioSource?.tag.title')
          ],
        ),
      ],
    );
  }
}
