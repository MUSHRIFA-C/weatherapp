import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/Domain/weather.dart';
import 'package:weatherapp/Domain/weather_usecase.dart';

// Events
sealed class WeatherBlocEvent extends Equatable{
  const WeatherBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherBlocEvent{

}

// States
sealed class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object> get props => [];
}

final class WeatherBlocInitial extends WeatherBlocState {}

final class WeatherBlocLoading extends WeatherBlocState {}
final class WeatherBlocFailure extends WeatherBlocState {}

final class WeatherBlocSuccess extends WeatherBlocState {
  final List<Weather> weatherForecast;

  WeatherBlocSuccess(this.weatherForecast);

  @override
  List<Object> get props => [weatherForecast];

}
// BLoC
class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  final String apiKey;
  WeatherBlocBloc({required this.apiKey}) : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory(apiKey, language: Language.ENGLISH);

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          forceAndroidLocationManager: true,
        );

        List<Weather> weatherForecast = await wf.fiveDayForecastByLocation(
          position.latitude,
          position.longitude,
        );
        //print('---------weather forecast: $weatherForecast');
        emit(WeatherBlocSuccess(weatherForecast));
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }
}