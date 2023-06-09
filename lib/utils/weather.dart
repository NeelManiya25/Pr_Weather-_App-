import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wether_app/constants.dart';
import 'package:wether_app/utils/location.dart';


class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({required this.weatherIcon, required this.weatherImage});
}

class WeatherData {
  WeatherData({required this.locationData});

  LocationHelper locationData;
  double currentTemperature;
  int currentCondition;

  Future<void> getCurrentTemperature() async {
    Response response = await get(
        'https://api.weatherapi.com/v1/forecast.json?key=3873391baed64198918132838232205&q=surat lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${"https://api.weatherapi.com/v1/forecast.json?key=3873391baed64198918132838232205&q=surat"}&units=metric');

    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 600) {
      return WeatherDisplayData(
        weatherIcon: kCloudIcon,
        weatherImage: AssetImage('assets/cloud.png'),
      );
    } else {
      var now = new DateTime.now();

      if (now.hour >= 15) {
        return WeatherDisplayData(
          weatherImage: AssetImage('assets/night.png'),
          weatherIcon: kMoonIcon,
        );
      } else {
        return WeatherDisplayData(
          weatherIcon: kSunIcon,
          weatherImage: AssetImage('assets/sunny.png'),
        );
      }
    }
  }
}
