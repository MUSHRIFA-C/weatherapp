import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/Data/weather_repository.dart';
import 'package:weatherapp/Domain/weather.dart';

class WeatherUseCase {
  final WeatherRepository repository;

  WeatherUseCase({required this.repository});

  Future<Weathers> getWeather(double lat, double lon, String apiKey) async {
    final weatherData = await repository.getWeather(lat, lon, apiKey);
    return Weathers.fromJson(weatherData);
  }
}