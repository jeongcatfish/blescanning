import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BleScan extends ChangeNotifier{
  List<BleDevice> deviceList = [];
  // Some state management stuff
  bool scanStarted = false;
  // Bluetooth related variables
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  // These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse("75C276C3-8F97-20BC-A143-B354244886D4");

  setScanStarted(){
    scanStarted = !scanStarted;
    notifyListeners();
  }
  clearDeviceList(){
    deviceList.clear();
    notifyListeners();
  }

  void startScan() async {
    bool permGranted = false;
    // request Permission
    var status = await Permission.location.request().isGranted;
    if(status){
      permGranted = true;
    }
    else if(!status){
      print("PERMISSION DENIED");
    }
    // Main scanning logic happens here ⤵️
    if (permGranted) {
      _scanStream = flutterReactiveBle
          .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
            scanList(device);
      });
    }
  }

  scanList(device){
    var findMacAddress = deviceList.any((el){
      if(el.macAddress == device.id.toString()){
        el.rssi = device.rssi;
        return true;
      }
      else{
        return false;
      }
    });
    if(!findMacAddress){
      var name = "";
      if(device.name == "") name = "Unkouwn";
      else name = device.name;
      deviceList.add(BleDevice(device.id.toString(), name, device.rssi));
    }
    notifyListeners();
  }
}



class BleDevice{
  String macAddress = "";
  String name = "";
  int rssi =0;
  BleDevice(this.macAddress,this.name,this.rssi);
}
