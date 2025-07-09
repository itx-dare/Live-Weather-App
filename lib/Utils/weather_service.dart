import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Model/weather_model.dart';

class WeatherService {
  static const String baseUrl = 'https://wttr.in';

  Future<WeatherModel> getWeather(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$location?format=j1'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        // debugPrint('GetAPI Response :: ${response.body}');
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Weather API error: $e');
      throw Exception('Failed to load weather data: $e');
    }
  }
}