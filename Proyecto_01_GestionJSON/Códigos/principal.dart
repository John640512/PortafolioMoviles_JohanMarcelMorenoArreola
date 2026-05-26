import 'dart:io';       // Para manejo de archivos y consola
import 'dart:convert';  // Para trabajar con JSON
import 'Registro.dart'; // Importa la clase Registro

// Lista global donde se almacenan los objetos
List<Registro> lista = [];

Future<void> main() async {
  await cargarDatos(); // Carga datos desde el archivo JSON

  int opcion;

  // Ciclo del menú
  do {
    mostrarMenu();
    opcion = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    switch (opcion) {
      case 1:
        mostrarDatos(); // Muestra todos los registros
        break;
      case 2:
        buscarPorNombre(); // Busca por nombre
        break;
      case 3:
        filtrarPorEdad(); // Filtra por edad mínima
        break;
      case 4:
        filtrarPorSalario(); // Filtra por salario mínimo
        break;
      case 5:
        mostrarEstadisticas(); // Calcula estadísticas
        break;
      case 6:
        await exportarJSON(); // Exporta a JSON (espera que termine)
        break;
      case 7:
        print("Saliendo del menú...");
        break;
      default:
        print("Opción inválida, pruebe con otro número");
    }
  } while (opcion != 7);
}

// Muestra el menú en consola
void mostrarMenu() {
  print("\n===== BIENVENIDO AL MENÚ :D =====");
  print("1. Mostrar datos");
  print("2. Buscar por nombre");
  print("3. Filtrar por edad");
  print("4. Filtrar por salario");
  print("5. Ver estadísticas");
  print("6. Exportar resumen JSON");
  print("7. Salir");
  stdout.write("Elija una de las opciones: ");
}

// Carga los datos desde data.json
Future<void> cargarDatos() async {
  try {
    final file = File('data.json');

    // Verifica si el archivo existe
    if (!await file.exists()) {
      print("Archivo data.json no encontrado.");
      return;
    }

    // Lee el contenido del archivo
    final contenido = await file.readAsString();

    // Convierte el texto JSON a lista dinámica
    List<dynamic> jsonData = jsonDecode(contenido);

    // Convierte cada elemento en objeto Registro
    lista = jsonData.map((e) => Registro.fromJson(e)).toList();

    print("Datos cargados correctamente.");
  } catch (e) {
    print("Error al cargar datos: $e");
  }
}

// Muestra todos los registros
void mostrarDatos() {
  if (lista.isEmpty) {
    print("No hay datos.");
    return;
  }

  for (var r in lista) {
    print(r); // Usa toString()
  }
}

// Busca registros por nombre
void buscarPorNombre() {
  stdout.write("Ingrese nombre: ");
  String nombre = stdin.readLineSync() ?? '';

  // Filtra ignorando mayúsculas/minúsculas
  var resultados = lista.where((r) =>
      r.nombre.toLowerCase().contains(nombre.toLowerCase()));

  if (resultados.isEmpty) {
    print("Sin coincidencias.");
  } else {
    resultados.forEach(print);
  }
}

// Filtra registros por edad mínima
void filtrarPorEdad() {
  stdout.write("Edad mínima: ");
  int min = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  var resultados = lista.where((r) => r.edad >= min);

  resultados.forEach(print);
}

// Filtra registros por salario mínimo
void filtrarPorSalario() {
  stdout.write("Salario mínimo: ");
  double min = double.tryParse(stdin.readLineSync() ?? '') ?? 0;

  var resultados = lista.where((r) => r.salario >= min);

  resultados.forEach(print);
}

// Calcula estadísticas generales
void mostrarEstadisticas() {
  if (lista.isEmpty) {
    print("No hay datos.");
    return;
  }

  // Promedio de salario
  double promedio = lista
          .map((e) => e.salario)
          .reduce((a, b) => a + b) /
      lista.length;

  // Edad mínima
  int edadMin = lista
      .map((e) => e.edad)
      .reduce((a, b) => a < b ? a : b);

  // Edad máxima
  int edadMax = lista
      .map((e) => e.edad)
      .reduce((a, b) => a > b ? a : b);

  print("\n=== ESTADÍSTICAS ===");
  print("Promedio salario: \$${promedio.toStringAsFixed(2)}");
  print("Edad mínima: $edadMin");
  print("Edad máxima: $edadMax");
  print("Total registros: ${lista.length}");
}

// Exporta datos y resumen a JSON
Future<void> exportarJSON() async {
  try {
    if (lista.isEmpty) {
      print("No hay datos para exportar.");
      return;
    }

    final file = File('resumen.json');

    // Cálculos
    double promedio = lista
            .map((e) => e.salario)
            .reduce((a, b) => a + b) /
        lista.length;

    int edadMin = lista
        .map((e) => e.edad)
        .reduce((a, b) => a < b ? a : b);

    int edadMax = lista
        .map((e) => e.edad)
        .reduce((a, b) => a > b ? a : b);

    double salarioMin = lista
        .map((e) => e.salario)
        .reduce((a, b) => a < b ? a : b);

    double salarioMax = lista
        .map((e) => e.salario)
        .reduce((a, b) => a > b ? a : b);

    // Construcción del JSON final
    Map<String, dynamic> resumen = {
      "resumen": {
        "total_registros": lista.length,
        "promedio_salario": double.parse(promedio.toStringAsFixed(2)),
        "edad_minima": edadMin,
        "edad_maxima": edadMax,
        "salario_minimo": salarioMin,
        "salario_maximo": salarioMax
      },
      "datos": lista.map((e) => e.toJson()).toList()
    };

    // Formato bonito (indentado)
    var encoder = JsonEncoder.withIndent('  ');
    String jsonBonito = encoder.convert(resumen);

    // Escritura del archivo
    await file.writeAsString(jsonBonito);

    print("Resumen exportado correctamente a resumen.json");
  } catch (e) {
    print("Error al exportar: $e");
  }
}