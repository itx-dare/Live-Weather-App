import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Model/weather_model.dart';
import 'package:weather_app/View/bottomNavigationBar.dart';
import 'package:weather_app/Utils/weather_service.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? weatherData;
  String? errorMessage;
  bool _isCheckingPermissions = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
  }

  Future<void> _checkLocationPermissions() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _showLocationServiceDisabledDialog();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await _handlePermissionDenied();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await _showPermissionDeniedForeverDialog();
        return;
      }

      await _determinePositionAndLoadWeather();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        _isCheckingPermissions = false;
      });
      _loadDefaultWeather();
    }
  }

  Future<void> _showLocationServiceDisabledDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
            'Please enable location services to get weather for your current location.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Use Default Location'),
              onPressed: () {
                Get.close(1);
                _loadDefaultWeather();
              },
            ),
            TextButton(
              child: const Text('Enable'),
              onPressed: () async {
                Get.close(1);
                await Geolocator.openLocationSettings();
                await _checkLocationPermissions();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPermissionDeniedForeverDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permissions Denied'),
          content: const Text(
            'Location permissions are permanently denied. Please enable them in app settings.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Use Default Location'),
              onPressed: () {
                Get.close(1);
                _loadDefaultWeather();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () async {
                Get.close(1);
                await Geolocator.openAppSettings();
                await _checkLocationPermissions();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handlePermissionDenied() async {
    setState(() {
      errorMessage =
          'Using default location (London) since location access was denied.';
      _isCheckingPermissions = false;
    });
    _loadDefaultWeather();
  }

  Future<void> _determinePositionAndLoadWeather() async {
    try {
      setState(() {
        _isCheckingPermissions = false;
      });

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String location = placeMarks.first.locality ?? 'Unknown location';

      weatherData = await _weatherService.getWeather(location);

      _navigateToHome();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      _loadDefaultWeather();
    }
  }

  Future<void> _loadDefaultWeather() async {
    try {
      weatherData = await _weatherService.getWeather('London');
      _navigateToHome();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load weather data: $e';
      });
    }
  }

  void _navigateToHome() {
    if (weatherData != null) {
      Timer(
        const Duration(seconds: 2),
        () => Get.off(() => NavBar(weatherModel: [weatherData!])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff060720),
        body: SizedBox(
          height: myHeight,
          width: myWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: myHeight * 0.4,
                child: Lottie.asset(
                  'assets/animation/cloud_loading.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Weather',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_isCheckingPermissions ||
                  (weatherData == null && errorMessage == null))
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
