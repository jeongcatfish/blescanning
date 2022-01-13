import 'package:geolocator/geolocator.dart';

class CommonVariable{
  static Position gpsPosition = Position(longitude: 10, latitude: 15, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  static String name = "jeongmin";

  static setName(alias) {
    name = alias;
  }

  static getName(){
    return name;
  }
}