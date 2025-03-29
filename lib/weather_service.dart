import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final http.Client client;

  WeatherService(this.client);

  Future<Map<String, dynamic>> getWeather(String city) async {
    final apiKey = '2c578e426a2c4e4bb3f234043252603';
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no&lang=es',
    );

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'temperature': data['current']['temp_c'],
          'condition': data['current']['condition']['text'],
        };
      } else {
        throw Exception('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Fallo al obtener los datos del clima. Error: $e');
    }
  }
}
