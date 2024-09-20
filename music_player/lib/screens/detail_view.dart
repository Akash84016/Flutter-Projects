import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/music_player_bloc.dart';
import '../blocs/music_player_state.dart';
import '../blocs/music_player_event.dart';
import '../models/song.dart';

class DetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        Song? song;
        Duration position = Duration.zero;
        Duration totalDuration = Duration.zero;

        if (state is MusicPlaying) {
          song = state.currentSong;
          position = state.position;
          totalDuration = state.totalDuration;
        } else if (state is MusicPaused) {
          song = state.currentSong;
        }

        if (song == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Now Playing"),
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    child: Image.network(
                      song.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.error, size: 50, color: Colors.red),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  song.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Slider(
                  activeColor: Colors.deepPurple,
                  inactiveColor: Colors.grey[300],
                  value: position.inSeconds.toDouble(),
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    final newPosition = Duration(seconds: value.toInt());
                    context.read<MusicPlayerBloc>().add(SeekSong(newPosition));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      "${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: Icons.skip_previous,
                      onPressed: () => context.read<MusicPlayerBloc>().add(PreviousSong()),
                    ),
                    _buildControlButton(
                      icon: Icons.replay_10,
                      onPressed: () {
                        final newPosition = position - Duration(seconds: 10);
                        context.read<MusicPlayerBloc>().add(SeekSong(_clampDuration(newPosition, totalDuration)));
                      },
                    ),
                    _buildControlButton(
                      icon: state is MusicPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      size: 70,
                      onPressed: () {
                        if (state is MusicPlaying) {
                          context.read<MusicPlayerBloc>().add(PauseSong());
                        } else {
                          context.read<MusicPlayerBloc>().add(PlaySong(song!));
                        }
                      },
                    ),
                    _buildControlButton(
                      icon: Icons.forward_10,
                      onPressed: () {
                        final newPosition = position + Duration(seconds: 10);
                        context.read<MusicPlayerBloc>().add(SeekSong(_clampDuration(newPosition, totalDuration)));
                      },
                    ),
                    _buildControlButton(
                      icon: Icons.skip_next,
                      onPressed: () => context.read<MusicPlayerBloc>().add(NextSong()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Duration _clampDuration(Duration duration, Duration totalDuration) {
    if (duration.inSeconds < 0) return Duration.zero;
    return duration > totalDuration ? totalDuration : duration;
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 50,
  }) {
    return IconButton(
      icon: Icon(icon),
      iconSize: size,
      color: Colors.deepPurple,
      onPressed: onPressed,
    );
  }
}
