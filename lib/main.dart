import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

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
        fontFamily: 'Roboto',
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
  String _rainChance = '';
  String _humidity = '';
  String _weatherIconUrl = '';
  bool _isLoading = false;
  bool _isLocationPermissionGranted = false;
  Color _backgroundColor = Colors.blue.shade100;

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

  Future<void> _getWeatherByCity() async {
    setState(() {
      _isLoading = true;
      _weather = '';
      _temperature = '';
      _windSpeed = '';
      _feelsLike = '';
      _rainChance = '';
      _humidity = '';
      _backgroundColor = Colors.blue.shade100;
      _weatherIconUrl = '';
    });

    final apiKey = '2c578e426a2c4e4bb3f234043252603';
    String city = _cityController.text.trim();

    if (city.isEmpty) {
      setState(() {
        _isLoading = false;
        _weather = 'Por favor, ingresa una ciudad.';
      });
      return;
    }

    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no&lang=es');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['location'] != null && data['current'] != null) {
          setState(() {
            _isLoading = false;
            _weather =
            '${data['location']['name']}, ${data['location']['region']}, ${data['location']['country']} - ${data['current']['condition']['text']}';
            _temperature = '${data['current']['temp_c']}°C';
            _windSpeed = '${data['current']['wind_kph']} km/h';
            _feelsLike = '${data['current']['feelslike_c']}°C';
            _rainChance = '${data['current']['precip_mm']} mm';
            _humidity = '${data['current']['humidity']}%';
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

  Future<void> _getWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _weather = '';
      _temperature = '';
      _windSpeed = '';
      _feelsLike = '';
      _rainChance = '';
      _humidity = '';
      _backgroundColor = Colors.blue.shade100;
      _weatherIconUrl = '';
    });

    Position? position = await _getCurrentLocation();
    if (position != null) {
      final apiKey = '2c578e426a2c4e4bb3f234043252603';
      final url = Uri.parse(
          'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=${position.latitude},${position.longitude}&aqi=no&lang=es');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['location'] != null && data['current'] != null) {
            setState(() {
              _isLoading = false;
              _weather =
              '${data['location']['name']}, ${data['location']['region']}, ${data['location']['country']} - ${data['current']['condition']['text']}';
              _temperature = '${data['current']['temp_c']}°C';
              _windSpeed = '${data['current']['wind_kph']} km/h';
              _feelsLike = '${data['current']['feelslike_c']}°C';
              _rainChance = '${data['current']['precip_mm']} mm';
              _humidity = '${data['current']['humidity']}%';
              _weatherIconUrl = 'https:${data['current']['condition']['icon']}';
            });
          } else {
            setState(() {
              _isLoading = false;
              _weather = 'No se pudo obtener el clima en tu ubicación.';
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
    } else {
      setState(() {
        _isLoading = false;
        _weather = 'Error al obtener la ubicación.';
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ingresa la ciudad',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeatherByCity,
              child: const Text('Obtener clima por ciudad'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeatherByLocation,
              child: const Text('Obtener clima en tu ubicación'),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : Column(
              children: [
                _weatherIconUrl.isEmpty
                    ? const SizedBox.shrink()
                    : Image.network(
                  _weatherIconUrl,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 15),
                Text(
                  _temperature,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  _weather,
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _weatherDetails(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherDetails() {
    return Column(
      children: [
        _buildDetailRow('🌡️ Sensación térmica:', _feelsLike),
        _buildDetailRow('💨 Velocidad del viento:', _windSpeed),
        _buildDetailRow('🌧️ Probabilidad de lluvia:', _rainChance),
        _buildDetailRow('💧 Humedad:', _humidity),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        '$label $value',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
