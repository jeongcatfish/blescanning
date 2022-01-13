import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blescanning/provider/bleScanProvider.dart';


class GeolocationService{

  static var geoPosition= Position(longitude: 10, latitude: 20, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);

  static final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  static late bool _serviceEnabled;

  static Future<Position> getCurrentGeoPosition() async {
    if(BleScan.locationPermissionStatus){
      print("hey");
      final position = await _geolocatorPlatform.getCurrentPosition();
      geoPosition = position;
      return position;
    }
    else if(!BleScan.locationPermissionStatus){
      print("There is no location permission : ${BleScan.locationPermissionStatus}");
      return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    }
    return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  }
}