// Importación de librerías necesarias
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

// Punto de entrada principal de la aplicación
void main() {
  runApp(MyApp());
}

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // ChangeNotifierProvider permite compartir el estado
    // de la aplicación con todos los widgets hijos
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),

      // MaterialApp configura la aplicación Flutter
      child: MaterialApp(
        title: 'Leccion 1',

        // Configuración del tema general
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 34, 67, 255),
          ),
        ),

        // Pantalla principal
        home: MyHomePage(),
      ),
    );
  }
}

// Clase encargada de manejar el estado global de la aplicación
class MyAppState extends ChangeNotifier {

  // Genera un par de palabras aleatorias
  var current = WordPair.random();

  // Lista de palabras favoritas
  var favorites = <WordPair>[];

  // Genera una nueva palabra aleatoria
  void getNext() {
    current = WordPair.random();

    // Notifica a los widgets que deben actualizarse
    notifyListeners();
  }

  // Agrega o elimina palabras de favoritos
  void toggleFavorite() {

    // Si ya existe en favoritos la elimina
    if (favorites.contains(current)) {
      favorites.remove(current);

    // Si no existe la agrega
    } else {
      favorites.add(current);
    }

    // Actualiza la interfaz
    notifyListeners();
  }
}

// Widget principal con estado
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() =>
  _MyHomePageState();
}

// Estado asociado al widget principal
class _MyHomePageState extends State<MyHomePage> {

  // Índice seleccionado en el menú lateral
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    // Variable que almacenará la página actual
    Widget page;

    // Cambia de pantalla según la opción seleccionada
    switch (selectedIndex) {

      // Página principal
      case 0:
        page = GeneratorPage();
        break;

      // Página de favoritos
      case 1:
        page = FavoritesPage();
        break;

      // Error en caso de no existir la opción
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // LayoutBuilder permite adaptar la interfaz
    // dependiendo del tamaño de pantalla
    return LayoutBuilder(
      builder: (context, constraints) {

        return Scaffold(
          body: Row(
            children: [

              // SafeArea evita invadir zonas del sistema
              SafeArea(

                // Menú lateral de navegación
                child: NavigationRail(

                  // Color de fondo del menú
                  backgroundColor:
                  Theme.of(context).colorScheme.surface,

                  // Color de íconos seleccionados
                  selectedIconTheme:
                  IconThemeData(color: Colors.blue),

                  // Estilo del texto seleccionado
                  selectedLabelTextStyle:
                  TextStyle(fontWeight: FontWeight.bold),

                  // Extiende el menú en pantallas grandes
                  extended: constraints.maxWidth >= 600,

                  // Opciones del menú
                  destinations: [

                    // Opción Home
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),

                    // Opción Favorites
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],

                  // Índice actual seleccionado
                  selectedIndex: selectedIndex,

                  // Cambia de pantalla al seleccionar opción
                  onDestinationSelected: (value) {

                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),

              // Expande el contenido restante
              Expanded(

                child: Container(

                  // Fondo degradado
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .primaryContainer,

                        Theme.of(context)
                            .colorScheme
                            .secondaryContainer,
                      ],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  // Muestra la página seleccionada
                  child: page,
                ),
              )
            ],
          ),
        );
      }
    );
  }
}

// Página encargada de generar palabras aleatorias
class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Obtiene el estado global
    var appState = context.watch<MyAppState>();

    // Obtiene la palabra actual
    var pair = appState.current;

    // Variable para cambiar el ícono dinámicamente
    IconData icon;

    // Verifica si la palabra ya es favorita
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;

    } else {
      icon = Icons.favorite_border;
    }

    return Center(

      child: Column(

        // Centra verticalmente los elementos
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          // Tarjeta principal con la palabra
          BigCard(pair: pair),

          SizedBox(height: 30),

          Row(

            // Ajusta tamaño horizontal mínimo
            mainAxisSize: MainAxisSize.min,

            children: [

              // Botón de favoritos
              ElevatedButton.icon(

                onPressed: () {

                  // Agrega o elimina favorito
                  appState.toggleFavorite();

                  // Verifica estado actual
                  final isFav =
                  appState.favorites.contains(pair);

                  // Mensaje emergente
                  ScaffoldMessenger.of(context).showSnackBar(

                    SnackBar(
                      content: Text(
                        isFav
                        ? 'Añadido a favoritos ❤️'
                        : 'Eliminado de favoritos 💔',
                      ),

                      duration: Duration(seconds: 1),
                    ),
                  );
                },

                // Animación del ícono
                icon: AnimatedSwitcher(

                  duration: Duration(milliseconds: 300),

                  transitionBuilder:
                  (child, animation) =>

                  ScaleTransition(
                    scale: animation,
                    child: child,
                  ),

                  child: Icon(
                    icon,
                    key: ValueKey(icon),
                  ),
                ),

                label: Text('Like'),
              ),

              SizedBox(width: 10),

              // Botón para generar nueva palabra
              ElevatedButton(

                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onPressed: () {

                  // Genera nueva palabra
                  appState.getNext();
                },

                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Página encargada de mostrar favoritos
class FavoritesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Obtiene el estado global
    var appState = context.watch<MyAppState>();

    // Verifica si no hay favoritos
    if (appState.favorites.isEmpty) {

      return Center(
        child: Text('No Favorites yet.'),
      );
    }

    // Lista de favoritos
    return ListView(

      children: [

        // Texto mostrando cantidad de favoritos
        Padding(

          padding: const EdgeInsets.all(20),

          child: Text(
            'You have '
            '${appState.favorites.length} favorites:',
          ),
        ),

        // Recorre todos los favoritos
        for (var pair in appState.favorites)

          ListTile(

            // Ícono de favorito
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),

            // Texto de la palabra
            title: Text(
              pair.asLowerCase,

              style: TextStyle(fontSize: 18),
            ),
          )
      ],
    );
  }
}

// Widget reutilizable para mostrar palabras grandes
class BigCard extends StatelessWidget {

  const BigCard({
    super.key,
    required this.pair,
  });

  // Palabra recibida
  final WordPair pair;

  @override
  Widget build(BuildContext context) {

    // Obtiene el tema actual
    final theme = Theme.of(context);

    // Estilo del texto
    final style =
    theme.textTheme.displayMedium!.copyWith(

      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );

    // AnimatedSwitcher agrega transición animada
    return AnimatedSwitcher(

      duration: Duration(milliseconds: 400),

      transitionBuilder: (child, animation) {

        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },

      child: Card(

        // Clave única para animaciones
        key: ValueKey(pair.asLowerCase),

        elevation: 8,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        color: theme.colorScheme.primary,

        child: Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),

          // Muestra la palabra
          child: Text(
            pair.asLowerCase,
            style: style,
          ),
        ),
      ),
    );
  }
}