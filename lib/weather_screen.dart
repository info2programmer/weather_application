import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  double temp = 0;
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
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
      setState(() {
        temp = data['list'][0]['main']['temp'];
        temp = (temp - 272.15);
      });
    } catch (e) {
      throw e.toString();
    }
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
              debugPrint("Hello");
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
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
                            "${temp.toStringAsFixed(0)}° C",
                            style: GoogleFonts.lato(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Rain",
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
              "Weather Forcust",
              style:
                  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 14,
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  EarlyForCustItem(
                    time: "3.00",
                    temp: "320",
                    icon: Icons.cloud,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Additional Information",
              style:
                  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditinalInfo(
                  icon: Icons.water_drop,
                  lable: "Humidity",
                  lableValue: "90",
                ),
                AdditinalInfo(
                  icon: Icons.air_sharp,
                  lable: "Wind Speed",
                  lableValue: "7.32",
                ),
                AdditinalInfo(
                  icon: Icons.beach_access,
                  lable: "Pressure",
                  lableValue: "7.32",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
