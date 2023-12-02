class Weathers {
  final String cityName;
  final double temperature;

  Weathers({required this.cityName, required this.temperature});

  factory Weathers.fromJson(Map<String, dynamic> json) {
    return Weathers(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
    );
  }
}
