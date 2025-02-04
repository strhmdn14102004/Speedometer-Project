import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_sasat/module/home/home_event.dart';
import 'package:weather_sasat/module/home/home_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  Position? previousPosition;
  double totalDistance = 0.0;
  double fuelLevel = 100.0; // Bahan bakar mulai dari 100%
  double maxSpeed = 0.0;
  DateTime? maxSpeedTimestamp;

  DashboardBloc()
      : super(DashboardLoaded(
          speed: 0.0,
          rpm: 0,
          fuelLevel: 100.0,
          streetName: "Lokasi belum ditemukan",
          distanceToDestination: 0.0,
          estimatedTime: const Duration(minutes: 0),
          maxSpeed: 0.0,
        )) {
    on<StartTracking>((event, emit) async {
      bool isLocationEnabled = await _checkLocationPermission();
      if (!isLocationEnabled) {
        return;
      }

      Geolocator.getPositionStream(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      ).listen((position) {
        double speed = position.speed * 3.6; // Convert m/s to km/h
        int rpm = (speed * 50).toInt(); // Mock RPM calculation

        if (previousPosition != null) {
          double distance = Geolocator.distanceBetween(
                previousPosition!.latitude,
                previousPosition!.longitude,
                position.latitude,
                position.longitude,
              ) /
              1000; // Convert to kilometers
          totalDistance += distance;

          // Kurangi bahan bakar berdasarkan jarak tempuh
          double fuelConsumption = distance * (100 / 272);
          fuelLevel =
              (fuelLevel - fuelConsumption).clamp(0, 100); // Clamp antara 0-100
        }

        // Cek dan update kecepatan maksimum
        if (speed > maxSpeed) {
          maxSpeed = speed;
          maxSpeedTimestamp = DateTime.now();
        }

        previousPosition = position;

        emit(DashboardLoaded(
          speed: speed,
          rpm: rpm,
          fuelLevel: fuelLevel,
          streetName: "Tracking Street",
          distanceToDestination: totalDistance,
          estimatedTime: Duration(
              minutes: (totalDistance / speed).isFinite
                  ? (totalDistance / speed).round()
                  : 0),
          maxSpeed: maxSpeed,
          maxSpeedTimestamp: maxSpeedTimestamp,
        ));
      });
    });
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      return false;
    }

    return true;
  }
}
