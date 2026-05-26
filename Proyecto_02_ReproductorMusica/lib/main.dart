import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class Song {
  final String title;
  final String artist;
  final String audio;
  final String image;

  Song({
    required this.title,
    required this.artist,
    required this.audio,
    required this.image,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Reproductor del Moreno',
      theme: ThemeData.dark(),
      home: const MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() =>
      _MusicPlayerScreenState();
}

class _MusicPlayerScreenState
    extends State<MusicPlayerScreen> {

  final AudioPlayer player = AudioPlayer();

  bool isPlaying = false;

  int currentSongIndex = 0;

  final List<Song> songs = [

    Song(
      title: "My Sweet Lord",
      artist: "George Harrison",
      audio: "assets/my_sweet_lord.mp3",
      image: "assets/my_sweet_lord.jpg",
    ),

    Song(
      title: "Don't Let Me Down",
      artist: "The Beatles",
      audio: "assets/dont_let_me_down.mp3",
      image: "assets/dont_let_me_down.jpg",
    ),
  ];

  @override
  void initState() {
    super.initState();

    loadSong();

    // Escuchar cambios del reproductor
    player.playingStream.listen((playing) {

      setState(() {
        isPlaying = playing;
      });
    });
  }

  Future<void> loadSong() async {

    // Detener canción actual
    await player.stop();

    // Cargar nueva canción
    await player.setAsset(
      songs[currentSongIndex].audio,
    );

    setState(() {});
  }

  Future<void> playMusic() async {
    await player.play();
  }

  Future<void> pauseMusic() async {
    await player.pause();
  }

  Future<void> nextSong() async {

    if (currentSongIndex < songs.length - 1) {
      currentSongIndex++;
    } else {
      currentSongIndex = 0;
    }

    await loadSong();

    await playMusic();
  }

  Future<void> previousSong() async {

    if (currentSongIndex > 0) {
      currentSongIndex--;
    } else {
      currentSongIndex = songs.length - 1;
    }

    await loadSong();

    await playMusic();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Song currentSong = songs[currentSongIndex];

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Color(0xFF1E1E1E),
              Color(0xFF121212),
              Colors.black,
            ],
          ),
        ),

        child: SafeArea(

          child: SingleChildScrollView(

            child: Padding(
              padding: const EdgeInsets.all(25),

              child: ConstrainedBox(

                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 50,
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                // Título superior
                const Text(
                  "NOW PLAYING",

                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 3,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 35),

                // Imagen elegante
                Container(
                  width: 280,
                  height: 280,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [

                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                    ],

                    image: DecorationImage(
                      image: AssetImage(currentSong.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Título canción
                Text(
                  currentSong.title,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // Artista
                Text(
                  currentSong.artist,

                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 25),

                // Barra progreso
                StreamBuilder<Duration>(
                  stream: player.positionStream,

                  builder: (context, snapshot) {

                    Duration position =
                        snapshot.data ?? Duration.zero;

                    Duration duration =
                        player.duration ?? Duration.zero;

                    return Column(
                      children: [

                        SliderTheme(

                          data: SliderTheme.of(context).copyWith(

                            trackHeight: 4,

                            thumbShape:
                                const RoundSliderThumbShape(
                              enabledThumbRadius: 7,
                            ),

                            overlayShape:
                                const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                          ),

                          child: Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey.shade800,

                            min: 0,

                            max: duration.inSeconds > 0
                                ? duration.inSeconds.toDouble()
                                : 1,

                            value: position.inSeconds
                                .toDouble()
                                .clamp(
                                  0,
                                  duration.inSeconds > 0
                                      ? duration.inSeconds
                                          .toDouble()
                                      : 1,
                                ),

                            onChanged: (value) async {

                              await player.seek(
                                Duration(
                                  seconds: value.toInt(),
                                ),
                              );
                            },
                          ),
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                          children: [

                            Text(
                              formatTime(position),

                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            Text(
                              formatTime(duration),

                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 25),

                // Botones modernos
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    // Previous
                    IconButton(
                      onPressed: previousSong,

                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        size: 45,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Play/Pause
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF5A5A5A),
                            Color(0xFF2E2E2E),
                          ],
                        ),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),

                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.transparent,

                        child: IconButton(
                          onPressed: () async {

                            if (isPlaying) {
                              await pauseMusic();
                            } else {
                              await playMusic();
                            }
                          },

                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,

                            size: 45,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Next
                    IconButton(
                      onPressed: nextSong,

                      icon: const Icon(
                        Icons.skip_next_rounded,
                        size: 45,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatTime(Duration duration) {

    String twoDigits(int n) =>
        n.toString().padLeft(2, '0');

    String minutes =
        twoDigits(duration.inMinutes.remainder(60));

    String seconds =
        twoDigits(duration.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }
}