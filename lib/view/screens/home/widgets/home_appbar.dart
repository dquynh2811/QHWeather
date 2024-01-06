// home_appbar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/config/colors.dart';
import 'package:qhweather/models/place_model.dart';
import 'package:qhweather/models/weather_model.dart';
import 'package:qhweather/utils/align_constants.dart';
import 'package:qhweather/view-model/theme_provider.dart';
import 'package:qhweather/view-model/weather_provider.dart';

class HomeAppbarRowWidget extends StatelessWidget {
  const HomeAppbarRowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);
    WeatherModel weatherModel = weatherProvider.getLoadedWeather;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        Padding(
          padding: elementAlignment,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                IconButton(

                  icon: Icon(

                    weatherProvider.isFavorite(weatherModel.cityName ?? "")
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () {
                    String cityName = weatherModel.cityName;
                    num? lat = weatherModel.latitude;
                    num? lon = weatherModel.longitude;
                    PlaceModel? city = PlaceModel(cityName, "", lat, lon);
                    if (cityName != null) {
                      if (weatherProvider.isFavorite(cityName)) {
                        weatherProvider.removeFromFavorites(city);
                      } else {
                        weatherProvider.addToFavorites(city);
                      }
                    }
                  },
                ),
              Text(
                weatherModel.cityName ?? "Unknown City",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "${weatherModel.temperature?.toString() ?? 'N/A'}°",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Feels like ${weatherModel.feelsLike?.toString() ?? 'N/A'}°, ${weatherModel.weatherDescription ?? 'Unknown weather'}.",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 15.0),
              ),
              Text(
                "Air Quality Index: ${weatherModel.airQualityIndex ?? 'N/A'}",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 15.0),
              )
              ,
            ],
          ),
        ),
        const SizedBox(width: 30),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Image.network(
            "https://openweathermap.org/img/w/${weatherModel.weatherIcon ?? 'unknown'}.png",
            fit: BoxFit.cover,
          ),
        ),
        
      ],
    );
  }
}
