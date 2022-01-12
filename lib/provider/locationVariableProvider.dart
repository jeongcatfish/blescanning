import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocationVariable extends ChangeNotifier{
  int sectionIdx = 0;
  int placeIdx =0;
  int phoneIdx = 0;
  var oldSectionIdx;
  var oldPlaceIdx;
  var oldPhoneIdx;

  initData() async{
    var storage = await SharedPreferences.getInstance();
    if(sectionIdx != oldSectionIdx) oldSectionIdx = (await storage.getInt("sectionIdx"))!;
    if(placeIdx != oldPlaceIdx) oldPlaceIdx = (await storage.getInt("placeIdx"))!;
    if(phoneIdx != oldPhoneIdx) oldPhoneIdx = (await storage.getInt("phoneIdx"))!;
    notifyListeners();
  }

  setDataRight() {
    if(sectionIdx != oldSectionIdx) sectionIdx = oldSectionIdx;
    if(placeIdx != oldPlaceIdx) placeIdx = oldPlaceIdx;
    if(phoneIdx != oldPhoneIdx) phoneIdx = oldPhoneIdx;
    notifyListeners();
  }

  setStorageData() async{
    var storage = await SharedPreferences.getInstance();
    storage.setInt("sectionIdx", sectionIdx);
    storage.setInt("placeIdx", placeIdx);
    storage.setInt("phoneIdx", phoneIdx);
    await initData();
  }

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