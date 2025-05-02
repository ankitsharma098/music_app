// home_screen.dart
import 'package:assisgnment/feature/home/ui/song_play.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../home_bloc/song_bloc.dart';
import '../model/song_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.darkPurple,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.darkPurple,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.gray,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'My Songs',
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: AppTheme.lightPurple,
      //   child: const Icon(
      //     Icons.mic,
      //     color: AppTheme.white,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.,
      body: BlocBuilder<SongBloc, SongState>(
        builder: (context, state) {
          if (state is SongLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          } else if (state is SongLoaded) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenSize.height * 0.02),

                      // Explore header with profile and search
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                child: Icon(CupertinoIcons.profile_circled),
                                // backgroundImage:
                                //     AssetImage('assets/images/profile.jpg'),
                              ),
                              SizedBox(width: screenSize.width * 0.03),
                              Text(
                                'Explore',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppTheme.lightPurple.withOpacity(0.3),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    SizedBox(width: screenSize.width * 0.01),
                                    const Text(
                                      '90',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.03),
                              const Icon(
                                Icons.search,
                                color: AppTheme.white,
                                size: 28,
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: screenSize.height * 0.03),

                      // Song generation prompt box
                      Container(
                        padding: EdgeInsets.all(screenSize.width * 0.05),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Give prompt here to generate some amazing songs...',
                              style: TextStyle(
                                color: AppTheme.white,
                                fontSize: screenSize.width * 0.045,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.attachment,
                                      color: AppTheme.gray,
                                    ),
                                    SizedBox(width: screenSize.width * 0.01),
                                    Text(
                                      'Add attachments',
                                      style: TextStyle(
                                        color: AppTheme.gray,
                                        fontSize: screenSize.width * 0.04,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.music_note),
                                  label: const Text('Generate'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenSize.width * 0.04,
                                      vertical: screenSize.height * 0.01,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenSize.height * 0.03),

                      // Popular Artists
                      _buildSectionHeader(
                          context, 'Popular Artists', screenSize),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildPopularArtistsRow(state.popularArtists, screenSize),

                      SizedBox(height: screenSize.height * 0.03),

                      // Trending Playlists
                      _buildSectionHeader(
                          context, 'Trending Playlists', screenSize),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildPlaylistsRow(state.playlists, screenSize),

                      SizedBox(height: screenSize.height * 0.03),

                      // Trending Songs
                      _buildSectionHeader(
                          context, 'Trending Songs', screenSize),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildSongsRow(state.trendingSongs, screenSize),

                      SizedBox(height: screenSize.height * 0.03),

                      // SongGPT Songs
                      _buildSectionHeader(context, 'SongGPT Songs', screenSize),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildSongsRow(state.songGptSongs, screenSize),

                      SizedBox(height: screenSize.height * 0.03),

                      // Genres
                      _buildSectionHeader(context, 'Genres', screenSize),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildGenresRow(state.genres, screenSize),

                      SizedBox(height: screenSize.height * 0.03),

                      // New Songs
                      _buildSectionHeader(context, 'New Songs', screenSize),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildNewSongsList(state.songs, screenSize),

                      SizedBox(height: screenSize.height * 0.05),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is SongError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: screenSize.width * 0.06,
                fontWeight: FontWeight.w700,
              ),
        ),
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF342B4A),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.chevron_left,
                color: AppTheme.white,
              ),
            ),
            SizedBox(width: screenSize.width * 0.02),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF342B4A),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.chevron_right,
                color: AppTheme.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPopularArtistsRow(List<Artist> artists, Size screenSize) {
    return SizedBox(
      height: screenSize.height * 0.16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return Container(
            width: screenSize.width * 0.38,
            margin: EdgeInsets.only(right: screenSize.width * 0.03),
            decoration: BoxDecoration(
              color: index % 2 == 0
                  ? const Color(0xFF9D85FF)
                  : const Color(0xFFF0B27A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    artist.name,
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  Row(
                    children: [
                      const Icon(
                        Icons.play_arrow,
                        color: AppTheme.white,
                        size: 14,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        '${artist.plays} plays',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: screenSize.width * 0.035,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.music_note,
                        color: AppTheme.white,
                        size: 14,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        '${artist.songs}',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: screenSize.width * 0.035,
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.03),
                      const Icon(
                        Icons.favorite,
                        color: AppTheme.white,
                        size: 14,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        '${artist.likes}',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: screenSize.width * 0.035,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaylistsRow(List<Playlist> playlists, Size screenSize) {
    return SizedBox(
      height: screenSize.height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return Container(
            width: screenSize.width * 0.6,
            margin: EdgeInsets.only(right: screenSize.width * 0.03),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    playlist.imageUrl,
                    width: screenSize.width * 0.6,
                    height: screenSize.height * 0.15,
                    fit: BoxFit.cover,
                  ),
                ),
                // Positioned(
                //   right: 0,
                //   top: 0,
                //   bottom: 0,
                //   child: Container(
                //     width: screenSize.width * 0.15,
                //     padding: EdgeInsets.all(screenSize.width * 0.01),
                //     child: Image.asset(
                //       'assets/cd.jpg',
                //       fit: BoxFit.fitHeight,
                //     ),
                //   ),
                // ),
                Positioned(
                  left: screenSize.width * 0.03,
                  bottom: screenSize.width * 0.03,
                  child: Text(
                    playlist.name,
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: screenSize.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongsRow(List<Song> songs, Size screenSize) {
    return SizedBox(
      height: screenSize.width * 0.45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final song = songs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongPlayerScreen(
                    song: song,
                    playlist: songs,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: Container(
              width: screenSize.width * 0.35,
              margin: EdgeInsets.only(right: screenSize.width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      song.imageUrl,
                      width: screenSize.width * 0.35,
                      height: screenSize.width * 0.35 * 0.75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  Text(
                    song.title,
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: screenSize.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.genre,
                    style: TextStyle(
                      color: AppTheme.gray,
                      fontSize: screenSize.width * 0.035,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: AppTheme.gray,
                      fontSize: screenSize.width * 0.035,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenresRow(List<Genre> genres, Size screenSize) {
    return SizedBox(
      height: screenSize.width * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Container(
            width: screenSize.width * 0.45,
            margin: EdgeInsets.only(right: screenSize.width * 0.03),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.asset(
                    genre.imageUrl,
                    width: screenSize.width * 0.45,
                    height: screenSize.width * 0.25,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenSize.width * 0.03,
                    left: screenSize.width * 0.03,
                    child: Text(
                      genre.name,
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: screenSize.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewSongsList(List<Song> songs, Size screenSize) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SongPlayerScreen(
                  song: song,
                  playlist: songs,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: screenSize.height * 0.015),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    song.imageUrl,
                    width: screenSize.width * 0.15,
                    height: screenSize.width * 0.15,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: screenSize.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenSize.height * 0.005),
                      Text(
                        '${song.artist} • ${song.genre}',
                        style: TextStyle(
                          color: AppTheme.gray,
                          fontSize: screenSize.width * 0.035,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    color: AppTheme.white,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: AppTheme.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
