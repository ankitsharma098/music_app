part of 'song_bloc.dart';

@immutable
sealed class SongState {}

final class SongInitial extends SongState {}

class SongLoading extends SongState {}

class SongLoaded extends SongState {
  final List<Song> songs;
  final List<Playlist> playlists;
  final List<Artist> popularArtists;
  final List<Song> trendingSongs;
  final List<Song> songGptSongs;
  final List<Genre> genres;

  SongLoaded({
    required this.songs,
    required this.playlists,
    required this.popularArtists,
    required this.trendingSongs,
    required this.songGptSongs,
    required this.genres,
  });
}

class SongError extends SongState {
  final String message;

  SongError({required this.message});
}
