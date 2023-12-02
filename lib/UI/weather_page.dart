import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:weatherapp/Data/weather_repository.dart';
import 'package:weatherapp/Domain/weather.dart';
import 'package:weatherapp/Domain/weather_usecase.dart';
import 'package:weatherapp/UI/weather_bloc.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherBloc _weatherBloc = WeatherBloc(
    weatherUseCase: WeatherUseCase(
      repository: WeatherRepository(apiKey: '21780650cc27d641b00b7aaad548b1d6'),
    ),
  );

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      _weatherBloc.add(FetchWeather());

      await _weatherBloc.stream.firstWhere(
            (state) => state is WeatherLoaded || state is WeatherError,
      );

      if (_weatherBloc.state is WeatherError) {
        // Handle error state
      }
    } catch (e) {
      // Handle exception
    }
  }

  Widget getWeatherIcon(int code, double width) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageRoute.background),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WeatherLoaded) {
              final List<Weather> weatherForecast = state.weatherUseCase;
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.orange.shade300
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Today', style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                  ),),
                                  IconButton(
                                      onPressed: () {

                                      },
                                      icon: Icon(
                                          Icons.keyboard_arrow_down, size: 28,
                                          color: Colors.white)
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  getWeatherIcon(weatherForecast[0].weatherConditionCode!, MediaQuery.of(context).size.width * 0.22),
                                  Gap(15),
                                  Text('${weatherForecast[0].temperature!.celsius!.round()}°', style: TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),),
                                ],
                              ),
                              Text('${weatherForecast[0].weatherMain!}', style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white
                              ),),
                              Text('${weatherForecast[0].areaName}, ${weatherForecast[0].country}', style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),),
                              Text('${DateFormat('dd MMM yyyy').format(weatherForecast[0].date!)}', style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),),
                              Text('Feels like ${weatherForecast[0].tempFeelsLike!.celsius!.round()} | '
                                  'Sunset ${DateFormat().add_Hm().format(weatherForecast[0].date!)}', style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),)
                            ],
                          ),
                        ),
                      ),
                      Gap(22),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.orange.shade300
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                              ),
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('${DateFormat().add_j().format(weatherForecast[index].date!)}', style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white
                                    ),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        getWeatherIcon(weatherForecast[index].weatherConditionCode!, MediaQuery.of(context).size.width * 0.05),
                                        Gap(3),
                                        Text('${weatherForecast[index].temperature!.celsius!.round()}°', style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),),
                                      ],
                                    ),
                                  ],
                                );
                              },
                              itemCount: 10,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Random Text', style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white
                              ),),
                              Text(
                                'Improve him believe opinion offered met and end cheered forbade. Friendly as stronger speedily by recurred. Son interest wandered sir addition end say. Manners beloved affixed picture men ask.',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                ),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (state is WeatherBlocFailure) {
              return Center(
                child: Text('Failed to fetch weather data.'),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
