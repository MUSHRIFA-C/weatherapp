import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Data/weather_repository.dart';
import 'package:weatherapp/Domain/weather_usecase.dart';
import 'package:weatherapp/UI/weather_bloc.dart';
import 'package:weatherapp/UI/weather_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => WeatherBlocBloc(apiKey: '21780650cc27d641b00b7aaad548b1d6'),
        child: WeatherPage(),
      ),

    );
  }
}
