abstract class TouringState {}

class TouringInitial extends TouringState {}

class TouringSpeedUpdated extends TouringState {
  final double speed;

  TouringSpeedUpdated(this.speed);
}

class TouringMusicLoaded extends TouringState {
  final List<String> musicFiles;

  TouringMusicLoaded(this.musicFiles);
}

class TouringMusicPlaying extends TouringState {
  final String currentTrack;

  TouringMusicPlaying(this.currentTrack);
}
class TouringMusicPaused extends TouringState {
  final String currentTrack;

  TouringMusicPaused(this.currentTrack);
}
