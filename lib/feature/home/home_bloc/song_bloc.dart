import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/song_model.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  SongBloc() : super(SongInitial()) {
    on<LoadSongsEvent>(_onLoadSongs);
  }
  void _onLoadSongs(LoadSongsEvent event, Emitter<SongState> emit) {
    emit(SongLoading());
    try {
      final popularArtists = [
        Artist(
          name: 'Code Infinity',
          plays: 23434,
          songs: 138,
          likes: 280,
          imageUrl: 'assets/images/artist/cd.png',
        ),
        Artist(
          name: 'Mr. Swap',
          plays: 21215,
          songs: 163,
          likes: 205,
          imageUrl: 'assets/images/artist/cd.png',
        ),
      ];

      final playlists = [
        Playlist(
          name: 'Feel Good',
          imageUrl: 'assets/images/playlist/playlist 1.png',
        ),
        Playlist(
          name: 'Disa so',
          imageUrl: 'assets/images/playlist/playlist 2.png',
        ),
      ];

      final trendingSongs = [
        Song(
          title: 'Into the Pixelated Abyss ',
          artist: 'Hackinet',
          genre: 'Electronic',
          imageUrl: 'assets/images/trending/trending_song 1.jpg',
          audioPath:
              'assets/audio/trending songs/Into the Pixelated Abyss (Version 1)-SongGPT.mp3',
        ),
        Song(
          title: 'Fields of Innovation',
          artist: 'Code Infinity',
          genre: 'Electronic Pop',
          imageUrl: 'assets/images/trending/trending_song 2.jpg',
          audioPath:
              'assets/audio/trending songs/Fields of Innovation-SongGPT.mp3',
        ),
        Song(
          title: "Victory Anthem_ Kohli's Century",
          artist: 'Mr. Swap',
          genre: 'Bollywood',
          imageUrl: 'assets/images/trending/trending song 3.jpg',
          audioPath:
              "assets/audio/trending songs/Victory Anthem_ Kohli's Century (Version 2)-SongGPT.mp3",
        ),
      ];

      final songGptSongs = [
        Song(
          title: 'Waves of Resilience 2',
          artist: 'Song GPT',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/songGPT/songGpt 1.jpg',
          audioPath: 'assets/audio/songGpt/Waves of Resilience 2-SongGPT.mp3',
        ),
        Song(
          title: 'Song GPT Anthem 2',
          artist: 'Song GPT',
          genre: 'Electronic',
          imageUrl: 'assets/images/songGPT/songGpt 2.jpg',
          audioPath: 'assets/audio/songGpt/Song GPT Anthem 2-SongGPT.mp3',
        ),
        Song(
          title: 'Song GPT Anthem 1',
          artist: 'Song GPT',
          genre: 'Electronic',
          imageUrl: 'assets/images/songGPT/songGpt 3.jpg',
          audioPath: 'assets/audio/songGpt/Song GPT Anthem 1-SongGPT.mp3',
        ),
      ];

      final genres = [
        Genre(name: 'Pop', imageUrl: 'assets/images/genres/genres 1.jpg'),
        Genre(
            name: 'Futuristic', imageUrl: 'assets/images/genres/genres 2.jpg'),
      ];

      final newSongs = [
        Song(
          title: 'Fe Inquebrantable 2',
          artist: 'Jv',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/new songs/new song 1.jpg',
          audioPath: 'assets/audio/new songs/Fe Inquebrantable 2-SongGPT.mp3',
        ),
        Song(
          title: 'Lealtad Inquebrantable 2',
          artist: 'Jv',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/new songs/new song 2.jpg',
          audioPath:
              'assets/audio/new songs/Lealtad Inquebrantable 2-SongGPT.mp3',
        ),
        Song(
          title: 'Weggabelung des Lebens 2',
          artist: 'Maxi421',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/new songs/new song 3.jpg',
          audioPath:
              'assets/audio/new songs/Weggabelung des Lebens 2-SongGPT.mp3',
        ),
        Song(
          title: 'Weggabelung des Lebens 1',
          artist: 'Maxi421',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/new songs/new song 3.jpg',
          audioPath:
              'assets/audio/new songs/Weggabelung des Lebens 1-SongGPT.mp3',
        ),
        Song(
          title: 'Nouveau Départ 1',
          artist: 'Maxi421',
          genre: 'Ballad',
          imageUrl: 'assets/images/new songs/new song 3.jpg',
          audioPath: 'assets/audio/new songs/Nouveau Départ 1-SongGPT.mp3',
        ),
      ];

      emit(SongLoaded(
        songs: newSongs,
        playlists: playlists,
        popularArtists: popularArtists,
        trendingSongs: trendingSongs,
        songGptSongs: songGptSongs,
        genres: genres,
      ));
    } catch (e) {
      emit(SongError(message: e.toString()));
    }
  }
}
