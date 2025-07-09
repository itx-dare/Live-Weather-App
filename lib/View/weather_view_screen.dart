import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:weather_app/Model/weather_model.dart';
import 'package:weather_app/Utils/weather_service.dart';
import 'package:weather_app/widgets/forecast_widget.dart';
import 'package:weather_app/widgets/format_hourly_time.dart';
import 'package:weather_app/widgets/get_weather_icon.dart';

class WeatherViewScreen extends StatefulWidget {
  final WeatherModel? weatherModel;
  final String? city;

  const WeatherViewScreen({super.key, this.weatherModel, this.city});

  @override
  State<WeatherViewScreen> createState() => _WeatherViewScreenState();
}

class _WeatherViewScreenState extends State<WeatherViewScreen> {
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _currentWeather;
  int hourIndex = 0;
  bool _isLoading = false;
  bool _showAirQuality = false;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    if (widget.weatherModel != null) {
      _currentWeather = widget.weatherModel;
    } else if (widget.city != null) {
      setState(() => _isLoading = true);
      try {
        _currentWeather = await _weatherService.getWeather(widget.city!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load weather data: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xff060720),
        body: Center(
          child: SizedBox(
            height: myHeight * 0.4,
            child: Lottie.asset(
              'assets/animation/cloud_loading.json',
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
        ),
      );
    }

    if (_currentWeather == null) {
      return const Scaffold(
        backgroundColor: Color(0xff060720),
        body: Center(
          child: Text(
            'No weather data available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final current = _currentWeather!.currentCondition;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff060720),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, _currentWeather),
        ),
      ),
      backgroundColor: const Color(0xff060720),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: myHeight * 0.03),
            Text(
              _currentWeather!.location,
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
                  // Forecast Tab
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
                  // Air Quality Tab
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

            // Weather Image or Air Quality View
            _showAirQuality
                ? _buildAirQualityView()
                : Image.asset(
              getWeatherIcon(current.weatherDesc),
              height: myHeight * 0.3,
              width: myWidth * 0.8,
              fit: BoxFit.contain,
            ),
            SizedBox(height: myHeight * 0.05),

            // Weather Stats
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

            // Today's Forecast Header
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
                ],
              ),
            ),
            SizedBox(height: myHeight * 0.02),

            // Hourly Forecast
            SizedBox(
              height: myHeight * 0.15,
              child: _buildForecastView(myHeight, myWidth),
            ),
            SizedBox(height: myHeight * 0.02),

            // Next Forecast Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Next Forecast',
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

            // Daily Forecast List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentWeather!.dailyForecasts.length - 1, // Skip today
              itemBuilder: (context, index) {
                final dailyForecast = _currentWeather!.dailyForecasts[index + 1];
                return ForecastWidget(
                  item: dailyForecast,
                  date: dailyForecast.date,
                );
              },
            ),
            SizedBox(height: myHeight * 0.05), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildAirQualityView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.air, size: 100, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            'Air Quality Index: ${_currentWeather?.currentCondition.uvIndex ?? 'N/A'}',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Pressure: ${_currentWeather?.currentCondition.pressure} hPa',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Visibility: ${_currentWeather?.currentCondition.visibility} km',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastView(double myHeight, double myWidth) {
    final today = _currentWeather!.dailyForecasts.first;

    return Padding(
      padding: EdgeInsets.only(
        left: myWidth * 0.03,
        bottom: myHeight * 0.02,
      ),
      child: ScrollablePositionedList.builder(
        itemPositionsListener: itemPositionsListener,
        shrinkWrap: true,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
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