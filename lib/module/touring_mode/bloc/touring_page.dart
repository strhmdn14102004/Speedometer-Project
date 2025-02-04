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
  bool _showMusicList = true;

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
      body: SafeArea(
        child: Row(
          children: [
            if (_permissionsGranted)
              Expanded(
                flex: 1,
                child: BlocBuilder<TouringBloc, TouringState>(
                  builder: (context, state) {
                    List<String> musicFiles = [];
                    String? currentTrack;
                    bool isPlaying = false;

                    if (state is TouringMusicLoaded) {
                      musicFiles = state.musicFiles;
                    } else if (state is TouringMusicPlaying) {
                      currentTrack = state.currentTrack;
                      isPlaying = true;
                      _showMusicList = false;
                    } else if (state is TouringMusicPaused) {
                      currentTrack = state.currentTrack;
                      isPlaying = false;
                    }

                    return Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/music.json',
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                        Expanded(
                          child: _showMusicList
                              ? ListView.builder(
                                  itemCount: musicFiles.length,
                                  itemBuilder: (context, index) {
                                    final filePath = musicFiles[index];
                                    final fileName = filePath.split('/').last;
                                    return ListTile(
                                      title: Text(
                                        fileName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          currentTrack == filePath && isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          if (currentTrack == filePath &&
                                              isPlaying) {
                                            context
                                                .read<TouringBloc>()
                                                .add(PauseMusic());
                                          } else {
                                            context
                                                .read<TouringBloc>()
                                                .add(PlayMusic(filePath));
                                          }
                                        },
                                      ),
                                    );
                                  },
                                )
                              : GestureDetector(
                                  onVerticalDragUpdate: (details) {
                                    if (details.primaryDelta! < -10) {
                                      setState(() {
                                        _showMusicList = true;
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        'Now Playing: $currentTrack',
                                        style: const TextStyle(),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          if (isPlaying) {
                                            context
                                                .read<TouringBloc>()
                                                .add(PauseMusic());
                                          } else {
                                            context
                                                .read<TouringBloc>()
                                                .add(PlayMusic(currentTrack!));
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                        )
                      ],
                    );
                  },
                ),
              ),
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
                        ),
                      ),
                      const Text(
                        'km/h',
                        style: TextStyle(
                          fontSize: 24,
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
