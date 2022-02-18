import 'package:flutter/material.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/utilities/constants.dart';

// get user current location then display weather
class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  //late Future<WeatherModel> weatherData;
  bool dataReturned = false;
  String cityName = '';
  num temp = 0.0;
  String description = '';
  num tempMin = 0.0;
  num tempMax = 0.0;
  String icon = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeatherDataByLocation(); // async operation take some times
  }

  updateUi(WeatherModel weatherData) {
    print(weatherData.name);
    setState(() {
      cityName = weatherData.name!;
      temp = weatherData.main!.temp!;
      tempMin = weatherData.main!.tempMin!;
      tempMax = weatherData.main!.tempMax!;
      description = weatherData.weather![0].description!;
      icon = weatherData.weather![0].icon!;
    });
  }

  getWeatherDataByLocation() async {
    dataReturned = false;
    // get location : async operation take some times
    LocationService location = LocationService();
    Location currentLocation = await location.getCurrentLocation();

    // get weather data : async operation take some times
    WeatherService weather = WeatherService();
    var weatherData = await weather.fetchWeatherDataByLocation(currentLocation);
    updateUi(weatherData);
    dataReturned = true;
  }

  getWeatherDataByCityName(String cityName) async {
    // get weather data : async operation take some times
    WeatherService weather = WeatherService();
    var weatherData = await weather.fetchWeatherDataByCityName(cityName);
    updateUi(weatherData);
    dataReturned = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/location_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: dataReturned
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              dataReturned = false;
                              // find the current location again
                              getWeatherDataByLocation();
                            },
                            icon: const Icon(
                              Icons.near_me,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              // find the weather for typed city
                              final typedCity = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CityScreen(),
                                ),
                              );
                              print('typedCity is $typedCity');
                              // get weather by city name
                              getWeatherDataByCityName(typedCity);
                            },
                            icon: const Icon(
                              Icons.location_city,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const Spacer(
                        flex: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            temp.toStringAsFixed(1),
                            style: kTempTextStyle,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            '\u2070',
                            style: kUnitTextStyle,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (icon != '')
                            Image.network(
                              'http://openweathermap.org/img/wn/$icon@2x.png',
                              width: 100,
                              height: 100,
                            )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Temp Min  :',
                            style: kTempKeyTextStyle,
                          ),
                          Text(
                            tempMin.toStringAsFixed(1),
                            style: kTempValueTextStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Temp Max  :',
                            style: kTempKeyTextStyle,
                          ),
                          Text(
                            tempMax.toStringAsFixed(1),
                            style: kTempValueTextStyle,
                          )
                        ],
                      ),
                      const Spacer(
                        flex: 4,
                      ),
                      Text(
                        'It has $description now in $cityName',
                        style: kDescriptionTextStyle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            : const SpinKitCircle(
                color: Colors.white,
                size: 70.0,
              ),
      ),
    );
  }
}
