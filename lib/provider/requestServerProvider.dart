import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RequestServer extends ChangeNotifier{

  Map beaconMap = {};
  var workerBeaconDto;
  var beaconList;
  var scanfilterList;

   getHttp() async {
    try {
      var response = await Dio().get("http://49.50.172.58:8080/api/getBeaconList");
      return response.data;
    } catch (e) {
      print(e);
    }
  }
   getWorkerBeacon() async {
     try {
       var response = await Dio().get("http://49.50.172.58:8080/api/mobileTest");
       workerBeaconDto = response.data;
       for(var data in response.data){
         beaconMap[data["beaconMac"]] = data["workerId"];
       }
       notifyListeners();
     } catch (e) {
       print(e);
     }
   }

   getScanFilterList() async{
     try {
       var response = await Dio().get("http://49.50.172.58:8080/api/filterList");
       scanfilterList = response.data;
       print(scanfilterList);
       return scanfilterList;
       notifyListeners();
     } catch (e) {
       print(e);
     }
   }

  getBeaconList() async {
    try {
      var response = await Dio().get("http://49.50.172.58:8080/api/getBeaconList");
      beaconList = response.data;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

}