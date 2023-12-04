import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/view-model/weather_provider.dart';
import 'package:qhweather/config/router/router_constants.dart';

import '../../models/place_model.dart';

class FavoriteCitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Cities',
          style: themeData.textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildFavoriteCitiesList(context, weatherProvider, themeData),
      ),
    );
  }

  Widget _buildFavoriteCitiesList(
      BuildContext context, WeatherProvider weatherProvider, ThemeData themeData) {
    if (weatherProvider.favoriteCities.isEmpty) {
      return Center(
        child: Text(
          'No favorite cities yet.',
          style: themeData.textTheme.bodyMedium,
        ),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        physics: BouncingScrollPhysics(),
        itemCount: weatherProvider.favoriteCities.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceModel city = weatherProvider.favoriteCities[index];
          return ListTile(
            onTap: () => weatherProvider.changeCurrentPlace(context, city),
            tileColor: themeData.backgroundColor,
            title: Text(
              city.name,
              style: themeData.textTheme.bodyMedium,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: themeData.backgroundColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            // trailing: Container(
            //   width: 25,
            //   height: 25,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(40),
            //     border: Border.all(
            //       color: Colors.grey,
            //       width: 1.5,
            //     ),
            //   ),
            //   child: Center(
            //     child: Icon(
            //       Icons.check_rounded,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
          );
        },
      );
    }
  }
}
