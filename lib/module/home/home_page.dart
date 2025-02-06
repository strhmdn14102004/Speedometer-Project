import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedometer/module/home/home_bloc.dart';
import 'package:speedometer/module/home/home_event.dart';
import 'package:speedometer/module/home/home_state.dart';
import 'package:speedometer/module/menu/menu.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<DateTime> _timeStream;
  String _timeZoneLabel = "Wib";
  double totalFuelConsumed = 0.0;
  double highestSpeed = 0.0;
  DateTime? highestSpeedTime;
  bool _isTracking = false;

  Color getRpmColor(int rpm) {
    if (rpm < 1000) return Colors.green;
    if (rpm < 3000) return Colors.orange;
    return Colors.red;
  }

  Color getFuelColor(double fuelLevel) {
    if (fuelLevel <= 10) return Colors.red;
    if (fuelLevel <= 50) return Colors.orange;
    return Colors.green;
  }

  List<Color> getFuelGradient(double fuelLevel) {
    if (fuelLevel > 50) {
      return [Colors.green, Colors.green[900]!]; // Hijau terang ke hijau gelap
    } else if (fuelLevel > 20) {
      return [Colors.orange, Colors.yellow]; // Oranye ke Kuning
    } else {
      return [Colors.red, Colors.redAccent]; // Merah terang ke merah tua
    }
  }

  List<Color> getSpeedGradient(double speed) {
    if (speed == 0) {
      return [Colors.grey, Colors.grey[700]!]; // Abu-abu untuk kecepatan 0
    } else if (speed > 0 && speed <= 30) {
      return [Colors.green, Colors.green[900]!]; // Hijau terang ke hijau tua
    } else if (speed > 30 && speed <= 80) {
      return [Colors.orange, Colors.yellow]; // Oranye ke Kuning
    } else {
      return [Colors.red, Colors.redAccent]; // Merah terang ke merah tua
    }
  }

  Color getSpeedColor(double speed) {
    if (speed <= 30) {
      return Colors.grey; // ⚪ Putih (Aman)
    } else if (speed > 30 && speed <= 60) {
      return Colors.yellow; // 🟡 Kuning (Waspada)
    } else if (speed > 60 && speed <= 85) {
      return Colors.orange; // 🟠 Oranye (Hati-hati)
    } else {
      return Colors.red; // 🔴 Merah (Bahaya)
    }
  }

  List<Color> getRPMColors(int rpm) {
    if (rpm == 0) {
      return [Colors.green, Colors.green, Colors.green];
    } else if (rpm < 2000) {
      return [Colors.yellow, Colors.orange, Colors.red];
    } else if (rpm < 4000) {
      return [Colors.orange, Colors.red, Colors.redAccent];
    } else {
      return [Colors.red, Colors.redAccent, Colors.deepOrange];
    }
  }

  Color getFuelIconColor(double fuelLevel) {
    if (fuelLevel <= 20) {
      return Colors.red;
    } else if (fuelLevel > 20 && fuelLevel <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    tz.initializeTimeZones();
    _timeStream =
        Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
    context.read<DashboardBloc>().add(StartTracking());
  }

  void _requestLocationPermission() async {
    bool isGranted = await Geolocator.isLocationServiceEnabled();
    if (!isGranted) {
      await Geolocator.requestPermission();
    }
    context.read<DashboardBloc>().add(StartTracking());
  }

  String getGearText(double speed) {
    if (speed >= 1 && speed < 30) {
      return "1";
    } else if (speed >= 30 && speed < 50) {
      return "2";
    } else if (speed >= 50 && speed < 70) {
      return "3";
    } else if (speed >= 70 && speed < 90) {
      return "4";
    } else if (speed >= 90 && speed < 120) {
      return "5";
    } else if (speed >= 120 && speed <= 170) {
      return "6";
    } else {
      return "N"; // Default jika kecepatan di luar rentang yang ditentukan
    }
  }

  Future<void> _getCurrentTimeZone() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        String? country = placemarks.first.country;
        String? locality = placemarks.first.locality;

        String timeZoneName = "$locality, $country";

        setState(() {
          _timeZoneLabel = _convertToIndonesianTimeZone(timeZoneName);
        });
      }
    } catch (e) {
      print("Error getting time zone: $e");
    }
  }

  String _convertToIndonesianTimeZone(String timeZone) {
    if (timeZone.contains("Jakarta") ||
        timeZone.contains("Western Indonesia Time")) {
      return "Wib";
    } else if (timeZone.contains("Makassar") ||
        timeZone.contains("Central Indonesia Time")) {
      return "Wita";
    } else if (timeZone.contains("Jayapura") ||
        timeZone.contains("Eastern Indonesia Time")) {
      return "Wit";
    }
    return "Wib"; // Default jika tidak terdeteksi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          getGearText(state.speed),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${state.rpm} Rpm",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: LinearGradient(
                                        colors: getRPMColors(state.rpm),
                                        stops: [
                                          0.0,
                                          (state.rpm / 6000).clamp(0.0, 1.0),
                                          1.0
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "${state.estimatedTime.inMinutes}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              "Min",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        StreamBuilder<DateTime>(
                                          stream: _timeStream,
                                          builder: (context, snapshot) {
                                            final now =
                                                snapshot.data ?? DateTime.now();
                                            return Column(
                                              children: [
                                                Text(
                                                  "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  _timeZoneLabel,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "${state.distanceToDestination.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              "Km",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.speed.toStringAsFixed(0),
                              style: TextStyle(
                                color: getSpeedColor(state
                                    .speed), // Warna dinamis berdasarkan kecepatan
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Km/h',
                              style: TextStyle(
                                fontSize: 24,fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _showFuelDialog(context, state);
                                            },
                                            child: Icon(Icons.local_gas_station,
                                                color: getFuelIconColor(
                                                    state.fuelLevel)),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${state.fuelLevel.toStringAsFixed(0)}%",
                                            style: const TextStyle(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8, // Lebar indikator
                                        height: 10, // Tinggi indikator
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              5), // Membulatkan sisi indikator
                                          color: Colors.grey[
                                              800], // Background abu-abu untuk bar kosong
                                        ),
                                        child: Stack(
                                          children: [
                                            FractionallySizedBox(
                                              widthFactor: state.fuelLevel /
                                                  100, // Proporsi berdasarkan fuel level
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5), // Membulatkan sisi gradasi
                                                  gradient: LinearGradient(
                                                    colors: getFuelGradient(state
                                                        .fuelLevel), // Warna dinamis
                                                    stops: const [
                                                      0.0,
                                                      1.0
                                                    ], // Titik perubahan warna
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.speed_rounded,
                                              color: Colors.red),
                                          const SizedBox(width: 5),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Kecepatan Terakhir : ",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${state.speed.toStringAsFixed(0)} km/h",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[
                                              800], // Background bar kosong
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            final barWidth = (state.speed / 200)
                                                    .clamp(0.0, 1.0) *
                                                constraints.maxWidth;

                                            return Container(
                                              width: barWidth,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                gradient: LinearGradient(
                                                  colors: getSpeedGradient(state
                                                      .speed), // Warna dinamis
                                                  stops: const [0.0, 1.0],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ]))
                          ],
                        ),
                      ),
                    ]);
              }
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.grey[900],
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MenuPage()));
          },
          icon: const Icon(
            Icons.fiber_smart_record_outlined,
            color: Colors.white,
          ),
          label: const Text(
            "Mode",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  void _showFuelDialog(BuildContext context, DashboardLoaded state) {
    double avgConsumption = state.distanceToDestination > 0
        ? (state.distanceToDestination / (100 - state.fuelLevel)) * 34
        : 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Informasi Bahan Bakar',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Rata-rata konsumsi bahan bakar : ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "${avgConsumption.toStringAsFixed(2)} km/l",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                "Sisa bahan bakar : ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "${state.fuelLevel.toStringAsFixed(2)}%",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 2),
              ElevatedButton.icon(
                onPressed: () {
                  _refillFuel(context);
                },
                icon: const Icon(FontAwesomeIcons.gasPump),
                label: const Text(
                  "Tambah Bahan Bakar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void _refillFuel(BuildContext context) {
    context.read<DashboardBloc>().add(StartTracking()); // Reset bahan bakar
    Navigator.pop(context); // Tutup dialog
  }
}
