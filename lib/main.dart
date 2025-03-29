import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

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
  Timer? _debounce;
  String _weather = '';
  String _temperature = '';
  String _windSpeed = '';
  String _feelsLike = '';
  String _rainChance = '';
  String _humidity = '';
  String _weatherIconUrl = '';
  bool _isLoading = false;
  bool _isLocationPermissionGranted = false;
  List<String> _suggestedCities = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _cityController.addListener(_onCityChanged);
  }

  @override
  void dispose() {
    _cityController.removeListener(_onCityChanged);
    _cityController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onCityChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (_cityController.text.isNotEmpty) {
        _getCitySuggestions(_cityController.text);
      } else {
        setState(() {
          _suggestedCities = [];
          _showSuggestions = false;
        });
      }
    });
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

  Future<void> _getWeatherByCity(String city) async {
    setState(() {
      _isLoading = true;
      _resetWeatherData();
    });

    final apiKey = '2c578e426a2c4e4bb3f234043252603';
    String cityName = city.trim();

    if (cityName.isEmpty) {
      setState(() {
        _isLoading = false;
        _weather = 'Por favor, ingresa una ciudad.';
      });
      return;
    }

    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName&aqi=no&lang=es');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _updateWeatherData(data);
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

  Future<void> _getCitySuggestions(String query) async {
    final apiKey = '2c578e426a2c4e4bb3f234043252603';
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/search.json?key=$apiKey&q=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> cities = data.map<String>((city) => '${city['name']}, ${city['region']}, ${city['country']}').toList();

        setState(() {
          _suggestedCities = cities;
          _showSuggestions = true;
        });
      }
    } catch (e) {
      setState(() {
        _suggestedCities = [];
        _showSuggestions = false;
      });
    }
  }

  Future<void> _getWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _resetWeatherData();
    });

    final position = await _getCurrentLocation();
    if (position == null) {
      setState(() {
        _isLoading = false;
        _weather = 'No se pudo obtener la ubicación.';
      });
      return;
    }

    final apiKey = '2c578e426a2c4e4bb3f234043252603';
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=${position.latitude},${position.longitude}&aqi=no&lang=es');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _updateWeatherData(data);
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

  void _updateWeatherData(Map<String, dynamic> data) {
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
  }

  void _resetWeatherData() {
    _weather = '';
    _temperature = '';
    _windSpeed = '';
    _feelsLike = '';
    _rainChance = '';
    _humidity = '';
    _weatherIconUrl = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade600,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Ingresa la ciudad',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            if (_showSuggestions)
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: ListView.builder(
                  itemCount: _suggestedCities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_suggestedCities[index]),
                      onTap: () {
                        _getWeatherByCity(_suggestedCities[index]);
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeatherByLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30), backgroundColor: Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Obtener clima en tu ubicación', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  if (_weatherIconUrl.isNotEmpty)
                    Image.network(_weatherIconUrl, width: 80, height: 80),
                  const SizedBox(height: 15),
                  Text(_temperature, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Text(_weather, style: const TextStyle(fontSize: 20, color: Colors.black54), textAlign: TextAlign.center),
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
      child: Text('$label $value', style: const TextStyle(fontSize: 18)),
    );
  }
}
