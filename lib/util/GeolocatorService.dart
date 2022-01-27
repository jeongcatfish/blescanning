import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blescanning/provider/bleScanProvider.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';


class GeolocationService extends GetxController{

  void getLocationPermission() async{
    locationPermissionStatus = await Permission.location.request().isGranted;
  }

  var locationPermissionStatus;
  var geoPosition= Position(longitude: 10, latitude: 20, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late bool _serviceEnabled;

  Future<Position> getCurrentGeoPosition() async {
    try{
      final position = await _geolocatorPlatform.getCurrentPosition();
      geoPosition = position;
      print("in GeoLoc : ${geoPosition}");
      return position;
    }
    catch(e){
      return Position(longitude: 9, latitude: 9, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    }
    // if(BleScan.locationPermissionStatus){
    //   final position = await _geolocatorPlatform.getCurrentPosition();
    //   geoPosition = position;
    //   return position;
    // }
    // else if(!BleScan.locationPermissionStatus){
    //   print("There is no location permission : ${BleScan.locationPermissionStatus}");
    //   return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    // }
    // return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  }
}