// Clase que representa un registro de persona
class Registro {
  String nombre;
  int edad;
  double salario;

  // Constructor con parámetros obligatorios (Null Safety)
  Registro({
    required this.nombre,
    required this.edad,
    required this.salario,
  });

  // Método factory para convertir JSON a objeto Registro
  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
      nombre: json['nombre'] ?? '', // Si no existe, asigna vacío
      edad: json['edad'] ?? 0,      // Valor por defecto
      salario: (json['salario'] ?? 0).toDouble(), // Conversión a double
    );
  }

  // Método para convertir el objeto Registro a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'edad': edad,
      'salario': salario,
    };
  }

  // Método para mostrar el objeto en consola de forma legible
  @override
  String toString() {
    return "Nombre: $nombre | Edad: $edad | Salario: \$${salario.toStringAsFixed(2)}";
  }
}