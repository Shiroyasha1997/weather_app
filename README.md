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

### Para que la app funcione correctamente, necesitas una clave de API de WeatherAPI. Luego, agrégala en el archivo main.dart:
```sh
final apiKey = 'TU_API_KEY_AQUI';
```