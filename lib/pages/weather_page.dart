import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('3e8e08a447e86fef38f3db33aeec0a66');
  Weather? _weather;
  final _controller = TextEditingController();

  _fetchWeather() async {
    try {
      String nameOfCity = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(nameOfCity);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _searchCity() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    FocusScope.of(context).unfocus(); // закрыть клавиатуру
    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Город "$city" не найден')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'weathpict/Weather-sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'weathpict/Weather-windy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'weathpict/rainy icon.json';
      case 'thunderstorm':
        return 'weathpict/Weather-storm.json';
      case 'clear':
        return 'weathpict/Weather-sunny.json';
      default:
        return 'weathpict/Weather-sunny.json';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 201, 201),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchCity(),
                decoration: InputDecoration(
                  hintText: 'Введите город (например, Moscow)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchCity,
                  ),
                ),
              ),
            ),
            Text(_weather?.nameOfCity ?? "loading City.."),

            Lottie.asset(
              getWeatherAnimation(_weather?.mainCondition),
              width: 200,
              height: 200,
            ),

            Text('${_weather?.temperature.round()}C'),

            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}
