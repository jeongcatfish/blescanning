import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocationVariable extends GetxController{
  int sectionIdx = 0;
  int placeIdx =0;
  int phoneIdx = 0;
  var oldSectionIdx = 0;
  var oldPlaceIdx = 0;
  var oldPhoneIdx = 0;

  initData() async{
    var storage = await SharedPreferences.getInstance();
    if(sectionIdx != oldSectionIdx) oldSectionIdx = (await storage.getInt("sectionIdx"))!;
    if(placeIdx != oldPlaceIdx) oldPlaceIdx = (await storage.getInt("placeIdx"))!;
    if(phoneIdx != oldPhoneIdx) oldPhoneIdx = (await storage.getInt("phoneIdx"))!;
    update();
  }

  setDataRight() {
    if(sectionIdx != oldSectionIdx) sectionIdx = oldSectionIdx;
    if(placeIdx != oldPlaceIdx) placeIdx = oldPlaceIdx;
    if(phoneIdx != oldPhoneIdx) phoneIdx = oldPhoneIdx;
    update();
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
    update();
  }

  minus1PhoneIdx(){
    phoneIdx--;
    update();
  }
  plus1PlaceIdx(){
    placeIdx++;
    update();
  }

  minus1PlaceIdx(){
    placeIdx--;
    update();
  }
  plus1SectionIdx(){
    sectionIdx++;
    update();
  }

  minus1SectionIdx(){
    sectionIdx--;
    update();
  }
}