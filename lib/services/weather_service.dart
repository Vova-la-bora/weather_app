import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';
import 'package:flutter/widgets.dart' show Locale;

import 'dart:convert';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String nameOfCity) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$nameOfCity&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // разрешение
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // текущая локация
    Position pose = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    // список локаций
    List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
      pose.latitude,
      pose.longitude,
      locale: const Locale('en', 'US'),
    );

    // имя города

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
