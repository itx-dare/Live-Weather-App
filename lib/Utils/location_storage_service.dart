import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/Utils/saved_location.dart';

class LocationStorageService {
  static const String _key = 'saved_locations';

  Future<List<SavedLocation>> getSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => SavedLocation.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading saved locations: $e');
      return [];
    }
  }

  Future<void> saveLocation(SavedLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    final List<SavedLocation> existing = await getSavedLocations();

    if (existing.any((loc) => loc.city == location.city)) return;

    existing.add(location);
    await prefs.setString(_key, json.encode(existing.map((e) => e.toJson()).toList()));
  }

  Future<void> deleteLocation(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final List<SavedLocation> existing = await getSavedLocations();
    existing.removeWhere((loc) => loc.city == city);
    await prefs.setString(_key, json.encode(existing.map((e) => e.toJson()).toList()));
  }
}