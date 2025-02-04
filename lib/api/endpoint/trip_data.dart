import 'dart:convert';

class TripData {
  final DateTime startTime;
  final DateTime endTime;
  final double maxSpeed;
  final double averageSpeed;
  final double distance;

  TripData({
    required this.startTime,
    required this.endTime,
    required this.maxSpeed,
    required this.averageSpeed,
    required this.distance,
  });

  // Konversi objek TripData ke JSON String
  String toJson() {
    return jsonEncode({
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'maxSpeed': maxSpeed,
      'averageSpeed': averageSpeed,
      'distance': distance,
    });
  }

  // Buat TripData dari JSON String
  factory TripData.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return TripData(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      maxSpeed: (json['maxSpeed'] as num).toDouble(),
      averageSpeed: (json['averageSpeed'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
    );
  }
}
