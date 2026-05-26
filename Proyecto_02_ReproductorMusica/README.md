# Mini reproductor de música en Flutter

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-App_Móvil-02569B?style=for-the-badge&logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-Programación-0175C2?style=for-the-badge&logo=dart" />
  <img src="https://img.shields.io/badge/VS_Code-Editor-007ACC?style=for-the-badge&logo=visualstudiocode" />
</p>

---

# Objetivo del proyecto

Desarrollar una aplicación móvil capaz de reproducir música utilizando Flutter, implementando controles multimedia, navegación entre canciones y una interfaz visual moderna e interactiva.

---

# Problema que resuelve

El proyecto busca demostrar cómo desarrollar una aplicación multimedia funcional utilizando Flutter, permitiendo reproducir archivos de audio locales mediante controles intuitivos para mejorar la experiencia del usuario.

---

# Tecnologías utilizadas

- Flutter
- Dart
- just_audio
- Visual Studio Code
- GitHub

---

# Conceptos aplicados

- Programación orientada a objetos
- Manejo de widgets en Flutter
- Navegación entre pantallas
- Reproducción multimedia
- Gestión de estados
- Diseño de interfaces móviles
- Uso de librerías externas
- Manejo de listas y objetos

---

# Capturas de pantalla

## Pantalla principal

<p align="center">
  <img src="capturas/inicio.png" width="250"/>
</p>

## Reproducción de música

<p align="center">
  <img src="capturas/reproductor.png" width="250"/>
</p>

## Controles multimedia

<p align="center">
  <img src="capturas/controles.png" width="250"/>
</p>

---

# Instrucciones de ejecución

Sigue estos pasos para clonar y ejecutar el proyecto en tu computadora local para Web y Móvil.

### 1. Requisitos previos
Asegúrate de tener instalado **Flutter** en tu sistema operativo. Puedes verificarlo ejecutando en tu terminal:
```bash
flutter doctor
```
**Nota**: No es necesario instalar Dart por aparte, al instalar Flutter ya te incluye Dart automáticamente.

### 2. Clonar el proyecto
Descarga el código desde el repositorio de GitHub:
```bash
git clone https://github.com/John640512/PortafolioMoviles_JohanMarcelMorenoArreola.git
```

### 3. Entrar al proyecto
Entra a la siguiente ruta dentro del portafolio del proyecto:
```bash
cd Proyecto_02_ReproductorMusica/codigos
```

### 4. Descargar dependencias (Obligatorio)
Como el repositorio está limpio y no incluye archivos temporales, debes reconstruir el entorno descargando los paquetes del proyecto:
```bash
flutter pub get
```

### 5. Ejecutar la aplicación
Para lanzar la aplicación, usa el siguiente comando:
```bash
flutter run
```
La terminal te pedirá seleccionar el dispositivo de destino. Elige **Chrome** (para navegador web) o tu **Celular/Emulador** conectado.

**Nota**: Si deseas forzar la ejecución directa en el navegador web sin que te pregunte, puedes usar:
```bash
flutter run -d chrome
```

# Reflexión personal

## ¿Qué aprendí?

Con este proyecto aprendí mucho más sobre cómo desarrollar aplicaciones móviles usando Flutter y Dart. Antes no entendía completamente cómo funcionaban los widgets ni cómo se construía una interfaz móvil desde cero, pero durante el desarrollo fui comprendiendo mejor la estructura de una aplicación y la forma en que todos los elementos se conectan entre sí.

También aprendí a trabajar con reproducción de audio usando librerías externas como `just_audio`, además de manejar listas de canciones, imágenes y controles multimedia como play, pause, siguiente y anterior. Otra cosa importante fue aprender a organizar mejor el código para que la aplicación fuera más fácil de entender y mantener.

## ¿Qué fue difícil?

Lo más complicado fue lograr que la música funcionara correctamente mientras la interfaz se actualizaba en tiempo real. En algunos momentos los botones no respondían como esperaba o la barra de progreso no avanzaba correctamente mientras se reproducía la canción.

También fue algo difícil adaptar la aplicación para que pudiera ejecutarse tanto en celular como en navegador web sin que se desacomodaran los elementos de la interfaz. Tuve que hacer varias pruebas hasta conseguir un resultado más estable y visualmente agradable.

## ¿Qué mejoraría?

Me gustaría mejorar mucho más el diseño de la aplicación agregando animaciones, efectos visuales y una mejor organización de las canciones. También sería interesante agregar listas de reproducción personalizadas y permitir que el usuario pueda cargar sus propias canciones desde el dispositivo.

Además, en un futuro me gustaría implementar funciones más avanzadas como reproducción en segundo plano y control de volumen más completo.
