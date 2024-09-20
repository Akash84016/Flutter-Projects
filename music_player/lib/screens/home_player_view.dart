import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/music_player_bloc.dart';
import '../blocs/music_player_state.dart';
import '../blocs/music_player_event.dart';
import 'detail_view.dart';

class HomePlayerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        if (state is MusicPaused || state is MusicPlaying) {
          final song = state is MusicPaused ? state.currentSong : (state as MusicPlaying).currentSong;

          return Scaffold(
            appBar: AppBar(
              title: Text("Music Player"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: Icons.skip_previous,
                        onPressed: () => context.read<MusicPlayerBloc>().add(PreviousSong()),
                      ),
                      SizedBox(width: 20),
                      _buildControlButton(
                        icon: state is MusicPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 70,
                        onPressed: () {
                          if (state is MusicPlaying) {
                            context.read<MusicPlayerBloc>().add(PauseSong());
                          } else {
                            context.read<MusicPlayerBloc>().add(PlaySong(song));
                          }
                        },
                      ),
                      SizedBox(width: 20),
                      _buildControlButton(
                        icon: Icons.skip_next,
                        onPressed: () => context.read<MusicPlayerBloc>().add(NextSong()),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailView()),
                      );
                    },
                    child: Text(
                      "View Details",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
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
