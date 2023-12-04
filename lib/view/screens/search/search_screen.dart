import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/config/colors.dart';
import 'package:qhweather/models/place_model.dart';
import 'package:qhweather/utils/align_constants.dart';
import 'package:qhweather/view-model/weather_provider.dart';

import '../../../models/place_model.dart';
import '../../../service/places_service.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            left: elementAlignment.left, right: elementAlignment.left, top: 10),
        child: Consumer<WeatherProvider>(
          builder: (context, weatherNotifier, child) => Column(
            children: [
              TextField(
                onChanged: (value) async {
                  final places = await searchPlaces('YOUR_API_KEY', value);
                  // print(places);
                  weatherNotifier.setSearchedListCountries(places);
                },
                style: themeData.textTheme.headlineSmall,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: themeData.backgroundColor,
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: themeData.backgroundColor,
                      width: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: themeData.backgroundColor,
                      width: 0,
                    ),
                  ),
                  focusColor: themeData.backgroundColor,
                  fillColor: themeData.backgroundColor,
                  filled: true,
                  prefixIconColor: utilsColors.lightSelectedIconColor,
                  hintText: "Search Your place",
                  hintStyle: themeData.textTheme.headlineSmall,
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: themeData.iconTheme.color,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  physics: const BouncingScrollPhysics(),
                  itemCount: weatherNotifier.searchedListCountries.length,
                  itemBuilder: (BuildContext context, int index) {
                    PlaceModel place = weatherNotifier.searchedListCountries[index];
                    bool isLatLong = weatherNotifier.checkLatLong(place.lat, place.long);

                    return ListTile(
                      onTap: () => weatherNotifier.changeCurrentPlace(context, place),
                      tileColor: isLatLong ? Colors.green[300] : themeData.backgroundColor,
                      minVerticalPadding: 10,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              fontSize: 16, // Adjust the font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            place.display_name,
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              fontSize: 12, // Adjust the font size as needed
                              color: Colors.grey[700],
                            ),
                          ),

                        ],
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
                      //   child: isLatLong
                      //       ? const Center(
                      //     child: Icon(
                      //       Icons.check_rounded,
                      //       color: Colors.black,
                      //     ),
                      //   )
                      //       : null,
                      // ),
                    );
                  },
                )

                // child: ListView.separated(
                //   separatorBuilder: (context, index) =>
                //   const SizedBox(height: 10),
                //   physics: const BouncingScrollPhysics(),
                //   itemCount: weatherNotifier.searchedListCountries.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     PlaceModel place =
                //     weatherNotifier.searchedListCountries[index];
                //     bool isLatLong =
                //     weatherNotifier.checkLatLong(place.lat, place.long);
                //
                //     return ListTile(
                //       onTap: () => weatherNotifier.changeCurrentPlace(
                //           context, place),
                //       tileColor: isLatLong
                //           ? Colors.green[300]
                //           : themeData.backgroundColor,
                //       minVerticalPadding: 10,
                //       title: Text(
                //         place.display_name,
                //         style: themeData.textTheme.headlineSmall,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         side: BorderSide(
                //           color: themeData.backgroundColor,
                //           width: 1,
                //         ),
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       trailing: Container(
                //         width: 25,
                //         height: 25,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(40),
                //           border: Border.all(
                //             color: Colors.grey,
                //             width: 1.5,
                //           ),
                //         ),
                //         child: isLatLong
                //             ? const Center(
                //           child: Icon(
                //             Icons.check_rounded,
                //             color: Colors.black,
                //           ),
                //         )
                //             : null,
                //       ),
                //     );
                //   },
                // ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
