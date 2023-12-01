// favorite_cities_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/view-model/weather_provider.dart';
import 'package:qhweather/config/router/router_constants.dart'; 

class FavoriteCitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Cities',
          style: Theme.of(context).textTheme.headlineSmall,  // Sử dụng màu chữ từ theme
        ),
      ),
      body: _buildFavoriteCitiesList(context, weatherProvider),
    );
  }

  Widget _buildFavoriteCitiesList(
      BuildContext context, WeatherProvider weatherProvider) {
    if (weatherProvider.favoriteCities.isEmpty) {
      return Center(
        child: Text(
          'No favorite cities yet.',
          style: Theme.of(context).textTheme.bodyMedium,  // Sử dụng màu chữ từ theme
        ),
      );
    } else {
      return ListView.builder(
        itemCount: weatherProvider.favoriteCities.length,
        itemBuilder: (context, index) {
          String city = weatherProvider.favoriteCities[index];
          return ListTile(
            title: Text(
              city,
              style: Theme.of(context).textTheme.bodyMedium,  // Sử dụng màu chữ từ theme
            ),
            onTap: () {
              // Navigate to the weather details screen for the selected city
              Navigator.pushNamed(context, weatherDetailsRoute, arguments: {
                'city': city,
              });
            },
          );
        },
      );
    }
  }
}
