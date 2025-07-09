class WeatherModel {
  final CurrentCondition currentCondition;
  final List<DailyForecast> dailyForecasts;
  final String location;

  WeatherModel({
    required this.currentCondition,
    required this.dailyForecasts,
    required this.location,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      currentCondition: CurrentCondition.fromJson(json['current_condition'][0]),
      dailyForecasts: (json['weather'] as List)
          .map((forecast) => DailyForecast.fromJson(forecast))
          .toList(),
      location: json['nearest_area'][0]['areaName'][0]['value'],
    );
  }
}

class CurrentCondition {
  final String tempC;
  final String tempF;
  final String feelsLikeC;
  final String feelsLikeF;
  final String humidity;
  final String weatherDesc;
  final String windSpeedKmph;
  final String windDir;
  final String pressure;
  final String visibility;
  final String uvIndex;
  final String localObsDateTime;

  CurrentCondition({
    required this.tempC,
    required this.tempF,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.humidity,
    required this.weatherDesc,
    required this.windSpeedKmph,
    required this.windDir,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.localObsDateTime,
  });

  factory CurrentCondition.fromJson(Map<String, dynamic> json) {
    return CurrentCondition(
      tempC: json['temp_C'],
      tempF: json['temp_F'],
      feelsLikeC: json['FeelsLikeC'],
      feelsLikeF: json['FeelsLikeF'],
      humidity: json['humidity'],
      weatherDesc: json['weatherDesc'][0]['value'],
      windSpeedKmph: json['windspeedKmph'],
      windDir: json['winddir16Point'],
      pressure: json['pressure'],
      visibility: json['visibility'],
      uvIndex: json['uvIndex'],
      localObsDateTime: json['localObsDateTime'],
    );
  }
}

class DailyForecast {
  final String date;
  final String maxTempC;
  final String minTempC;
  final String maxTempF;
  final String minTempF;
  final String avgTempC;
  final String avgTempF;
  final List<HourlyForecast> hourly;

  DailyForecast({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.maxTempF,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.hourly,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'],
      maxTempC: json['maxtempC'],
      minTempC: json['mintempC'],
      maxTempF: json['maxtempF'],
      minTempF: json['mintempF'],
      avgTempC: json['avgtempC'],
      avgTempF: json['avgtempF'],
      hourly: (json['hourly'] as List)
          .map((hour) => HourlyForecast.fromJson(hour))
          .toList(),
    );
  }
}

class HourlyForecast {
  final String time;
  final String tempC;
  final String tempF;
  final String weatherDesc;
  final String windSpeedKmph;
  final String windDir;
  final String humidity;
  final String feelsLikeC;
  final String feelsLikeF;

  HourlyForecast({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.weatherDesc,
    required this.windSpeedKmph,
    required this.windDir,
    required this.humidity,
    required this.feelsLikeC,
    required this.feelsLikeF,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'],
      tempC: json['tempC'],
      tempF: json['tempF'],
      weatherDesc: json['weatherDesc'][0]['value'],
      windSpeedKmph: json['windspeedKmph'],
      windDir: json['winddir16Point'],
      humidity: json['humidity'],
      feelsLikeC: json['FeelsLikeC'],
      feelsLikeF: json['FeelsLikeF'],
    );
  }
}