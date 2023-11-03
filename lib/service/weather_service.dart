import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qhweather/models/weather_model.dart';

class WeatherService {
  static Future<WeatherModel> getWeather(num lat, num long) async {
    final apiKey = '3caa956ea38981ef704576231f49607b'; // Thay thế bằng khóa API của bạn

    final urlWeatherDetails = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey',
    );

    final weatherDetailsResponse = await http.get(urlWeatherDetails);

    if (weatherDetailsResponse.statusCode != 200) {
      throw Exception('Lỗi khi lấy dữ liệu từ OpenWeatherMap');
    }

    final weatherDetailsData = jsonDecode(weatherDetailsResponse.body);
    final cityName = weatherDetailsData['name'];
    final weatherDescription = weatherDetailsData['weather'][0]['description'];
    final temperature = (weatherDetailsData['main']['temp'] - 273.15).round(); // Chuyển đổi từ Kelvin sang Celsius
    final feelsLike = (weatherDetailsData['main']['feels_like'] - 273.15).round();
    final weatherIcon = weatherDetailsData['weather'][0]['icon'];

    // Thêm một URL mới để lấy dữ liệu chỉ số chất lượng không khí
    var urlAirQuality = Uri.parse(
      'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$long&appid=$apiKey',
    );

    final airQualityResponse = await http.get(urlAirQuality);

    if (airQualityResponse.statusCode != 200) {
      throw Exception('Lỗi khi lấy chỉ số chất lượng không khí từ OpenWeatherMap');
    }

    final airQualityData = jsonDecode(airQualityResponse.body);
    final airQualityIndex = airQualityData['list'][0]['main']['aqi'];

    var urlMeteo = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&hourly=temperature_2m,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,rain_sum,windspeed_10m_max&timezone=auto",
    );
    var meteoResponse = await http.get(urlMeteo);

    if (meteoResponse.statusCode != 200) {
      throw Exception('Lỗi khi lấy dữ liệu thời tiết từ Open Meteo');
    }

    final meteoData = WeatherModel.fromJson(jsonDecode(meteoResponse.body));
    meteoData.cityName = cityName;
    meteoData.weatherDescription = weatherDescription;
    meteoData.temperature = temperature;
    meteoData.feelsLike = feelsLike;
    meteoData.weatherIcon = weatherIcon;
    meteoData.airQualityIndex = airQualityIndex; // Thêm chỉ số chất lượng không khí

    return meteoData;
  }
}
