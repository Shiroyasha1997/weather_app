# 🌦 Weather App

## 📌 Descripción
**Weather App** es una aplicación móvil desarrollada en **Flutter** que permite a los usuarios obtener información meteorológica en tiempo real de cualquier ciudad o de su ubicación actual.

## 🎯 Funcionalidades
✅ Buscar el clima por nombre de ciudad.  
✅ Obtener el clima en tiempo real según la ubicación del usuario.  
✅ Mostrar temperatura, humedad, sensación térmica, velocidad del viento y probabilidad de lluvia.  
✅ Sugerencias de ciudades al escribir en el buscador.  
✅ Interfaz limpia y amigable con diseño moderno.

## 🛠 Tecnologías Utilizadas
- **Flutter** (Dart)
- **WeatherAPI** (para obtener datos meteorológicos)
- **Geolocator** (para obtener la ubicación del usuario)
- **HTTP** (para hacer peticiones a la API)

## 📦 Instalación y Configuración

### 1️⃣ Clona el repositorio
```sh
git clone https://github.com/Shiroyasha1997/weather_app.git
cd weather_app
```

### 2️⃣ Instala las dependencias
```sh
flutter pub get
```

### 3️⃣ Ejecuta la aplicación
```sh
flutter run
```

### 💡 Asegúrate de que tu emulador o dispositivo esté conectado.

## 🔑 Configuración de API

Para que la app funcione correctamente, necesitas una clave de API de WeatherAPI. Luego, agrégala en el archivo main.dart:
```sh
final apiKey = 'TU_API_KEY_AQUI';
```

## 📦 Generación de Artefactos Móviles

Para generar los binarios necesarios para Android e iOS, sigue los siguientes pasos. Asegúrate de que tu entorno de desarrollo esté correctamente configurado para Flutter y las herramientas necesarias para Android e iOS.

### 🚀 Generación del APK o AAB para Android

### 1️⃣ Prepara el entorno para Android
Asegúrate de tener Android Studio y las herramientas de línea de comandos de Android configuradas. Si no lo has hecho, instala las herramientas de desarrollo de Android.

### 2️⃣ Genera el APK o AAB
Para generar el archivo APK o AAB, sigue los siguientes pasos:

### Para APK (archivo instalable): Ejecuta el siguiente comando en la terminal:

```sh
flutter build apk --release
```

Este comando generará un archivo APK en la carpeta build/app/outputs/flutter-apk/app-release.apk.

### Para AAB (Android App Bundle): Si prefieres generar un archivo AAB (recomendado para distribuir en Google Play Store), ejecuta:

```sh
flutter build appbundle --release
```

Este comando generará un archivo AAB en la carpeta build/app/outputs/bundle/release/app-release.aab.

## 📌 Nota sobre los archivos binarios
Recuerda que para realizar la distribución en Google Play Store o App Store, necesitarás configurar adecuadamente las claves de firma y las credenciales de cada plataforma. Asegúrate de tener configuradas las claves en los archivos de configuración de Android (build.gradle) e iOS (Runner.xcodeproj o Runner.xcworkspace).

## Autor
### Diego Valenzuela
### valenzueladiego1997@gmail.com
