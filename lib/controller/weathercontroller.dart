import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';


const OPENAPIKEY="b44f185d92cc88bb2804d43909eab003";

class WeatherController extends GetxController {
  // Weather service instance
  WeatherFactory weatherFactory = WeatherFactory(OPENAPIKEY); // Replace with your API key

  // Reactive variables
  var cityName = ''.obs;
  var temperature = ''.obs;
  var weatherCondition = ''.obs;
  var isLoading = false.obs;
  var opacity = 1.0.obs;
  var _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> fetchWeather(String city) async {
    try {
      isLoading.value = true;
      opacity.value = 0.0;  // Set opacity to 0 to hide info before fetching data
      print("Fetching weather for $city...");  // Debug print
      Weather weather = await weatherFactory.currentWeatherByCityName(city);
      cityName.value = weather.areaName ?? 'City not found';
      temperature.value = weather.temperature?.celsius?.toStringAsFixed(1) ?? '';
      weatherCondition.value = weather.weatherDescription ?? '';
      print("Data fetched: ${cityName.value}, ${temperature.value}, ${weatherCondition.value}");  // Debug print

      // Delay for a smooth transition
      await Future.delayed(Duration(milliseconds: 500));
      opacity.value = 1.0;  // Fade-in weather information
    } catch (e) {
      print("Error fetching weather: $e");  // Debug error
      cityName.value = 'City not found';
      temperature.value = '';
      weatherCondition.value = '';
    } finally {
      isLoading.value = false;
    }
  }
}

