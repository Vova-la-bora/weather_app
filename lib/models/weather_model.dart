class Weather {
  final String nameOfCity;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.nameOfCity,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      nameOfCity: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
