part of 'song_bloc.dart';

@immutable
sealed class SongEvent {}

class LoadSongsEvent extends SongEvent {}
