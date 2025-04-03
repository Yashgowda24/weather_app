import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/screens/location_screen.dart';
import 'package:weather_app/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Step 1: Check if Location Services are Enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDisabledDialog();
      return;
    }

    // Step 2: Check & Request Location Permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        _showPermissionDeniedDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      _showPermissionDeniedDialog();
      return;
    }

    // Step 3: Fetch Weather Data
    try {
      var weatherData = await WeatherModel().getLocationWeather();
      if (weatherData != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LocationScreen(locationWeather: weatherData),
          ),
        );
      } else {
        print("Failed to get weather data.");
        exit(0);
      }
    } catch (e) {
      print("Error: $e");
      _showWeatherErrorDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Required"),
        content: Text(
            "This app requires location access to fetch weather data. Please enable location permissions in settings."),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: Text("Exit"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings(); // Opens settings for manual permission
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  void _showLocationDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enable Location Services"),
        content: Text(
            "Location services are disabled. Please enable GPS to proceed."),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: Text("Exit"),
          ),
        ],
      ),
    );
  }

  void _showWeatherErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("Failed to fetch weather data. Please try again later."),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: Text("Exit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.lightGreen,
          size: 100.0,
        ),
      ),
    );
  }
}
