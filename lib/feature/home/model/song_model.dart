class Song {
  final String title;
  final String artist;
  final String genre;
  final String imageUrl;
  final String audioPath; // Path to the MP3 file
  final Duration duration;

  Song({
    required this.title,
    required this.artist,
    required this.genre,
    required this.imageUrl,
    required this.audioPath,
    this.duration = const Duration(minutes: 3, seconds: 30),
  });

  // Format duration as mm:ss
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class Playlist {
  final String name;
  final String imageUrl;

  Playlist({
    required this.name,
    required this.imageUrl,
  });
}

class Artist {
  final String name;
  final int plays;
  final int songs;
  final int likes;
  final String imageUrl;

  Artist({
    required this.name,
    required this.plays,
    required this.songs,
    required this.likes,
    required this.imageUrl,
  });
}

class Genre {
  final String name;
  final String imageUrl;

  Genre({
    required this.name,
    required this.imageUrl,
  });
}
