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
              'Penolakan akses penyimpanan, tidak dapat memuat file musik.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _reloadMusicList() {
    context.read<TouringBloc>().add(LoadMusicFiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (_permissionsGranted)
              BlocConsumer<TouringBloc, TouringState>(
                listener: (context, state) {
                  if (state is TouringMusicError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Error loading music files.")),
                    );
                  }
                },
                builder: (context, state) {
                  List<String> musicFiles = [];
                  String? currentTrack;
                  bool isPlaying = false;

                  if (state is TouringMusicLoaded) {
                    musicFiles = state.musicFiles;
                  } else if (state is TouringMusicPlaying) {
                    currentTrack = state.currentTrack;
                    isPlaying = true;
                  } else if (state is TouringMusicPaused) {
                    currentTrack = state.currentTrack;
                    isPlaying = false;
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _showMusicList
                              ? _buildMusicList(
                                  context, musicFiles, currentTrack, isPlaying)
                              : _buildMusicPlayer(
                                  context, currentTrack, isPlaying),
                        ),
                      ),
                    ],
                  );
                },
              )
            else
              const Center(
                child: Text(
                  'Izin akses penyimpanan diperlukan untuk mengakses file musik.',
                ),
              ),

            // Speedometer Display
            Positioned(
              top: 16,
              right: 16,
              child: BlocBuilder<TouringBloc, TouringState>(
                builder: (context, state) {
                  double speed = 0.0;
                  if (state is TouringSpeedUpdated) {
                    speed = state.speed;
                  }

                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Kecepatan : ${speed.toStringAsFixed(0)} km/h',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicList(BuildContext context, List<String> musicFiles,
      String? currentTrack, bool isPlaying) {
    return Column(
      children: [
        Lottie.asset(
          'assets/lottie/list_music.json',
          height: 150,
          fit: BoxFit.contain,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Pilih Musik Untuk Dimainkan :',
              style: TextStyle(fontSize: 16)),
        ),
        Expanded(
          child: musicFiles.isNotEmpty
              ? ListView.builder(
                  itemCount: musicFiles.length,
                  itemBuilder: (context, index) {
                    final filePath = musicFiles[index];
                    final fileName = filePath.split('/').last;
                    return ListTile(
                      title: Text(
                        fileName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: Icon(
                        currentTrack == filePath && isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: currentTrack == filePath && isPlaying
                            ? Colors.green
                            : Colors.green,
                      ),
                      onTap: () {
                        setState(() => _showMusicList = false);
                        context.read<TouringBloc>().add(PlayMusic(filePath));
                      },
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'Tidak ada file musik di temukan.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildMusicPlayer(
      BuildContext context, String? currentTrack, bool isPlaying) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/music.json',
          height: 100,
          fit: BoxFit.contain,
        ),
        if (currentTrack != null) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sedang Diputar : ${currentTrack.split('/').last}',
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: isPlaying ? Colors.red : Colors.green,
                ),
                onPressed: () {
                  if (isPlaying) {
                    context.read<TouringBloc>().add(PauseMusic());
                  } else {
                    context.read<TouringBloc>().add(PlayMusic(currentTrack));
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () {
                  setState(() => _showMusicList = true);
                  _reloadMusicList();
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}
