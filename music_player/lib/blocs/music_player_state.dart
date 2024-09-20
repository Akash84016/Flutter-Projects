import '../models/song.dart';

abstract class MusicPlayerState {}

class MusicPlayerInitial extends MusicPlayerState {}

class MusicPlaying extends MusicPlayerState {
  final Song currentSong;
  final Duration position;
  final Duration totalDuration;

  MusicPlaying(this.currentSong, this.position, this.totalDuration);
}

class MusicPaused extends MusicPlayerState {
  final Song currentSong;

  MusicPaused(this.currentSong);
}

class MusicStopped extends MusicPlayerState {}
