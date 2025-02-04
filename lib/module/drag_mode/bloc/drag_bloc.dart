import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedometer/module/drag_mode/bloc/drag_event.dart';
import 'package:speedometer/module/drag_mode/bloc/drag_state.dart';

class SpeedBloc extends Bloc<SpeedEvent, SpeedState> {
  StreamSubscription<Position>? _positionStream;
  double _maxSpeed = 0.0;
  double _speedSum = 0.0;
  int _speedCount = 0;
  DateTime? _startTime;

  SpeedBloc() : super(SpeedInitial()) {
    // Handler untuk StartTracking
    on<StartTracking>((event, emit) async {
      _maxSpeed = 0.0;
      _speedSum = 0.0;
      _speedCount = 0;
      _startTime = DateTime.now();

      final positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).listen((Position position) {
        final speed = position.speed * 3.6; // Convert m/s to km/h
        _speedSum += speed;
        _speedCount++;
        if (speed > _maxSpeed) _maxSpeed = speed;
        emit(SpeedUpdated(speed));
      });

      _positionStream = positionStream;
    });

    // Handler untuk StopTracking
    on<StopTracking>((event, emit) async {
      await _positionStream?.cancel();
      final stopTime = DateTime.now();
      final averageSpeed = _speedCount > 0 ? _speedSum / _speedCount : 0.0;

      emit(SpeedSessionResult(
        maxSpeed: _maxSpeed,
        averageSpeed: averageSpeed,
        startTime: _startTime ?? DateTime.now(),
        stopTime: stopTime,
      ));
    });

    // Handler untuk ResetSession
    on<ResetSession>((event, emit) async {
      await _positionStream?.cancel();
      _maxSpeed = 0.0;
      _speedSum = 0.0;
      _speedCount = 0;
      _startTime = null;
      emit(SpeedInitial()); // Kembali ke state awal
    });
  }
}
