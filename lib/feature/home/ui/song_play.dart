import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

import '../model/song_model.dart';

class SongPlayerScreen extends StatefulWidget {
  final Song song;
  final List<Song> playlist;
  final int initialIndex;

  const SongPlayerScreen({
    super.key,
    required this.song,
    required this.playlist,
    required this.initialIndex,
  });

  @override
  State<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends State<SongPlayerScreen> {
  late PageController _pageController;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isFavorite = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Create the AudioPlayer
    _audioPlayer = AudioPlayer();
    _loadCurrentSong();
  }

  Future<void> _loadCurrentSong() async {
    try {
      await _audioPlayer.stop();

      final currentSong = widget.playlist[_currentIndex];

      await _audioPlayer.setAsset(currentSong.audioPath);

      _totalDuration = currentSong.duration;

      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      });

      _audioPlayer.playerStateStream.listen((playerState) {
        if (mounted) {
          setState(() {
            isPlaying = playerState.playing;
          });
        }
      });

      await _audioPlayer.play();
    } catch (e) {
      print('Error loading audio source: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 28,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.playlist_play,
                color: Colors.white,
                size: 28,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.playlist.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _loadCurrentSong();
        },
        itemBuilder: (context, index) {
          final song = widget.playlist[index];

          final progress = _totalDuration.inMilliseconds > 0
              ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
              : 0.0;

          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(song.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "#${song.genre.toLowerCase()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const Spacer(flex: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left sound wave
                          SizedBox(
                            width: screenSize.width * 0.2,
                            height: screenSize.height * 0.1,
                            child: _buildSoundWave(isLeft: true),
                          ),

                          // Album art
                          Container(
                            width: screenSize.width * 0.4,
                            height: screenSize.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage(song.imageUrl),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                          ),

                          // Right sound wave
                          SizedBox(
                            width: screenSize.width * 0.2,
                            height: screenSize.height * 0.1,
                            child: _buildSoundWave(isLeft: false),
                          ),
                        ],
                      ),

                      const Spacer(flex: 1),

                      Text(
                        song.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenSize.height * 0.01),

                      Text(
                        song.artist,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),

                      const Spacer(flex: 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.bookmark_border,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const Spacer(flex: 1),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.replay,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await _audioPlayer.seek(Duration.zero);
                              if (!isPlaying) {
                                await _audioPlayer.play();
                              }
                            },
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 2,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14,
                                ),
                                activeTrackColor: Colors.white,
                                inactiveTrackColor:
                                    Colors.white.withOpacity(0.3),
                                thumbColor: Colors.white,
                                overlayColor: Colors.white.withOpacity(0.3),
                              ),
                              child: Slider(
                                value: progress.clamp(0.0, 1.0),
                                onChanged: (value) async {
                                  final newPosition = Duration(
                                    milliseconds:
                                        (value * _totalDuration.inMilliseconds)
                                            .round(),
                                  );
                                  await _audioPlayer.seek(newPosition);
                                },
                              ),
                            ),
                          ),
                          Text(
                            _formatDuration(_currentPosition),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 36,
                            ),
                            onPressed: () {
                              if (_currentIndex > 0) {
                                _pageController.animateToPage(
                                  _currentIndex - 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                          SizedBox(width: screenSize.width * 0.05),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 36,
                              ),
                              onPressed: () async {
                                if (isPlaying) {
                                  await _audioPlayer.pause();
                                } else {
                                  await _audioPlayer.play();
                                }
                              },
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.05),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 36,
                            ),
                            onPressed: () {
                              if (_currentIndex < widget.playlist.length - 1) {
                                _pageController.animateToPage(
                                  _currentIndex + 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      // Swipe indicator
                      Container(
                        margin: EdgeInsets.only(
                            top: screenSize.height * 0.02,
                            bottom: screenSize.height * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.white.withOpacity(0.5),
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Swipe for next song",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white.withOpacity(0.5),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSoundWave({required bool isLeft}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        // Create sound wave bars
        final List<Widget> bars = [];
        final int numberOfBars = 5;
        final double barWidth = width / (numberOfBars * 2 - 1);

        for (int i = 0; i < numberOfBars; i++) {
          // Animated heights based on playing state
          double barHeight;
          if (isPlaying) {
            // Create a dynamic effect with different heights
            final double baseHeight = [0.6, 1.0, 0.8, 0.7, 0.9][i];
            final double randomFactor =
                isLeft ? (i % 2 == 0 ? 0.2 : -0.2) : (i % 2 == 0 ? -0.2 : 0.2);

            // Use current position to create some variation
            final positionFactor =
                (_currentPosition.inMilliseconds % 1000) / 1000.0;
            barHeight = (baseHeight + (randomFactor * positionFactor)) * height;
            barHeight = barHeight.clamp(0.3 * height, height);
          } else {
            barHeight = 0.5 * height; // All bars same height when paused
          }

          bars.add(
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: barWidth,
              height: barHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );

          // Add spacing between bars (except after the last one)
          if (i < numberOfBars - 1) {
            bars.add(SizedBox(width: barWidth));
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: bars,
        );
      },
    );
  }
}
