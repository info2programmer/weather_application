import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/additinal_info_section.dart';
import 'package:weather_application/constructor_variables.dart';
import 'package:weather_application/hourly_forcust_section.dart';
import 'package:http/http.dart' as http;

class WatherScreen extends StatefulWidget {
  const WatherScreen({super.key});

  @override
  State<WatherScreen> createState() => _WatherScreenState();
}

class _WatherScreenState extends State<WatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String lat = '22.565571';
      String lng = '88.370209';
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lng&exclude=current&appid=$kopenWeatherApiKey"),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != "200") {
        throw "An unextpected error occured";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: GoogleFonts.lato(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemparature = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          // currentTemparature = (temp - 272.15);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "${(currentTemparature - 272.15).toStringAsFixed(0)}° C",
                                style: GoogleFonts.lato(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentSky == "Clouds" || currentSky == "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "$currentSky",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Weather Forcust
                Text(
                  "Hourly Forcust",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 14,
                ),

                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForcust = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp =
                          (hourlyForcust['main']['temp'] - 272.15)
                              .toStringAsFixed(0);
                      final time = DateTime.parse(hourlyForcust['dt_txt']);
                      return EarlyForCustItem(
                        time: DateFormat.j().format(time).toString(),
                        temp: "$hourlyTemp° C",
                        icon: hourlySky == "Clouds" || hourlySky == "Rain"
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Additional Information",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditinalInfo(
                      icon: Icons.water_drop,
                      lable: "Humidity",
                      lableValue: "$currentHumidity",
                    ),
                    AdditinalInfo(
                      icon: Icons.air_sharp,
                      lable: "Wind Speed",
                      lableValue: "$currentWindSpeed",
                    ),
                    AdditinalInfo(
                      icon: Icons.beach_access,
                      lable: "Pressure",
                      lableValue: "$currentPressure",
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
