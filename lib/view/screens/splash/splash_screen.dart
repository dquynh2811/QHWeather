import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/config/router/router_constants.dart';
import 'package:qhweather/view-model/weather_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isVisible = false;

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 800))
        .then((value) {
          if (mounted) { // Kiểm tra mounted trước khi thay đổi trạng thái
            setState(() {
              isVisible = true;
            });
          }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, value, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (value.getLoading == false) {
            if (mounted) { // Kiểm tra mounted trước khi thực hiện hành động liên quan đến context
              ScaffoldMessenger.of(context).clearSnackBars();
              Navigator.of(context).pushReplacementNamed(homeRoute);
            }
          } else {
            Future.delayed(const Duration(seconds: 10)).then((_) {
              if (mounted) { // Kiểm tra mounted trước khi thực hiện hành động liên quan đến context
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Connection Lost",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    backgroundColor: Colors.red[400],
                    dismissDirection: DismissDirection.horizontal,
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: "Retry",
                      textColor: Colors.white,
                      disabledTextColor: Colors.amber,
                      onPressed: () {
                        if (mounted) { // Kiểm tra mounted trước khi thực hiện hành động liên quan đến context
                          setState(() => value.setWeather());
                        }
                      },
                    ),
                  ),
                );
                if (mounted) { // Kiểm tra mounted trước khi thay đổi trạng thái
                  setState(() {
                    value.setWeather();
                  });
                }
              }
            });
          }
        });
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 2),
                  child: Icon(
                    CupertinoIcons.cloud,
                    size: 90,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                const SizedBox(height: 150),
                AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 3),
                  child: LoadingAnimationWidget.beat(
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
