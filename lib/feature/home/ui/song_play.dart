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

// Add this to your _SongPlayerScreenState class
  bool _showLyricsView = false;
  bool _showDescription = false;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final song = widget.playlist[_currentIndex];

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
            child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
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
              child: _showLyricsView
                  ? const Icon(Icons.close, color: Colors.white)
                  : const Icon(Icons.playlist_add, color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                _showLyricsView = !_showLyricsView;
              });
            },
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
          return Stack(
            children: [
              // Background with blur
              _buildBackground(song),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // Genre tag
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "#${song.genre.toLowerCase()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    // Expanded area for content
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(
                          children: [
                            _showLyricsView
                                ? _buildLyricsView(song, screenSize)
                                : _buildPlayerView(song, screenSize),
                            Positioned(
                              right: 0,
                              top: screenSize.height * 0.32,
                              child: _buildSideActionButtons(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom player controls
                    _buildPlayerControls(screenSize),

                    // Navigation indicator
                    _buildSwipeIndicator(screenSize),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground(Song song) {
    return Container(
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
        child: Container(color: Colors.black.withOpacity(0.6)),
      ),
    );
  }

  Widget _buildPlayerView(Song song, Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Album art with visualizers
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
                borderRadius: BorderRadius.circular(8),
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

        SizedBox(height: 24),

        // Song title
        Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 8),

        // Artist name
        Text(
          song.artist,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLyricsView(Song song, Size screenSize) {
    return Column(
      children: [
        // Tab buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTabButton(
              icon: Icons.mic,
              label: "Lyrics",
              isSelected: !_showDescription,
              onTap: () => setState(() => _showDescription = false),
            ),
            SizedBox(width: 40),
            _buildTabButton(
              icon: Icons.description_outlined,
              label: "Description",
              isSelected: _showDescription,
              onTap: () => setState(() => _showDescription = true),
            ),
          ],
        ),

        SizedBox(height: 20),

        // Lyrics/Description content
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Text(
                _showDescription
                    ? (song.description ?? "No description available")
                    : (song.lyrics ?? "Lyrics not available"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.7,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Container(
            width: label == "Lyrics" ? 80 : 120,
            height: 2,
            color: isSelected ? Colors.white : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildSideActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.white,
          onPressed: () => setState(() => isFavorite = !isFavorite),
        ),
        SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.share,
          onPressed: () {},
        ),
        SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.bookmark_border,
          onPressed: () {},
        ),
        SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.more_vert,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    Color color = Colors.white,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildPlayerControls(Size screenSize) {
    final song = widget.playlist[_currentIndex];
    final progress = _totalDuration.inMilliseconds > 0
        ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.replay, color: Colors.white, size: 20),
                onPressed: () async {
                  await _audioPlayer.seek(Duration.zero);
                  if (!isPlaying) await _audioPlayer.play();
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 14),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.white,
                    overlayColor: Colors.white.withOpacity(0.3),
                  ),
                  child: Slider(
                    value: progress.clamp(0.0, 1.0),
                    onChanged: (value) async {
                      final newPosition = Duration(
                        milliseconds:
                            (value * _totalDuration.inMilliseconds).round(),
                      );
                      await _audioPlayer.seek(newPosition);
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(_currentPosition),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),

        // Play controls
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous,
                    color: Colors.white, size: 36),
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
              SizedBox(width: 16),
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
              SizedBox(width: 16),
              IconButton(
                icon:
                    const Icon(Icons.skip_next, color: Colors.white, size: 36),
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
        ),
      ],
    );
  }

  Widget _buildSwipeIndicator(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.keyboard_arrow_up,
              color: Colors.white.withOpacity(0.5), size: 16),
          SizedBox(width: 5),
          Text(
            "Swipe for next song",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          SizedBox(width: 5),
          Icon(Icons.keyboard_arrow_down,
              color: Colors.white.withOpacity(0.5), size: 16),
        ],
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
