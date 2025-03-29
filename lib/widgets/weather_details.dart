import 'package:flutter/material.dart';

class WeatherDetails extends StatelessWidget {
  final Map<String, String> data;

  const WeatherDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.containsKey('error')) {
      return Text(data['error']!, style: const TextStyle(color: Colors.red));
    }

    return Column(
      children: [
        if (data['iconUrl']!.isNotEmpty)
          Image.network(data['iconUrl']!, width: 80, height: 80),
        Text(data['temperature']!,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        Text(data['condition']!,
            style: const TextStyle(fontSize: 20, color: Colors.black54)),
        const SizedBox(height: 20),
        _buildDetailRow('🌡️ Sensación térmica:', data['feelsLike']!),
        _buildDetailRow('💨 Velocidad del viento:', data['windSpeed']!),
        _buildDetailRow('💧 Humedad:', data['humidity']!),
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
