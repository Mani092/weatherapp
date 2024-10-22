import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/weathercontroller.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: WeatherController().themeMode,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  final WeatherController weatherController = Get.put(WeatherController());
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App with GetX'),
        actions: [
          // Theme toggle button
          Obx(() => Switch(
            value: weatherController.isDarkMode,
            onChanged: (value) {
              weatherController.toggleTheme();
            },
          )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                weatherController.fetchWeather(cityController.text);
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 40),

            // Reactive widget with loading and weather info fade-in animation
            Obx(() {
              if (weatherController.isLoading.value) {
                return CircularProgressIndicator();  // Show loading indicator when fetching data
              } else if (weatherController.cityName.isNotEmpty) {
                return AnimatedOpacity(
                  opacity: weatherController.opacity.value,  // Control opacity for fade-in effect
                  duration: Duration(seconds: 1),  // Set fade-in duration
                  child: Column(
                    children: [
                      Text(
                        '${weatherController.cityName.value}',
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.1),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${weatherController.temperature.value} °C',
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${weatherController.weatherCondition.value}',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                );
              } else {
                return Text('Enter a city to get the weather');
              }
            }),
          ],
        ),
      ),
    );
  }}