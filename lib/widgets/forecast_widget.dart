import 'package:flutter/material.dart';
import 'package:weather_app/Model/weather_model.dart';

class ForecastWidget extends StatelessWidget {
  final DailyForecast item;
  final String date;

  const ForecastWidget({super.key, required this.item, required this.date});

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    final parsedDate = DateTime.parse(date);
    final dayName = _getDayName(parsedDate.weekday);
    final formattedDate = '${parsedDate.day} ${_getMonthName(parsedDate.month)}';

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: myHeight * 0.015,
        horizontal: myWidth * 0.04,
      ),
      child: Container(
        height: myHeight * 0.11,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  item.maxTempC,
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
                Text(
                  '°C',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(width: 10),
                Text(
                  '/ ${item.minTempC}°C',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Image.asset(
              _getWeatherIcon(item.hourly[4].weatherDesc),
              height: myHeight * 0.05,
              width: myWidth * 0.1,
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }

  String _getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'sunny':
        return 'assets/weather/sunny.png';
      case 'clear':
        return 'assets/weather/clear.png';
      case 'haze':
        return 'assets/weather/haze.png';
      case 'partly cloudy':
        return 'assets/weather/partly_cloudy.png';
      case 'cloudy':
        return 'assets/weather/cloudy.png';
      case 'overcast':
        return 'assets/weather/overcast.png';
      case 'mist':
        return 'assets/weather/mist.png';
      case 'fog':
        return 'assets/weather/fog.png';
      case 'light rain':
        return 'assets/weather/light_rain.png';
      case 'heavy rain':
        return 'assets/weather/heavy_rain.png';
      case 'thunderstorm':
        return 'assets/weather/thunderstorm.png';
      default:
        return 'assets/weather/sunny.png';
    }
  }
}