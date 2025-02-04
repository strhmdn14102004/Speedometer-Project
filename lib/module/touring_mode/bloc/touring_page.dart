import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speedometer/module/touring_mode/bloc/touring_bloc.dart';
import 'package:speedometer/module/touring_mode/bloc/touring_event.dart';
import 'package:speedometer/module/touring_mode/bloc/touring_state.dart';

class TouringModePage extends StatefulWidget {
  @override
  State<TouringModePage> createState() => _TouringModePageState();
}

class _TouringModePageState extends State<TouringModePage> {
  bool _permissionsGranted = false;
  bool _isTouring = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestStoragePermission();
  }

  Future<void> _checkAndRequestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      setState(() {
        _permissionsGranted = true;
      });
      context.read<TouringBloc>().add(LoadMusicFiles());
    } else {
      final result = await Permission.manageExternalStorage.request();
      if (result.isGranted) {
        setState(() {
          _permissionsGranted = true;
        });
        context.read<TouringBloc>().add(LoadMusicFiles());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Storage permission is required to access music files.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Music Player (Left Side)
            if (_permissionsGranted)
              Expanded(
                flex: 1,
                child: BlocBuilder<TouringBloc, TouringState>(
                  builder: (context, state) {
                    if (state is TouringMusicLoaded) {
                      final musicFiles = state.musicFiles;

                      if (musicFiles.isEmpty) {
                        return const Center(
                          child: Text(
                            'No music files found',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        );
                      }

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Music Player',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: musicFiles.length,
                                itemBuilder: (context, index) {
                                  final filePath = musicFiles[index];
                                  final fileName = filePath.split('/').last;

                                  return ListTile(
                                    title: Text(
                                      fileName,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.play_arrow,
                                          color: Colors.white),
                                      onPressed: () {
                                        context
                                            .read<TouringBloc>()
                                            .add(PlayMusic(filePath));
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is TouringMusicPlaying ||
                        state is TouringMusicPaused) {
                      final currentTrack = state is TouringMusicPlaying
                          ? state.currentTrack
                          : (state as TouringMusicPaused).currentTrack;

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lottie/music.json',
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Now Playing: ${currentTrack}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.pause,
                                      color: Colors.white),
                                  onPressed: () {
                                    context
                                        .read<TouringBloc>()
                                        .add(PauseMusic());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.play_arrow,
                                      color: Colors.white),
                                  onPressed: () {
                                    if (state is TouringMusicPaused) {
                                      context
                                          .read<TouringBloc>()
                                          .add(PlayMusic(state.currentTrack));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    return const CircularProgressIndicator(color: Colors.white);
                  },
                ),
              )
            else
              const Center(
                child: Text(
                  'Storage permission is required. Please grant access.',
                  style: TextStyle(color: Colors.red),
                ),
              ),

            // Speedometer (Right Side)
            Expanded(
              flex: 1,
              child: BlocBuilder<TouringBloc, TouringState>(
                builder: (context, state) {
                  double speed = 0.0;
                  if (state is TouringSpeedUpdated) {
                    speed = state.speed;
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${speed.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'km/h',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
