import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';
import 'location_service.dart';

class WeatherService {
  static const String _apiKey = '2c578e426a2c4e4bb3f234043252603';

  static Future<Map<String, String>> getWeatherByCity(String city) async {
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$city&aqi=no&lang=es');
    return _fetchWeather(url);
  }

  static Future<Map<String, String>> getWeatherByLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position == null) return {'error': 'No se pudo obtener la ubicación.'};

    final url = Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=${position.latitude},${position.longitude}&aqi=no&lang=es');
    return _fetchWeather(url);
  }

  static Future<Map<String, String>> _fetchWeather(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data).toMap();
      } else {
        return {'error': 'Error en la API: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'No se pudo conectar a la API. Verifica tu conexión.'};
    }
  }

}
