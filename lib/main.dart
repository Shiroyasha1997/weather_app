import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Roboto', // Usamos la fuente Roboto
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  String _weather = '';
  String _temperature = '';
  String _windSpeed = '';
  String _feelsLike = '';
  String _sunrise = '';
  String _sunset = '';
  String _rainChance = '';
  String _weatherIconUrl = '';
  bool _isLoading = false;
  bool _isLocationPermissionGranted = false;
  Color _backgroundColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _weather = 'Los servicios de ubicación están deshabilitados.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _weather = 'Permiso de ubicación denegado.';
        });
        return;
      }
    }

    setState(() {
      _isLocationPermissionGranted = true;
    });
  }

  Future<Position?> _getCurrentLocation() async {
    if (_isLocationPermissionGranted) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }
    return null;
  }

  Future<void> _getWeather() async {
    setState(() {
      _isLoading = true;
      _weather = '';
      _temperature = '';
      _windSpeed = '';
      _feelsLike = '';
      _sunrise = '';
      _sunset = '';
      _rainChance = '';
      _backgroundColor = Colors.blue; // Resetear el fondo por defecto
      _weatherIconUrl = ''; // Resetear el ícono
    });

    final apiKey = '2c578e426a2c4e4bb3f234043252603'; // 🔥 Reemplaza con tu API Key
    String city = _cityController.text.trim();

    if (city.isEmpty && _isLocationPermissionGranted) {
      // Si no se proporciona una ciudad, obtenemos la ubicación actual
      Position? position = await _getCurrentLocation();
      if (position != null) {
        city = '${position.latitude},${position.longitude}';
      } else {
        setState(() {
          _isLoading = false;
          _weather = 'Error al obtener la ubicación.';
        });
        return;
      }
    }

    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no&lang=es'); // Cambié lang=es para obtener en español

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);  // Imprime la respuesta completa para verificar los datos

        if (data['location'] != null && data['current'] != null) {
          setState(() {
            _isLoading = false;

            // Asignamos los nuevos valores
            _weather = '${data['location']['name']}, ${data['location']['region']}, ${data['location']['country']} - ${data['current']['condition']['text']}';
            _temperature = '${data['current']['temp_c']}°C';
            _windSpeed = '${data['current']['wind_kph']} km/h';
            _feelsLike = '${data['current']['feelslike_c']}°C';

            // Verificar si la clave 'astro' existe antes de acceder a 'sunrise' y 'sunset'
            if (data['current']['astro'] != null) {
              _sunrise = data['current']['astro']['sunrise'] ?? 'Desconocido';
              _sunset = data['current']['astro']['sunset'] ?? 'Desconocido';
            } else {
              _sunrise = 'No disponible';
              _sunset = 'No disponible';
            }

            _rainChance = '${data['current']['precip_mm']} mm';

            // Asignamos el ícono
            _weatherIconUrl = 'https:${data['current']['condition']['icon']}';
          });
        } else {
          setState(() {
            _isLoading = false;
            _weather = 'Ciudad no encontrada o datos inválidos.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _weather = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _weather = 'Fallo al obtener los datos del clima. Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Container(
        color: _backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ingresa el nombre de la ciudad',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getWeather,
              child: const Text('Obtener clima'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _weatherIconUrl.isEmpty
                        ? const CircularProgressIndicator()
                        : Image.network(
                      _weatherIconUrl,
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      _temperature,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _weather,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  '🌡️ Sensación térmica: $_feelsLike',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '💨 Velocidad del viento: $_windSpeed',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '🌅 Amanecer: $_sunrise',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '🌇 Atardecer: $_sunset',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '🌧️ Probabilidad de lluvia: $_rainChance',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
