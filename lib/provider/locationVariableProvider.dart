import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocationVariable extends ChangeNotifier{
  int sectionIdx = 0;
  int placeIdx =0;
  int phoneIdx = 0;
  var oldSectionIdx = 0;
  var oldPlaceIdx =0;
  var oldPhoneIdx = 0;

  initData() async{
    var storage = await SharedPreferences.getInstance();
    oldSectionIdx = (await storage.getInt("sectionIdx"))!;
    oldPlaceIdx = (await storage.getInt("placeIdx"))!;
    oldPhoneIdx = (await storage.getInt("phoneIdx"))!;
    sectionIdx = oldSectionIdx;
    placeIdx = oldPlaceIdx;
    phoneIdx = oldPhoneIdx;
    print("storage data   storage data    storage data   storage data");
    notifyListeners();
  }

  setDataRight() {
    sectionIdx = oldSectionIdx;
    placeIdx = oldPlaceIdx;
    phoneIdx = oldPhoneIdx;
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