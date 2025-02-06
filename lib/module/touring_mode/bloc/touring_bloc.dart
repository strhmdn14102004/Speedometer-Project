import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speedometer/module/touring_mode/bloc/touring_event.dart';
import 'package:speedometer/module/touring_mode/bloc/touring_state.dart';

class TouringBloc extends Bloc<TouringEvent, TouringState> {
  StreamSubscription<Position>? _positionStream;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentTrack;

  TouringBloc() : super(TouringInitial()) {
    on<StartTouring>((event, emit) {
      final positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).listen((Position position) {
        final speed = position.speed * 3.6; // Convert m/s to km/h
        emit(TouringSpeedUpdated(speed));
      });

      _positionStream = positionStream;
    });

    on<StopTouring>((event, emit) async {
      await _positionStream?.cancel();
      emit(TouringInitial());
    });

    on<LoadMusicFiles>((event, emit) async {
      try {
        final musicDirectories = [
          Directory('/storage/emulated/0/Music'),
          Directory('/storage/emulated/0/Download'),
          Directory('/storage/emulated/0/Music'),
          Directory('/storage/emulated/0/'),
          Directory('/storage/emulated/0/Images'),
          Directory('/storage/emulated/0/DCIM'),
          Directory('/storage/emulated/0/Documents'),
          Directory('/storage/emulated/0/Ringtones'),
        ];

        final files = <String>[];

        for (var directory in musicDirectories) {
          if (directory.existsSync()) {
            files.addAll(
              directory
                  .listSync()
                  .where((file) =>
                      file is File && file.path.toLowerCase().endsWith('.mp3'))
                  .map((file) => file.path)
                  .toList(),
            );
          }
        }

        emit(TouringMusicLoaded(files));
      } catch (e) {
        emit(TouringMusicLoaded([]));
      }
    });

    on<PlayMusic>((event, emit) async {
      await _audioPlayer.setFilePath(event.filePath);
      _audioPlayer.play();
      _currentTrack = event.filePath;
      emit(TouringMusicPlaying(_currentTrack!));
    });

    on<PauseMusic>((event, emit) async {
      await _audioPlayer.pause();
      emit(TouringMusicPaused(_currentTrack ?? ''));
    });
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
