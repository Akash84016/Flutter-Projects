import '../models/song.dart';

abstract class MusicPlayerEvent {}

class PlaySong extends MusicPlayerEvent {
  final Song song;
  PlaySong(this.song);
}

class PauseSong extends MusicPlayerEvent {}

class NextSong extends MusicPlayerEvent {}

class PreviousSong extends MusicPlayerEvent {}

class SeekSong extends MusicPlayerEvent {
  final Duration position;
  SeekSong(this.position);
}

class SeekForward extends MusicPlayerEvent {}

class SeekBackward extends MusicPlayerEvent {}

class UpdatePosition extends MusicPlayerEvent {
  final Duration position;
  UpdatePosition(this.position);
}
