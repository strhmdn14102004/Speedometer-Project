import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speedometer/module/drag_mode/bloc/drag_bloc.dart';
import 'package:speedometer/module/drag_mode/bloc/drag_event.dart';
import 'package:speedometer/module/drag_mode/bloc/drag_state.dart';

class DragModePage extends StatefulWidget {
  @override
  State<DragModePage> createState() => _DragModePageState();
}

class _DragModePageState extends State<DragModePage> {
  bool _isTracking = false;
  List<FlSpot> speedData = [const FlSpot(0, 0)];
  DateTime? _sessionStart;

  void _shareSessionResult(String result) async {
    try {
      await Share.share(
        result,
        subject: 'Hasil Sesi Drag Mode',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membagikan hasil: $e')),
      );
    }
  }

  void _resetSession() {
    context.read<SpeedBloc>().add(ResetSession());
    setState(() {
      _isTracking = false;
      speedData = [const FlSpot(0, 0)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag Mode'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<SpeedBloc, SpeedState>(
          builder: (context, state) {
            if (state is SpeedSessionResult) {
              String sessionResult =
                  'Hasil Sesi Mode Drag :\n\nKecepatan Maksimal: ${state.maxSpeed.toStringAsFixed(2)} km/h\n'
                  'Kecepatan Rata-rata : ${state.averageSpeed.toStringAsFixed(2)} km/h\n'
                  'Waktu Mulai : ${DateFormat('HH:mm:ss | dd MMMM yyyy').format(state.startTime)}\n'
                  'Waktu Berhenti : ${DateFormat('HH:mm:ss | dd MMMM yyyy').format(state.stopTime)}';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(sessionResult, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                        ),
                        onPressed: () => _shareSessionResult(sessionResult),
                        child: const Text(
                          'Bagikan Hasil',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                        ),
                        onPressed: _resetSession,
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: const FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: speedData,
                            isCurved: true,
                            color: Colors.blue,
                            belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.3)),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BlocBuilder<SpeedBloc, SpeedState>(
                  builder: (context, state) {
                    double speed = 0.0;
                    if (state is SpeedUpdated) {
                      speed = state.speed;
                      if (_isTracking) {
                        final elapsedTime = _sessionStart != null
                            ? DateTime.now()
                                .difference(_sessionStart!)
                                .inSeconds
                            : 0;
                        setState(() {
                          speedData.add(FlSpot(elapsedTime.toDouble(), speed));
                        });
                      }
                    }
                    return Text(
                      '${speed.toStringAsFixed(2)} Km/h',
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTracking ? Colors.red : Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _isTracking = !_isTracking;
                      if (_isTracking) {
                        _sessionStart = DateTime.now();
                        speedData = [const FlSpot(0, 0)];
                        context.read<SpeedBloc>().add(StartTracking());
                      } else {
                        context.read<SpeedBloc>().add(StopTracking());
                      }
                    });
                  },
                  child: Text(_isTracking ? 'Stop' : 'Start',
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
