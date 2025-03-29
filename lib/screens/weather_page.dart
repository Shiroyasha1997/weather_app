import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/weather_details.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, String> _weatherData = {};
  bool _isLoading = false;

  // Obtener clima por ciudad
  Future<void> _getWeatherByCity(String city) async {
    setState(() => _isLoading = true);
    final data = await WeatherService.getWeatherByCity(city);
    setState(() {
      _weatherData = data;
      _isLoading = false;
    });
  }

  // Obtener clima por ubicación
  Future<void> _getWeatherByLocation() async {
    setState(() => _isLoading = true);
    final data = await WeatherService.getWeatherByLocation();
    setState(() {
      _weatherData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Ingresa la ciudad'),
              onSubmitted: _getWeatherByCity,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeatherByLocation,
              child: const Text('Obtener clima en tu ubicación'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : WeatherDetails(data: _weatherData),
          ],
        ),
      ),
    );
  }
}
