import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/Domain/weather.dart';
import 'package:weatherapp/Domain/weather_usecase.dart';

// Events
abstract class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {}

// States
abstract class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded({required this.weather});

  @override
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String error;

  WeatherError({required this.error});

  @override
  List<Object?> get props => [error];
}


// BLoC
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherUseCase weatherUseCase;

  WeatherBloc({required this.weatherUseCase}) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      const double latitude = 37.7749;
      const double longitude = -122.4194;
      const String apiKey = '21780650cc27d641b00b7aaad548b1d6';

      // Perform the logic to fetch weather data here
      try {
        final weather = await weatherUseCase.getWeather(
            latitude, longitude, apiKey);
        yield WeatherLoaded(weather: weather);
      } catch (e) {
        yield WeatherError(error: e.toString());
      }
    }
  }
}