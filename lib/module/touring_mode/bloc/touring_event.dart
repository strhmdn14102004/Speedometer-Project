abstract class TouringEvent {}

class StartTouring extends TouringEvent {}

class StopTouring extends TouringEvent {}

class LoadMusicFiles extends TouringEvent {}

class PlayMusic extends TouringEvent {
  final String filePath;

  PlayMusic(this.filePath);
}

class PauseMusic extends TouringEvent {}
