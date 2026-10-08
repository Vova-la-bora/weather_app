import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_page.dart';

void main() {
  runApp(const bestApp());
}

class bestApp extends StatelessWidget {
  const bestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}
