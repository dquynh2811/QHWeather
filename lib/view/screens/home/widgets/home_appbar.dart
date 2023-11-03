import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qhweather/config/colors.dart';
import 'package:qhweather/models/weather_model.dart';
import 'package:qhweather/models/weathercode_model.dart';
import 'package:qhweather/utils/align_constants.dart';
import 'package:qhweather/view-model/weather_provider.dart';
import 'package:qhweather/view/screens/widget/weather_status.dart';

class HomeAppbarRowWidget extends StatelessWidget {
  const HomeAppbarRowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);
    WeatherModel weatherModel = weatherProvider.getLoadedWeather;

    return Row(
      children: [
        Padding(
          padding: elementAlignment,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [              
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
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                "Air Quality Index: ${weatherModel.airQualityIndex ?? 'N/A'}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Container(
          // width: 90,  // Tăng chiều rộng
          // height: 90,  // Tăng chiều cao
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),  // Bỏ góc vuông
            boxShadow: [  // Thêm bóng đổ cho biểu tượng
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
            fit: BoxFit.cover,  // Đảm bảo biểu tượng luôn vừa vặn với không gian đã định
          ),
        )
      ],
    );
  }
}
