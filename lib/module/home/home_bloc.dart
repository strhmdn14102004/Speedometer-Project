import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedometer/api/endpoint/trip_data.dart';
import 'package:speedometer/module/home/home_event.dart';
import 'package:speedometer/module/home/home_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  Position? previousPosition;
  double totalDistance = 0.0;
  double fuelLevel = 100.0;
  double maxSpeed = 0.0;
  DateTime? maxSpeedTimestamp;
  DateTime? tripStartTime;
  DateTime? tripEndTime;
  List<double> speedHistory = [];
  bool isTripActive = false;
  StreamSubscription<Position>? positionStream;

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
    on<StartTracking>(_onStartTracking);
    on<EndTracking>(_onEndTracking);
  }

  Future<void> _onStartTracking(
      StartTracking event, Emitter<DashboardState> emit) async {
    bool isLocationEnabled = await _checkLocationPermission();
    if (!isLocationEnabled) {
      return;
    }

    isTripActive = true;
    tripStartTime = DateTime.now();
    speedHistory.clear();
    totalDistance = 0.0;
    fuelLevel = 100.0;
    maxSpeed = 0.0;
    maxSpeedTimestamp = null;
    previousPosition = null;

    positionStream?.cancel(); // Hentikan stream sebelumnya jika ada

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((position) {
      double speed = position.speed * 3.6; // Konversi m/s ke km/h
      int rpm = (speed * 50).toInt(); // Simulasi RPM

      if (previousPosition != null) {
        double distance = Geolocator.distanceBetween(
              previousPosition!.latitude,
              previousPosition!.longitude,
              position.latitude,
              position.longitude,
            ) /
            1000; // Konversi ke km
        totalDistance += distance;

        // Kurangi bahan bakar berdasarkan jarak tempuh
        double fuelConsumption = distance * (100 / 272);
        fuelLevel = (fuelLevel - fuelConsumption).clamp(0, 100);
      }

      if (speed > maxSpeed) {
        maxSpeed = speed;
        maxSpeedTimestamp = DateTime.now();
      }

      speedHistory.add(speed);
      previousPosition = position;

      emit(DashboardLoaded(
        speed: speed,
        rpm: rpm,
        fuelLevel: fuelLevel,
        streetName: "Tracking Street",
        distanceToDestination: totalDistance,
        estimatedTime: Duration(
            minutes: speed > 0 ? (totalDistance / speed).round() : 0),
        maxSpeed: maxSpeed,
        maxSpeedTimestamp: maxSpeedTimestamp,
        isTripActive: isTripActive,
      ));
    });
  }

  void _onEndTracking(EndTracking event, Emitter<DashboardState> emit) {
    isTripActive = false;
    tripEndTime = DateTime.now();
    positionStream?.cancel(); // Hentikan tracking lokasi
    _saveTripData();

    emit(DashboardLoaded(
      speed: 0.0,
      rpm: 0,
      fuelLevel: fuelLevel,
      streetName: "Lokasi belum ditemukan",
      distanceToDestination: totalDistance,
      estimatedTime: const Duration(minutes: 0),
      maxSpeed: maxSpeed,
      maxSpeedTimestamp: maxSpeedTimestamp,
      isTripActive: isTripActive,
    ));
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
    return isLocationServiceEnabled;
  }

  void _saveTripData() {
    double averageSpeed = speedHistory.isNotEmpty
        ? speedHistory.reduce((a, b) => a + b) / speedHistory.length
        : 0.0;

    TripData tripData = TripData(
      startTime: tripStartTime!,
      endTime: tripEndTime!,
      maxSpeed: maxSpeed,
      averageSpeed: averageSpeed,
      distance: totalDistance,
    );

    _saveTripToLocalStorage(tripData);
  }

  Future<void> _saveTripToLocalStorage(TripData tripData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> trips = prefs.getStringList('trips') ?? [];
    trips.add(tripData.toJson()); // Pastikan TripData memiliki metode `toJson()`
    await prefs.setStringList('trips', trips);
  }

  @override
  Future<void> close() {
    positionStream?.cancel(); // Hentikan stream saat Bloc dihancurkan
    return super.close();
  }
}
