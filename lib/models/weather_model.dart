class WeatherModel {
  final String city;
  final String temperature;
  final String condition;
  final String windSpeed;
  final String feelsLike;
  final String humidity;
  final String iconUrl;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    required this.feelsLike,
    required this.humidity,
    required this.iconUrl,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: '${json['location']['name']}, ${json['location']['country']}',
      temperature: '${json['current']['temp_c']}°C',
      condition: json['current']['condition']['text'],
      windSpeed: '${json['current']['wind_kph']} km/h',
      feelsLike: '${json['current']['feelslike_c']}°C',
      humidity: '${json['current']['humidity']}%',
      iconUrl: 'https:${json['current']['condition']['icon']}',
    );
  }

  Map<String, String> toMap() {
    return {
      'city': city,
      'temperature': temperature,
      'condition': condition,
      'windSpeed': windSpeed,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'iconUrl': iconUrl,
    };
  }
}
