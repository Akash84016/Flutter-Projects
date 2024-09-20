import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_service.dart';
import '../models/song.dart';
import 'music_player_event.dart';
import 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final AudioService audioService;
  final List<Song> playlist;
  int currentSongIndex = 0;
  Duration lastPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;

  MusicPlayerBloc(this.audioService, this.playlist) : super(MusicPlayerInitial()) {
    on<PlaySong>((event, emit) async {
      currentSongIndex = playlist.indexOf(event.song);
      await audioService.play(event.song.url, startPosition: lastPosition);
      _positionSubscription?.cancel();
      _positionSubscription = audioService.positionStream.listen((position) {
        add(UpdatePosition(position));
        lastPosition = position;
        saveLastPlayedSong(position);
      });
      final duration = await audioService.getDuration();
      emit(MusicPlaying(event.song, lastPosition, duration));
    });

    on<PauseSong>((event, emit) async {
      lastPosition = await audioService.positionStream.first;
      await saveLastPlayedSong(lastPosition);
      await audioService.pause();
      _positionSubscription?.cancel();
      emit(MusicPaused(playlist[currentSongIndex]));
    });

    on<NextSong>((event, emit) async {
      currentSongIndex = (currentSongIndex + 1) % playlist.length;
      final nextSong = playlist[currentSongIndex];
      lastPosition = Duration.zero;
      await audioService.play(nextSong.url);
      final duration = await audioService.getDuration();
      emit(MusicPlaying(nextSong, Duration.zero, duration));
      saveLastPlayedSong(Duration.zero);
    });

    on<PreviousSong>((event, emit) async {
      currentSongIndex = (currentSongIndex - 1 + playlist.length) % playlist.length;
      final previousSong = playlist[currentSongIndex];
      lastPosition = Duration.zero;
      await audioService.play(previousSong.url);
      final duration = await audioService.getDuration();
      emit(MusicPlaying(previousSong, Duration.zero, duration));
      saveLastPlayedSong(Duration.zero);
    });

    on<SeekSong>((event, emit) async {
      await audioService.seek(event.position);
      lastPosition = event.position;
      if (state is MusicPlaying) {
        final musicPlayingState = state as MusicPlaying;
        emit(MusicPlaying(musicPlayingState.currentSong, event.position, musicPlayingState.totalDuration));
        saveLastPlayedSong(event.position);
      }
    });

    on<SeekForward>((event, emit) async {
      await audioService.seekForward();
      final position = await audioService.positionStream.first;
      lastPosition = position;
      if (state is MusicPlaying) {
        final musicPlayingState = state as MusicPlaying;
        emit(MusicPlaying(musicPlayingState.currentSong, position, musicPlayingState.totalDuration));
        saveLastPlayedSong(position);
      }
    });

    on<SeekBackward>((event, emit) async {
      await audioService.seekBackward();
      final position = await audioService.positionStream.first;
      lastPosition = position;
      if (state is MusicPlaying) {
        final musicPlayingState = state as MusicPlaying;
        emit(MusicPlaying(musicPlayingState.currentSong, position, musicPlayingState.totalDuration));
        saveLastPlayedSong(position);
      }
    });

    on<UpdatePosition>((event, emit) {
      if (state is MusicPlaying) {
        final musicPlayingState = state as MusicPlaying;
        lastPosition = event.position;
        emit(MusicPlaying(musicPlayingState.currentSong, event.position, musicPlayingState.totalDuration));
        saveLastPlayedSong(event.position);
      }
    });
  }

  Future<void> saveLastPlayedSong(Duration position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSongIndex', currentSongIndex);
    await prefs.setInt('lastPosition', position.inSeconds);
  }

  Future<void> loadLastPlayedSong() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentSongIndex = prefs.getInt('lastSongIndex') ?? 0;
    int lastPositionSeconds = prefs.getInt('lastPosition') ?? 0;
    final lastSong = playlist[currentSongIndex];
    lastPosition = Duration(seconds: lastPositionSeconds);
    if (audioService.isPlaying()) {
      emit(MusicPlaying(lastSong, lastPosition, await audioService.getDuration()));
    } else {
      emit(MusicPaused(lastSong));
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }
}
