import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/config/router/router.dart';
import 'package:qhweather/config/router/router_constants.dart';
import 'package:qhweather/config/themes.dart';
import 'package:qhweather/view-model/theme_provider.dart';
import 'package:qhweather/view-model/weather_provider.dart';

import 'home-widget/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<WeatherProvider>(create: (_) => WeatherProvider()),
        ListenableProvider<ThemeProvider>(create: (_) => ThemeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'qhweather',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.themMode,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: splashRoute,
          home: MyHomePage()
        );
      },
    );
  }
}
