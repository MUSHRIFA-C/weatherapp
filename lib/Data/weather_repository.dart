import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherRepository {
  final String apiKey;

  WeatherRepository({required this.apiKey});

  Future<Map<String, dynamic>> getWeather(double lat, double lon, String apiKey) async {
    final response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey' as Uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

