import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// Función principal de la aplicación
void main() {

  // Ejecuta la aplicación Flutter
  runApp(const MyApp());
}

// Clase que representa una canción
class Song {

  // Título de la canción
  final String title;

  // Nombre del artista
  final String artist;

  // Ruta del archivo de audio
  final String audio;

  // Ruta de la imagen de portada
  final String image;

  // Constructor de la clase Song
  Song({
    required this.title,
    required this.artist,
    required this.audio,
    required this.image,
  });
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Configuración principal de la app
    return MaterialApp(

      // Oculta la etiqueta DEBUG
      debugShowCheckedModeBanner: false,

      // Título de la aplicación
      title: 'Mini Reproductor del Moreno',

      // Tema oscuro de la aplicación
      theme: ThemeData.dark(),

      // Pantalla inicial
      home: const MusicPlayerScreen(),
    );
  }
}

// Pantalla principal del reproductor
class MusicPlayerScreen extends StatefulWidget {

  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() =>
      _MusicPlayerScreenState();
}

// Estado de la pantalla principal
class _MusicPlayerScreenState
    extends State<MusicPlayerScreen> {

  // Objeto encargado de reproducir audio
  final AudioPlayer player = AudioPlayer();

  // Variable que indica si la música está reproduciéndose
  bool isPlaying = false;

  // Índice de la canción actual
  int currentSongIndex = 0;

  // Lista de canciones disponibles
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

    // Carga la canción inicial
    loadSong();

    // Escucha cambios en el estado del reproductor
    player.playingStream.listen((playing) {

      // Actualiza el estado de reproducción
      setState(() {
        isPlaying = playing;
      });
    });
  }

  // Función para cargar la canción actual
  Future<void> loadSong() async {

    // Detiene cualquier canción en reproducción
    await player.stop();

    // Carga el archivo de audio correspondiente
    await player.setAsset(
      songs[currentSongIndex].audio,
    );

    // Actualiza la interfaz
    setState(() {});
  }

  // Función para reproducir música
  Future<void> playMusic() async {

    await player.play();
  }

  // Función para pausar música
  Future<void> pauseMusic() async {

    await player.pause();
  }

  // Función para avanzar a la siguiente canción
  Future<void> nextSong() async {

    // Verifica si hay más canciones disponibles
    if (currentSongIndex < songs.length - 1) {

      currentSongIndex++;

    } else {

      // Regresa a la primera canción
      currentSongIndex = 0;
    }

    // Carga la nueva canción
    await loadSong();

    // Reproduce automáticamente
    await playMusic();
  }

  // Función para regresar a la canción anterior
  Future<void> previousSong() async {

    // Verifica si no está en la primera canción
    if (currentSongIndex > 0) {

      currentSongIndex--;

    } else {

      // Regresa a la última canción
      currentSongIndex = songs.length - 1;
    }

    // Carga la nueva canción
    await loadSong();

    // Reproduce automáticamente
    await playMusic();
  }

  @override
  void dispose() {

    // Libera recursos del reproductor
    player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Obtiene la canción actual
    Song currentSong = songs[currentSongIndex];

    return Scaffold(

      body: Container(

        // Fondo degradado oscuro
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

                // Ajusta el contenido al tamaño de la pantalla
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 50,
                ),

                child: Column(

                  // Centra los elementos verticalmente
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                // Texto superior del reproductor
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

                // Contenedor de la portada de la canción
                Container(

                  width: 280,
                  height: 280,

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(30),

                    // Sombra elegante para la imagen
                    boxShadow: [

                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                    ],

                    // Imagen de portada
                    image: DecorationImage(
                      image: AssetImage(currentSong.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Nombre de la canción
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

                // Nombre del artista
                Text(
                  currentSong.artist,

                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 25),

                // Barra de progreso de la canción
                StreamBuilder<Duration>(

                  // Escucha la posición actual de reproducción
                  stream: player.positionStream,

                  builder: (context, snapshot) {

                    // Tiempo actual de reproducción
                    Duration position =
                        snapshot.data ?? Duration.zero;

                    // Duración total de la canción
                    Duration duration =
                        player.duration ?? Duration.zero;

                    return Column(
                      children: [

                        // Personalización del Slider
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

                            // Valor máximo del slider
                            max: duration.inSeconds > 0
                                ? duration.inSeconds.toDouble()
                                : 1,

                            // Posición actual de la canción
                            value: position.inSeconds
                                .toDouble()
                                .clamp(
                                  0,
                                  duration.inSeconds > 0
                                      ? duration.inSeconds
                                          .toDouble()
                                      : 1,
                                ),

                            // Permite adelantar o retroceder canción
                            onChanged: (value) async {

                              await player.seek(
                                Duration(
                                  seconds: value.toInt(),
                                ),
                              );
                            },
                          ),
                        ),

                        // Tiempos de reproducción
                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                          children: [

                            // Tiempo actual
                            Text(
                              formatTime(position),

                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            // Tiempo total
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

                // Botones del reproductor
                                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                  children: [

                    // Botón para regresar a la canción anterior
                    IconButton(
                      onPressed: previousSong,

                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),

                    // Botón principal de reproducir y pausar
                    Container(

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        boxShadow: [

                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),

                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,

                        child: IconButton(

                          onPressed: () {

                            // Verificar si la música está sonando
                            if (isPlaying) {

                              pauseMusic();

                            } else {

                              playMusic();
                            }
                          },

                          icon: Icon(

                            // Cambiar icono dinámicamente
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,

                            color: Colors.black,
                            size: 45,
                          ),
                        ),
                      ),
                    ),

                    // Botón para avanzar a la siguiente canción
                    IconButton(
                      onPressed: nextSong,

                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // Texto inferior decorativo
                const Text(
                  "Mini Reproductor desarrollado con Flutter",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
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

  // Función para dar formato al tiempo de reproducción
  // Convierte la duración en minutos y segundos
  String formatTime(Duration duration) {

    String twoDigits(int n) =>
        n.toString().padLeft(2, '0');

    // Obtener minutos
    String minutes =
        twoDigits(duration.inMinutes.remainder(60));

    // Obtener segundos
    String seconds =
        twoDigits(duration.inSeconds.remainder(60));

    // Retornar tiempo formateado
    return "$minutes:$seconds";
  }
}
