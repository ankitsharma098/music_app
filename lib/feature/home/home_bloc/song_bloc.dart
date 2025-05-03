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
          lyrics:
              "In the depths of the digital night, Where the pixels flicker, and dreams take flight, We chase the shadows, each step a quest, In this realm of madness, we’re never at rest. With echoes of battles, the warriors rise, Underneath the stars, where the neon sky lies, Power up, gear up, let the journey unfold, In the heart of the chaos, legends are told. Chorus: Into the pixelated abyss, we dive, Where the beat of the drums makes us feel alive, Through the dungeons and realms, we’ll find our way, In this mad world, we’re here to stay. Enemies lurking, we’ll face them with might, As the world spins around us, we harness the light, Together as allies, our strength multiplies, In this pixel paradise, we’ll rise to the skies. Chorus: Into the pixelated abyss, we dive, Where the beat of the drums makes us feel alive, Through the dungeons and realms, we’ll find our way, In this mad world, we’re here to stay. Bridge: Unravel the code, let the magic ignite, In the labyrinth of dreams, we embrace the fight, As the levels progress, we’ll conquer the fear, In this game of life, we’ll persevere. Chorus: Into the pixelated abyss, we dive, Where the beat of the drums makes us feel alive, Through the dungeons and realms, we’ll find our way, In this mad world, we’re here to stay. Outro: So grab your sword, let’s battle tonight, In the pixelated chaos, everything feels right, With every heartbeat, in sync with the sound, In this realm of wonder, our spirits are crowned.",
          description:
              "\"Into the Pixelated Abyss (Version 1)\" is an electrifying electronic track that immerses listeners in a vibrant and adventurous digital landscape. With a duration of 240.44 seconds, this song captures the essence of a video game journey, blending energetic beats and evocative lyrics that evoke a sense of exploration and camaraderie. The song opens with a captivating verse that sets the stage for a nocturnal adventure through a pixelated world. The imagery of flickering pixels and dreams taking flight draws the listener into a realm where shadows are chased and quests are undertaken. This narrative is beautifully supported by a pulsating electronic backdrop that pulses with excitement. As the song progresses, the lyrics introduce a sense of urgency and empowerment, inviting listeners to power up and gear up alongside the warriors who rise beneath a neon sky. The chorus, a catchy and anthemic refrain, encapsulates the spirit of diving into the pixelated abyss, where the driving beat of the drums fuels a feeling of aliveness and resilience. The bridge of the song shifts to a more introspective tone, encouraging listeners to unravel the code and embrace the magic of their journey. It emphasizes themes of perseverance and overcoming fear, aligning perfectly with the gaming motif. The final chorus and outro bring the track to a thrilling climax, celebrating the unity and strength found in companionship. The call to grab a sword and battle resonates strongly, reinforcing the idea that in this pixelated chaos, everything feels right. The male vocals deliver a dynamic performance, enhancing the song's adventurous spirit. Overall, \\\"Into the Pixelated Abyss (Version 1)\\\" is a high-energy electronic anthem that captures the thrill of adventure in a digital realm, making it a perfect soundtrack for gamers and dreamers alike. The accompanying artwork complements the theme, showcasing the vibrant and chaotic beauty of the pixelated world.",
        ),
        Song(
            title: 'Fields of Innovation',
            artist: 'Code Infinity',
            genre: 'Electronic Pop',
            imageUrl: 'assets/images/trending/trending_song 2.jpg',
            audioPath:
                'assets/audio/trending songs/Fields of Innovation-SongGPT.mp3',
            lyrics:
                "(Verse 1) In the heart of the earth, where the seeds are sown, A spark of brilliance, into the unknown. Algorithms dance in the light of the dawn, Guiding the farmers, till the worries are gone. (Chorus) Fields of innovation, growing brighter each day, With every pixel planted, we’re paving the way. From data to dreams, let the harvest begin, Together we’ll flourish, let the future in. (Verse 2) Upload your worries, let the numbers unfold, Crop by crop, watch the magic behold. Disease in the shadows, we’ll shine a bright light, With AI beside us, we’ll conquer the night. (Chorus) Fields of innovation, growing brighter each day, With every pixel planted, we’re paving the way. From data to dreams, let the harvest begin, Together we’ll flourish, let the future in. (Bridge) User-friendly pathways, where knowledge ignites, An interactive journey, reaching new heights. Fertilizer whispers, a tailored embrace, In this digital garden, we’re finding our place. (Chorus) Fields of innovation, growing brighter each day, With every pixel planted, we’re paving the way. From data to dreams, let the harvest begin, Together we’ll flourish, let the future in. (Outro) So here’s to the farmers, the dreamers, the wise, In the fields of innovation, we’ll rise to the skies.",
            description:
                "Oh my goodness, I am thrilled to share \"Fields of Innovation\" with you! This upbeat Electronic Pop track captures the exhilarating fusion of technology and agriculture, painting a vivid picture of a future where AI and nature collaborate harmoniously. With lyrics that dance through themes of growth and optimism, we explore the journey of transforming worries into dreams, as algorithms illuminate the path for farmers. The infectious chorus beckons us to join in the celebration of innovation, reminding us that together, we can flourish and embrace a brighter tomorrow. I can't wait for you to listen to it and feel the energy of this digital garden come alive! 🌱✨ Check out the audio and let the waves of inspiration wash over you!"),
        Song(
          title: "Victory Anthem_ Kohli's Century",
          artist: 'Mr. Swap',
          genre: 'Bollywood',
          imageUrl: 'assets/images/trending/trending song 3.jpg',
          audioPath:
              "assets/audio/trending songs/Victory Anthem_ Kohli's Century (Version 2)-SongGPT.mp3",
          lyrics:
              "In the Dubai sun, we shine bright, India’s warriors ready for the fight. With roar from the crowd, hearts on fire, Coley leads us, oh we aspire! Victory! Oh victory! Champions of the game, we rise in unity. Together we stand, side by side, India’s glory, let’s take the ride! Victory! Oh victory! Champions of the game, we rise in unity. Together we aspire! Victory! Oh victory! Champions of the game, we rise in unity. Together we stand, side by side, India’s glory, let’s take the ride! Victory! Oh victory! Champions of the game, we rise in unity. Together we stand, side by side, India’s glory, let’s take the ride! Victory! Oh victory! Champions of the game, we rise in unity. Together we stand, side by side, India’s glory, let’s take the ride! Victory! Oh victory! Champions of the game, we rise in unity. Together we stand, side by side, India’s glory, let’s take the ride! So here's to the team that brings us pride. The joy of cricket, our hearts collide. Raising our flags high in delight. Together we celebrate this winning night!",
          description:
              "Title: Victory Anthem: Kohli's Century (Version 2). Genre: Bollywood. Gist: This song encapsulates the spirit of unity and pride among Indian cricket fans, celebrating the triumphs of their team, particularly under the leadership of Virat Kohli. It narrates the exhilarating journey of a match, culminating in a collective celebration of victory. Themes: The key themes explored in this anthem include national pride, camaraderie, resilience, and the thrill of competition. The lyrics highlight the passion for cricket as a unifying force, showcasing the emotional bond between the players and their supporters. Inspiration: Inspired by the electrifying atmosphere of cricket matches, especially those involving iconic players like Virat Kohli, this song captures the essence of victory and the communal joy associated with sports. It reflects the original request for a celebratory anthem that resonates with cricket fans. Emotional Impact: Listeners are likely to feel a surge of exhilaration and pride, as the song evokes a sense of belonging and shared triumph. The uplifting melodies and powerful lyrics foster a spirit of enthusiasm and celebration, making it an anthem for fans to rally around during moments of victory.",
        ),
      ];

      final songGptSongs = [
        Song(
          title: 'Waves of Resilience 2',
          artist: 'Song GPT',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/songGPT/songGpt 1.jpg',
          audioPath: 'assets/audio/songGpt/Waves of Resilience 2-SongGPT.mp3',
          lyrics:
              "In the valleys where silence falls, And snowflakes dance through whispered calls, And fragile hearts beneath the skies, A story weaves through painted sides. From solitude to solidarity, We rise with hope, a sweet clarity. In the arms of time, united we stand, Echoes of strength across this land. Rebab sings in gentle flow, Santa weeps for loss we know, Through shadows deep where sorrows lay, A melody finds its way. From solitude to solidarity, We rise with hope, a sweet clarity. In the arms of time, united we stand, Echoes of strength across this land. Orchestral swells like waves cascade, Filling the void where dreams once played. The past may linger like winter's chill, But through the storm, we find our will. In Pahocan's heart, we forge anew, With every heartbeat, our spirits grew. From silent suffering to vibrant life, Together we stand through joy and strife.",
          description:
              "Waves of Resilience' narrates a journey from isolation to unity, illustrating how shared struggles can foster hope and strength. The song encapsulates a collective rise from silence and sorrow, ultimately celebrating the resilience of the human spirit. The key themes include resilience in the face of adversity, the healing power of community, and the journey from solitude to solidarity. The imagery of nature and music intertwines with emotional depth, highlighting both personal and collective experiences of loss and renewal. Inspired by the original prompt, the song draws on the interplay of silence and sound, using nature's elements and traditional instruments to evoke a sense of place and emotion. The essence of connection and hope within adversity is beautifully woven throughout the lyrics. Listeners may feel a profound sense of empathy and empowerment, as the song resonates with their own experiences of struggle and triumph. The soaring orchestration and heartfelt lyrics create an uplifting atmosphere that encourages reflection and a renewed sense of purpose.",
        ),
        Song(
          title: 'Song GPT Anthem 2',
          artist: 'Song GPT',
          genre: 'Electronic',
          imageUrl: 'assets/images/songGPT/songGpt 2.jpg',
          audioPath: 'assets/audio/songGpt/Song GPT Anthem 2-SongGPT.mp3',
          lyrics: '',
          description: '',
        ),
        Song(
          title: 'Song GPT Anthem 1',
          artist: 'Song GPT',
          genre: 'Electronic',
          imageUrl: 'assets/images/songGPT/songGpt 3.jpg',
          audioPath: 'assets/audio/songGpt/Song GPT Anthem 1-SongGPT.mp3',
          lyrics: '',
          description: '',
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
          lyrics: '',
          description: '',
        ),
        Song(
          title: 'Lealtad Inquebrantable 2',
          artist: 'Jv',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/new songs/new song 2.jpg',
          audioPath:
              'assets/audio/new songs/Lealtad Inquebrantable 2-SongGPT.mp3',
          lyrics: '',
          description: '',
        ),
        Song(
          title: 'Weggabelung des Lebens 2',
          artist: 'Maxi421',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/new songs/new song 3.jpg',
          audioPath:
              'assets/audio/new songs/Weggabelung des Lebens 2-SongGPT.mp3',
          lyrics: '',
          description: '',
        ),
        Song(
          title: 'Weggabelung des Lebens 1',
          artist: 'Maxi421',
          genre: 'Futuristic beat, Psychedelic vibes,',
          imageUrl: 'assets/images/new songs/new song 3.jpg',
          audioPath:
              'assets/audio/new songs/Weggabelung des Lebens 1-SongGPT.mp3',
          lyrics: '',
          description: '',
        ),
        Song(
          title: 'Nouveau Départ 1',
          artist: 'Maxi421',
          genre: 'Ballad',
          imageUrl: 'assets/images/new songs/new song 3.jpg',
          audioPath: 'assets/audio/new songs/Nouveau Départ 1-SongGPT.mp3',
          lyrics: '',
          description: '',
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
