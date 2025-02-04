abstract class DashboardEvent {}

class StartTracking extends DashboardEvent {}

class UpdateMaxSpeed extends DashboardEvent {
  final double maxSpeed;
  final DateTime timestamp;

  UpdateMaxSpeed({required this.maxSpeed, required this.timestamp});
}
