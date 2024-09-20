import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Modified play method to accept a starting position
  Future<void> play(String url, {Duration startPosition = Duration.zero}) async {
    await _audioPlayer.setUrl(url);
    await _audioPlayer.seek(startPosition);  // Start from the specified position
    _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<Duration> getDuration() async {
    return _audioPlayer.duration ?? Duration.zero;
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Future<void> seekForward() async {
    final newPosition = _audioPlayer.position + Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  }

  Future<void> seekBackward() async {
    final newPosition = _audioPlayer.position - Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  }

  // New method to check the player's current state
  bool isPlaying() {
    return _audioPlayer.playing;
  }
}
