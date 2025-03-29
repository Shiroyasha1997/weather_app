import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/weather_service.dart'; // Asegúrate de que WeatherService esté importado correctamente

// Creamos un mock de la clase HTTP para simular respuestas
class MockClient extends Mock implements http.Client {}

void main() {
  group('WeatherService', () {
    test('Obtención de datos del clima', () async {
      // Creamos un cliente mock
      final client = MockClient();

      // Simulamos una respuesta de la API con datos ficticios de clima
      when(client.get(Uri.parse('https://api.weatherapi.com/v1/current.json?key=API_KEY&q=London')))
          .thenAnswer((_) async => http.Response(
          json.encode({
            "location": {"name": "London"},
            "current": {
              "temp_c": 20,
              "humidity": 80,
              "wind_kph": 10,
              "condition": {"text": "Clear"}
            }
          }),
          200
      ));

      // Usamos el cliente mock para llamar al servicio
      final weatherService = WeatherService(client);
      final weatherData = await weatherService.getWeather('London');

      // Verificamos que la respuesta sea la esperada
      expect(weatherData['temperature'], 20);
      expect(weatherData['condition'], 'Clear');
    });
  });
}
