abstract class DashboardState {}

class DashboardLoaded extends DashboardState {
  final double speed;
  final int rpm;
  final double fuelLevel;
  final String streetName;
  final double distanceToDestination;
  final Duration estimatedTime;
  final double maxSpeed;
  final DateTime? maxSpeedTimestamp;
  final bool isTripActive;

  DashboardLoaded({
    required this.speed,
    required this.rpm,
    required this.fuelLevel,
    required this.streetName,
    required this.distanceToDestination,
    required this.estimatedTime,
    required this.maxSpeed,
    this.maxSpeedTimestamp,
    this.isTripActive = false,
  });
}