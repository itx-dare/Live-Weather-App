import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:weather_app/Model/weather_model.dart';
import 'package:weather_app/widgets/forecast_widget.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/format_hourly_time.dart';
import 'package:weather_app/widgets/get_weather_icon.dart';

class HomeScreen extends StatefulWidget {
  final WeatherModel weatherModel;

  const HomeScreen({super.key, required this.weatherModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int hourIndex = 0;
  bool _showAirQuality = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    final weather = widget.weatherModel;
    final current = weather.currentCondition;
    final today = weather.dailyForecasts.first;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff060720),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: myHeight * 0.03),
              Text(
                weather.location,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: myHeight * 0.01),
              Text(
                current.localObsDateTime,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(height: myHeight * 0.05),
              Container(
                height: myHeight * 0.05,
                width: myWidth * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () => setState(() => _showAirQuality = false),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: _showAirQuality
                                ? null
                                : const LinearGradient(colors: [
                              Color.fromARGB(255, 21, 85, 169),
                              Color.fromARGB(255, 44, 162, 246),
                            ]),
                          ),
                          child: Center(
                            child: Text(
                              'Forecast',
                              style: TextStyle(
                                color: _showAirQuality ? Colors.white54 : Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () => setState(() => _showAirQuality = true),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: _showAirQuality
                                ? const LinearGradient(colors: [
                              Color.fromARGB(255, 21, 85, 169),
                              Color.fromARGB(255, 44, 162, 246),
                            ])
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Air quality',
                              style: TextStyle(
                                color: _showAirQuality ? Colors.white : Colors.white54,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.05),
              _showAirQuality
                  ? _buildAirQualityView(weather)
                  : Image.asset(
                getWeatherIcon(current.weatherDesc),
                height: myHeight * 0.3,
                width: myWidth * 0.8,
                fit: BoxFit.contain,
              ),
              SizedBox(height: myHeight * 0.05),
              SizedBox(
                height: myHeight * 0.09,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            'Temp',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${current.tempC}°C',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            'Wind',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${current.windSpeedKmph} km/h',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            'Humidity',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${current.humidity}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(
                        DateFormat('yyyy-MM-dd hh:mm a').parse(weather.currentCondition.localObsDateTime),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.02),
              SizedBox(
                height: myHeight * 0.15,
                child: Padding(
                  padding: EdgeInsets.only(left: myWidth * 0.03),
                  child: ScrollablePositionedList.builder(
                    itemPositionsListener: itemPositionsListener,
                    scrollDirection: Axis.horizontal,
                    itemCount: today.hourly.length,
                    itemBuilder: (context, index) {
                      final hour = today.hourly[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.02,
                          vertical: myHeight * 0.01,
                        ),
                        child: Container(
                          width: myWidth * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 44, 162, 246),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatHourlyTime(hour.time),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${hour.tempC}°C',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: myHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Next forecast',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      'assets/icons/forcast.png',
                      height: myHeight * 0.03,
                      color: Colors.white.withValues(alpha: 0.5),
                    )
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.02),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.weatherModel.dailyForecasts.length - 1,
                itemBuilder: (context, index) {
                  final dailyForecast = widget.weatherModel.dailyForecasts[index + 1];
                  return ForecastWidget(
                    item: dailyForecast,
                    date: dailyForecast.date,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAirQualityView(WeatherModel weather) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.air, size: 100, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            'Air Quality Index: ${weather.currentCondition.uvIndex}',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Pressure: ${weather.currentCondition.pressure} hPa',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Visibility: ${weather.currentCondition.visibility} km',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}