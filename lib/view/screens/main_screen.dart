// main_screen.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/config/router/router.dart';
import 'package:qhweather/config/router/router_constants.dart';  // Import router constants
import 'package:qhweather/view-model/theme_provider.dart'; // Import ThemeProvider

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedScreenIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;

      // Add logic to navigate to the FavoriteCitiesScreen
      // if (_selectedScreenIndex == 2) {
      //   Navigator.of(context).pushNamed(favoriteCitiesRoute);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the BottomNavigationBar with Consumer to listen to changes in ThemeProvider
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: AppRouter().screens[_selectedScreenIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedScreenIndex,
            onTap: _selectScreen,
            items: const [
              BottomNavigationBarItem(icon: Icon(Iconsax.home), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.search_favorite),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.setting),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }
}
