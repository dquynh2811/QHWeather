import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import '../service/weather_service.dart';
import '../models/weather_model.dart';
import 'geolocator.dart';

const String appGroupId = 'com.example.qhweather';
const String androidWidgetName = 'NewsWidget';

void updateWeatherData(WeatherModel weatherInfo) {
  HomeWidget.saveWidgetData<String>('city_name', weatherInfo.cityName);
  HomeWidget.saveWidgetData<String>('temperature', '${weatherInfo.temperature}°C');
  HomeWidget.saveWidgetData<String>('feels_like', 'Feels like: ${weatherInfo.feelsLike}°C');
  HomeWidget.saveWidgetData<String>('weather_icon_path', "https://openweathermap.org/img/w/${weatherInfo.weatherIcon}.png");
  HomeWidget.saveWidgetData<String>('air_quality', 'Air Quality Index: ${weatherInfo.airQualityIndex}');

  HomeWidget.updateWidget(
    androidName: androidWidgetName,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);

    // Initial update
    _updateWeatherData();

    // Set up a 15-minute periodic timer
    _timer = Timer.periodic(Duration(minutes: 15), (Timer timer) {
      _updateWeatherData();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future<void> _updateWeatherData() async {
    try {
      // Mock weather data
      final pos = await getLocationFromGPS();
      final weatherModel = await WeatherService.getWeather(pos['latitude']!, pos['longitude']!);

      updateWeatherData(weatherModel);
    } catch (error) {
      // Handle errors here
      print('Error updating weather data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App Title'),
      ),
      body: Center(
        child: AndroidView(
          viewType: 'MySurfaceView',
        ),
      ),
    );
  }
}
main() async {
  final pos = await getLocationFromGPS();
  final weatherModel = await WeatherService.getWeather(pos['latitude']!, pos['longitude']!);
  String s = 'Feels like: ${weatherModel.feelsLike}°C';
  print(s);
}