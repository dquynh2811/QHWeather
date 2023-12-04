import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/view-model/theme_provider.dart';
import 'package:qhweather/view-model/weather_provider.dart';
import 'package:qhweather/config/router/router_constants.dart';

import '../../../utils/align_constants.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeNotifier, child) => IconButton(
              icon: themeNotifier.isDark
                  ? const Icon(CupertinoIcons.sun_min_fill)
                  : const Icon(CupertinoIcons.moon_stars_fill),
              onPressed: () => themeNotifier.switchTheme(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: elementAlignment.left, right: elementAlignment.left, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40, // Set the height to 40
              child: TextButton(
                onPressed: () {
                  // Navigate to the screen for managing favorite cities
                  Navigator.pushNamed(context, favoriteCitiesRoute);
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: themeData.backgroundColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: themeData.backgroundColor,
                ),
                child: Text(
                  "Favorite cities",
                  style: themeData.textTheme.bodyMedium,
                  // style: TextStyle(
                  //
                  //   fontSize: 16,
                  //   color: themeData.backgroundColor,
                  //   fontWeight: FontWeight.normal,
                  // ),
                ),
              ),
            ),
            // Add any other widgets or components below if needed
          ],
        ),
      ),
    );
  }
}
