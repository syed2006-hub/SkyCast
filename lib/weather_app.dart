import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app2/info_tile.dart';
import 'package:weather_icons/weather_icons.dart';
import 'card_forecast_item.dart';
import 'custom_circular_progress_indicator.dart';
import 'additional_item.dart';
import 'key.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late Future<Map<String, dynamic>> weather;

  String selectedDistrict = 'Chennai';
  String selectedCity = 'Chennai';
  List<String> tamilnaduDistricts = [];

  final Map<String, String> districtToCity = {
    'Chennai': 'Chennai',
    'Coimbatore': 'Coimbatore',
    'Madurai': 'Madurai',
    'Tiruchirappalli': 'Tiruchirappalli',
    'Salem': 'Salem',
    'Erode': 'Erode',
    'Vellore': 'Vellore',
    'Tirunelveli': 'Tirunelveli',
    'Thoothukudi': 'Thoothukudi',
    'Dindigul': 'Dindigul',
    'Thanjavur': 'Thanjavur',
    'Cuddalore': 'Cuddalore',
    'Karur': 'Karur',
    'Nagapattinam': 'Nagapattinam',
    'Kanchipuram': 'Kanchipuram',
    'Ramanathapuram': 'Madurai',
    'Ariyalur': 'Tiruchirappalli',
    'Perambalur': 'Tiruchirappalli',
    'Tiruppur': 'Coimbatore',
    'Namakkal': 'Salem',
    'Sivaganga': 'Madurai',
    'Nilgiris': 'Udhagamandalam',
    'Virudhunagar': 'Madurai',
    'Dharmapuri': 'Salem',
    'Krishnagiri': 'Vellore',
    'Tiruvarur': 'Thanjavur',
    'Villupuram': 'Cuddalore',
    'Tenkasi': 'Tirunelveli',
  };

  @override
  void initState() {
    super.initState();
    fetchTamilNaduDistricts()
        .then((districts) {
          setState(() {
            tamilnaduDistricts = districts;
            selectedDistrict = 'Chennai';
            selectedCity = districtToCity[selectedDistrict]!;
            weather = currentWeather();
          });
        })
        .catchError((_) {
          setState(() {
            tamilnaduDistricts = ['Chennai'];
            selectedDistrict = 'Chennai';
            selectedCity = 'Chennai';
            weather = currentWeather();
          });
        });
  }

  Future<List<String>> fetchTamilNaduDistricts() async {
    return districtToCity.keys.toList();
  }

  Future<Map<String, dynamic>> currentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$selectedCity,IN&appid=$apiKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') throw 'Failed to fetch weather';
      return data;
    } catch (_) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> _refresh() async {
    setState(() {
      weather = currentWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sky Cast',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (tamilnaduDistricts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDistrict,
                  onChanged: (newDistrict) {
                    setState(() {
                      selectedDistrict = newDistrict!;
                      selectedCity = districtToCity[selectedDistrict]!;
                      weather = currentWeather();
                    });
                  },
                  items:
                      tamilnaduDistricts.map((district) {
                        return DropdownMenuItem(
                          value: district,
                          child: Text(
                            district,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey[900],
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CloudProgressIndicator());
          }

          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Something went wrong.\nPlease check your connection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ),
              ],
            );
          }

          final data = snapshot.data!;
          final current = data['list'][0];
          final temp = current['main']['temp'];
          final sky = current['weather'][0]['main'];
          final desc = current['weather'][0]['description'];
          final feelsLike = current['main']['feels_like'];
          final minTemp = current['main']['temp_min'];
          final maxTemp = current['main']['temp_max'];
          final clouds = current['clouds']['all'];
          final sunrise = DateTime.fromMillisecondsSinceEpoch(
            data['city']['sunrise'] * 1000,
          );
          final sunset = DateTime.fromMillisecondsSinceEpoch(
            data['city']['sunset'] * 1000,
          );
          final locationName = data['city']['name'];
          final country = data['city']['country'];

          return RefreshIndicator(
            onRefresh: _refresh,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                children: [
                                  Text(
                                    '$temp K',
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                  const SizedBox(height: 10),
                                  Icon(
                                    sky == 'Clear' && desc == 'clear sky'
                                        ? WeatherIcons.day_sunny
                                        : sky == 'Clouds'
                                        ? WeatherIcons.cloud
                                        : WeatherIcons.rain,
                                    size: 60,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    sky,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 135,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          final hourly = data['list'][index + 1];
                          final time = DateTime.parse(hourly['dt_txt']);
                          final temp = hourly['main']['temp'];
                          final sky = hourly['weather'][0]['main'];
                          return CardItemForecast(
                            time: DateFormat.j().format(time),
                            temparature: temp.toString(),
                            icon:
                                sky == 'Clear'
                                    ? WeatherIcons.day_sunny
                                    : sky == 'Clouds'
                                    ? WeatherIcons.cloud
                                    : WeatherIcons.rain,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$locationName, $country',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InfoTile(
                                  icon: WeatherIcons.thermometer,
                                  label: 'Feels Like',
                                  value: '${feelsLike.toStringAsFixed(1)} K',
                                ),
                                InfoTile(
                                  icon: WeatherIcons.direction_up,
                                  label: 'Max Temp',
                                  value: '${maxTemp.toStringAsFixed(1)} K',
                                ),
                                InfoTile(
                                  icon: WeatherIcons.direction_down,
                                  label: 'Min Temp',
                                  value: '${minTemp.toStringAsFixed(1)} K',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InfoTile(
                                  icon: WeatherIcons.sunrise,
                                  label: 'Sunrise',
                                  value: DateFormat.jm().format(sunrise),
                                ),
                                InfoTile(
                                  icon: WeatherIcons.sunset,
                                  label: 'Sunset',
                                  value: DateFormat.jm().format(sunset),
                                ),
                                InfoTile(
                                  icon: WeatherIcons.cloudy,
                                  label: 'Clouds',
                                  value: '$clouds%',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
