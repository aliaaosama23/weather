import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';

const weatherAPiKey = '34e266285b3e8c0664869079716006fa';

class WeatherService {
  // call api to get weather data
  // 1- depend on location
  // 2- by city name

  Future<WeatherModel> fetchWeatherDataByLocation(Location location) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}'
        '&lon=${location.longitude}'
        '&appid=$weatherAPiKey'
        '&units=metric'));

    if (response.statusCode == 200) {
      String stringReturnedData = response.body;
      print('string returned from call api $stringReturnedData');
      // convert string to json : jsonDecode(stringReturnedData)
      // then convert   to data model by : Weather.fromJson
      return WeatherModel.fromJson(jsonDecode(stringReturnedData));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherModel> fetchWeatherDataByCityName(String cityName) async {
    print(
        'full url   ${'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$weatherAPiKey'
            '&units=metric'}');
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$weatherAPiKey'
        '&units=metric'));

    if (response.statusCode == 200) {
      String stringReturnedData = response.body;
      print('string returned from call api $stringReturnedData');
      // convert string to json : jsonDecode(stringReturnedData)
      // then convert   to data model by : Weather.fromJson
      return WeatherModel.fromJson(jsonDecode(stringReturnedData));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
