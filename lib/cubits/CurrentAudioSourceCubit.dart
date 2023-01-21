import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../main.dart';

class CurrentAudioSourceCubit extends Cubit<IndexedAudioSource?> {
  late StreamSubscription<SequenceState?> _sequenceStateStream;

  CurrentAudioSourceCubit() : super(null) {
    _sequenceStateStream =
        audioHandler.appPlayer.sequenceStateStream.listen((event) {
      var currentSource = event?.currentSource;

      if (currentSource == null) return;

      emit(currentSource);
    });
  }

  @override
  Future<void> close() {
    _sequenceStateStream.cancel();

    return super.close();
  }
}
