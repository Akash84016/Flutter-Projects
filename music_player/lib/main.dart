import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/music_player_bloc.dart';
import 'screens/home_player_view.dart';
import 'services/audio_service.dart';
import 'models/song.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<Song> playlist = [
    Song(title: 'Square Compressed', url: 'https://app.konnectus.live/audify/public/uploads/audio_files/2_Square_compressed.mp3', image: 'https://app.konnectus.live/audify/public/uploads/posters/Surprise_270x390.jpg.jpg'),
    Song(title: 'Since I Met U', url: 'https://app.konnectus.live/audify/public/uploads/audio_files/【English_Dubbed】Since_I_Met_U_EP01___She_mistook_him_for_her_crush_and_kissed_him___Fresh_Drama_Pro_(1).mp3', image: 'https://app.konnectus.live/audify/public/uploads/posters/TheCursedNecklace_270x390.jpg.jpg'),
    Song(title: 'Comedy Audio', url: 'https://app.konnectus.live/audify/public/uploads/audio_files/Sanjay_Goradia_&_Siddharth_Randeria_-_Superhit_Gujarati_Comedy_Natako___@gujaraticomedy5787_(1).mp3', image: 'https://app.konnectus.live/audify/public/uploads/posters/Dubki_270x390.jpg.jpg'),
    Song(title: 'Drama Juniors', url: 'https://app.konnectus.live/audify/public/uploads/audio_files/Drama_Juniors_UNSEEN_EPISODE___Zee_Marathi_(1).mp3', image: 'https://app.konnectus.live/audify/public/uploads/audio_files/Drama_Juniors_UNSEEN_EPISODE___Zee_Marathi_(1).mp3'),
  ];

  AudioService audioService = AudioService();
  MusicPlayerBloc musicPlayerBloc = MusicPlayerBloc(audioService, playlist);

  // Load the last played song and position
  await musicPlayerBloc.loadLastPlayedSong();

  runApp(MyApp(musicPlayerBloc));
}

class MyApp extends StatelessWidget {
  final MusicPlayerBloc musicPlayerBloc;

  MyApp(this.musicPlayerBloc);

  @override
  Widget build(BuildContext context) {
    // Wrap the whole app with BlocProvider
    return BlocProvider(
      create: (context) => musicPlayerBloc,
      child: MaterialApp(
        home: HomePlayerView(),
      ),
    );
  }
}
