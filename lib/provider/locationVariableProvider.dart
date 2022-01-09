import 'package:flutter/material.dart';

class LocationVariable extends ChangeNotifier{
  int phoneIdx = 0;
  int placeIdx =0;
  int sectionIdx = 0;


  plus1PhoneIdx(){
    phoneIdx++;
    notifyListeners();
  }

  minus1PhoneIdx(){
    phoneIdx--;
    notifyListeners();
  }
  plus1PlaceIdx(){
    placeIdx++;
    notifyListeners();
  }

  minus1PlaceIdx(){
    placeIdx--;
    notifyListeners();
  }
  plus1SectionIdx(){
    sectionIdx++;
    notifyListeners();
  }

  minus1SectionIdx(){
    sectionIdx--;
    notifyListeners();
  }
}