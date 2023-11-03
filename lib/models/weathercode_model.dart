import 'package:flutter/cupertino.dart';

class WeatherCodeModel {
  num weatherCode;
  String name;
  IconData iconData;
  WeatherCodeModel(
      {required this.weatherCode, required this.name, required this.iconData});
}
