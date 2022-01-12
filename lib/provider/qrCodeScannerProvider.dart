import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCodeScanner extends ChangeNotifier{
  bool qrCodeScanned = false;

  setQrCodeScannedTrue(){
    qrCodeScanned = true;
  }

  setQrCodeScannedFalse(){
    qrCodeScanned = false;
  }
}