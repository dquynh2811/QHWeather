import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qhweather/config/router/router_constants.dart';
import 'package:qhweather/models/country_model.dart';
import 'package:qhweather/models/weather_model.dart';
import 'package:qhweather/models/weathercode_model.dart';
import 'package:qhweather/service/weather_service.dart'; // Ensure this import is correct
import 'package:qhweather/utils/recentSearchPlaces.dart';
import 'package:qhweather/service/weather_service.dart';  // Ensure this import is correct
import 'package:qhweather/utils/country_constants.dart';
import 'package:qhweather/utils/weathercode_constants.dart';
import 'package:qhweather/view/screens/widget/snackbar.dart';

import '../models/place_model.dart';

class WeatherProvider extends ChangeNotifier {
  bool _isLoading = true;
  var _todayWeather = [];
  num _currentLat = 0.0; // Default latitude
  num _currentLong = 0.0; // Default longitude
  WeatherModel? _weatherFromApi;
  final List _hourlyWeather = [];
  final DateTime nowTime = DateTime.now();
  final Map<DateTime, List> _dailyWeather = {};
  final List _threeDaysWeather = [];
  List<PlaceModel> _searchedListCountries = recentSearchPlaces;
  // List<CountryModel> _searchedListCountries = countriesConstants;
  List<PlaceModel> _favoriteCities = [];

  WeatherProvider() {
    getLocationFromGPS();
  }

  get getLoading => _isLoading;

  get futureDayWeather => _threeDaysWeather;

  get hourlyWeather => _hourlyWeather;
  set setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  get searchedListCountries => _searchedListCountries;
  // void setSearchedListCountries(places) {}
  void setSearchedListCountries(List<dynamic> places) {
    _searchedListCountries.clear();
    for (var place in places) {
      String name = place['name'].toString();
      String display_name = place['display_name'].toString();
      num lat = num.parse(place['lat']);
      num lon = num.parse(place['lon']);
      _searchedListCountries.add(PlaceModel(name, display_name, lat, lon));
    }
    // print(_searchedListCountries);
    notifyListeners(); // Gọi notifyListeners để thông báo sự thay đổi trong dữ liệu
  }

  get getLoadedWeather => _weatherFromApi;

  get todayWeather => _todayWeather;

  setWeather() async {
    if (_currentLat != 0.0 && _currentLong != 0.0) {
      _weatherFromApi = await WeatherService.getWeather(_currentLat, _currentLong);
      fetchDayAndData(_weatherFromApi!);
      setLoading = false;
    } else {
      // Handle the case where the latitude and longitude are not available.
      setLoading = false;
    }
    notifyListeners();
  }

  get favoriteCities => _favoriteCities;

  void addToFavorites(PlaceModel city) {
    if (!_favoriteCities.contains(city)) {
      _favoriteCities.add(city);
      notifyListeners();
    }
  }

  void removeFromFavorites(PlaceModel city) {
    _favoriteCities.remove(city);
    notifyListeners();
  }

  // bool isFavorite(String cityName) {
  //   return _favoriteCities.contains(cityName);
  // }
  bool isFavorite(String cityName) {
    return _favoriteCities.any((city) => city.name == cityName);
  }


  void fetchDayAndData(WeatherModel loadedWeather) {
    int dayIndex = 0;
    int hourIndex = 0;

    Daily dailyInstance = loadedWeather.daily;
    Hourly hourlyInstance = loadedWeather.hourly;

    _dailyWeather.clear();
    _hourlyWeather.clear();
    _threeDaysWeather.clear();

    DateTime currentHour = nowTime;
    DateTime lastHour = nowTime.add(Duration(hours: 24));

    for (var hour in hourlyInstance.time) {
      DateTime parsedHour = DateTime.parse(hour);
      if (parsedHour.isAfter(currentHour) && parsedHour.isBefore(lastHour)) {
        _hourlyWeather.add([
          parsedHour,
          hourlyInstance.temperature2M[hourIndex],
          hourlyInstance.weathercode[hourIndex]
        ]);
      }
      hourIndex += 1;
    }

    for (var day in dailyInstance.time) {
      _dailyWeather[day] = [
        dailyInstance.weathercode[dayIndex],
        dailyInstance.temperature2MMax[dayIndex],
        dailyInstance.temperature2MMin[dayIndex],
        dailyInstance.windspeed10MMax[dayIndex],
      ];
      if (day.isAfter(nowTime)) {
        _threeDaysWeather.add([
          day,
          dailyInstance.weathercode[dayIndex],
          dailyInstance.temperature2MMax[dayIndex],
          dailyInstance.temperature2MMin[dayIndex],
          dailyInstance.windspeed10MMax[dayIndex],
        ]);
      }
      if (day.day == nowTime.day) {
        _todayWeather = _dailyWeather[day] as List;
      }

      dayIndex += 1;
    }
  }

  getLocationFromGPS() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
        SystemNavigator.pop();
        return Future.error('Location permissions are denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentLat = position.latitude;
    _currentLong = position.longitude;

    setWeather();
  }

  // void searchCountry(String name) {
  //   _searchedListCountries = countriesConstants.where((element) {
  //     final countryName = element.name.toLowerCase();
  //     final searchInput = name.toLowerCase();
  //     return countryName.contains(searchInput);
  //   }).toList();
  //
  //   notifyListeners();
  // }

  WeatherCodeModel getWeatherCode(num code) {
    for (var item in weatherCodeConstant) {
      if (item.weatherCode == code) {
        return item;
      }
    }
    return weatherCodeConstant[0];
  }

  void changeCurrentPlace(BuildContext context, PlaceModel place) async {
    _currentLat = place.lat;
    _currentLong = place.long;
    setLoading = true;
    // addRecentSearchPlaces(place);
    searchedListCountries.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(snackBarWidget(context, place.name));
    Navigator.of(context).pushReplacementNamed(splashRoute);
    await setWeather();
  }

  bool checkLatLong(num lat, num long) {
    if (doubleParse(lat) == doubleParse(_currentLat) &&
        doubleParse(long) == doubleParse(_currentLong)) {
      return true;
    }
    return false;
  }

  double doubleParse(num doubleToParse) =>
      double.parse(doubleToParse.toStringAsFixed(0));
}
