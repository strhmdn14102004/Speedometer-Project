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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag Mode'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SpeedBloc, SpeedState>(
            builder: (context, state) {
              if (state is SpeedSessionResult) {
                String sessionResult =
                    'Hasil Sesi Drag Mode:\n\nKecepatan Maksimal: ${state.maxSpeed.toStringAsFixed(2)} km/h\n'
                    'Kecepatan Rata-rata: ${state.averageSpeed.toStringAsFixed(2)} km/h\n'
                    'Waktu Mulai: ${DateFormat('HH:mm:ss | dd MMMM yyyy').format(state.startTime)}\n'
                    'Waktu Berhenti: ${DateFormat('HH:mm:ss | dd MMMM yyyy').format(state.stopTime)}';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      sessionResult,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _shareSessionResult(sessionResult),
                          child: const Text('Bagikan Hasil Sesi'),
                        ),
                        ElevatedButton(
                          onPressed: _resetSession,
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<SpeedBloc, SpeedState>(
                    builder: (context, state) {
                      double speed = 0.0;
                      if (state is SpeedUpdated) {
                        speed = state.speed;
                      }
                      return Text(
                        '${speed.toStringAsFixed(2)} km/h',
                        style: const TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isTracking = !_isTracking;
                      });
                      if (_isTracking) {
                        context.read<SpeedBloc>().add(StartTracking());
                      } else {
                        context.read<SpeedBloc>().add(StopTracking());
                      }
                    },
                    child: Text(_isTracking ? 'Stop' : 'Start'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}