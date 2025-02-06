abstract class SpeedState {}

class SpeedInitial extends SpeedState {}

class SpeedUpdated extends SpeedState {
  final double speed;
  SpeedUpdated(this.speed);
}

class SpeedSessionResult extends SpeedState {
  final double maxSpeed;
  final double averageSpeed;
  final DateTime startTime;
  final DateTime stopTime;
  SpeedSessionResult({
    required this.maxSpeed,
    required this.averageSpeed,
    required this.startTime,
    required this.stopTime,
  });
}
