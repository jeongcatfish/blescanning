import 'dart:async';
import 'dart:io' show Platform;
import 'package:blescanning/pages/BeaconListPage.dart';
import 'package:blescanning/pages/BleScanPage.dart';
import 'package:blescanning/pages/NfcPage.dart';
import 'package:blescanning/pages/QrCodeScanner.dart';
import 'package:blescanning/provider/qrCodeScannerProvider.dart';
import 'package:blescanning/static/commonVariable.dart';
import 'package:blescanning/util/ForeGroundService.dart';
import 'package:blescanning/util/GeolocatorService.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'package:blescanning/provider/bleScanProvider.dart';
import 'package:blescanning/provider/locationVariableProvider.dart';
import 'package:blescanning/provider/requestServerProvider.dart';

void main() {

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => RequestServer()),
        ChangeNotifierProvider(create: (c) => QrCodeScanner()),
      ],
        child: GetMaterialApp(home: HomePage())),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var foreGroundTaskController = Get.put(ForeGroundService());
  int _selectedIndex = 0;
  var bleScanTimeOut = 60 * 25;
  var bleScanTime = 0;

  final LocationVariable loactionVariableController = Get.put(LocationVariable());

  @override
  void initState() {
    super.initState();
    // initForeGroundService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FLUTTER BLE SCANNER"),backgroundColor: Colors.green,
      ),

      backgroundColor: Colors.white,
      body: Text("body"),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Ble'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (c)=>BleScanPage()));
              },
            ),
            ListTile(
              title: const Text('QR Code'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (c)=>QrCodePage()));
              },
            ),
            ListTile(
              title: const Text('NFC'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (c)=>NfcPage()));
              },
            ),
            ListTile(
              title: const Text('Beacon List'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (c)=>BeaconListPage()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // context.read<BleScan>().clearDeviceList();
          },
        child: Icon(Icons.replay_outlined),
      ),
    );
  }

}

class HomeView extends StatelessWidget {
  const HomeView({Key? key, this.bleScanTime}) : super(key: key);

  final bleScanTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Text("TOTAL COUNT : ${context.watch<BleScan>().deviceList.length.toString()}",
                style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Text("${bleScanTime.toString()}   ${60 * 25}")
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: BleListView(),
          ),
        )
      ],
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  final double buttonPadding = 15;
  final Color buttonColor = Colors.green;
  final double modalTitleFontSize = 20;
  final double modalDescFontSize = 15;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<LocationVariable>().minus1SectionIdx();
                    CommonVariable.name = "setting";
                    print("setting : ${CommonVariable.name}");
                  },
                  child: Icon(Icons.exposure_minus_1, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(buttonPadding),
                    primary: buttonColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:
                      Text(context.watch<LocationVariable>().sectionIdx.toString(),
                        style: TextStyle(fontSize: 50),)
                ),
                ElevatedButton(
                  onPressed: () {context.read<LocationVariable>().plus1SectionIdx();},
                  child: Icon(Icons.plus_one, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(buttonPadding),
                    primary: buttonColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ],
            ),
            Text("section_idx"),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {context.read<LocationVariable>().minus1PlaceIdx();},
                  child: Icon(Icons.exposure_minus_1, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(buttonPadding),
                    primary: buttonColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:
                    Text(context.watch<LocationVariable>().placeIdx.toString(),
                      style: TextStyle(fontSize: 50),)
                ),
                ElevatedButton(
                  onPressed: () {context.read<LocationVariable>().plus1PlaceIdx();},
                  child: Icon(Icons.plus_one, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(buttonPadding),
                    primary: buttonColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ],
            ),
            Text("palce_idx"),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {context.read<LocationVariable>().minus1PhoneIdx();},
                  child: Icon(Icons.exposure_minus_1, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(buttonPadding),
                    primary: buttonColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:
                    Text(context.watch<LocationVariable>().phoneIdx.toString(),
                      style: TextStyle(fontSize: 50),)
                ),
                ElevatedButton(
                  onPressed: () {context.read<LocationVariable>().plus1PhoneIdx();},
                  child: Icon(Icons.plus_one, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(buttonPadding),
                    primary: buttonColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ],
            ),
            Text("phone_idx"),
          ],
        ),
        Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: SizedBox(child:
              Center(child:
                Text("apply", style: TextStyle(fontSize: 20),)),height: 50, width: 70,),
            onPressed: (){
              showDialog(
                context: context,
                builder: (context){
                  return Dialog(
                    child: Container(
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 50,
                              child: Text("변경사항",style: TextStyle(fontSize: modalTitleFontSize,fontWeight: FontWeight.bold),)),
                          Text("placeIdx ${context.watch<LocationVariable>().oldSectionIdx} -> ${context.watch<LocationVariable>().sectionIdx}",style: TextStyle(fontSize: modalDescFontSize)),
                          Text("placeIdx ${context.watch<LocationVariable>().oldPlaceIdx} -> ${context.watch<LocationVariable>().placeIdx}",style: TextStyle(fontSize: modalDescFontSize)),
                          Text("placeIdx ${context.watch<LocationVariable>().oldPhoneIdx} -> ${context.watch<LocationVariable>().phoneIdx}",style: TextStyle(fontSize: modalDescFontSize)),
                          Container(
                            child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.red),onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text("취소")),margin: EdgeInsets.all(10),),
                                Container(child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.green),onPressed: (){
                                  context.read<LocationVariable>().setStorageData();
                                  Navigator.pop(context);
                                }, child: Text("확인")),margin: EdgeInsets.all(10),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class BleListView extends StatelessWidget {
  const BleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<BleScan>().deviceList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          child: ListTile(
            //디바이스 이름과 맥주소 그리고 신호 세기를 표시한다.
            leading: CircleAvatar(child: Icon(Icons.bluetooth),),
            title: Text("[${(index+1)}] ${context.watch<BleScan>().deviceList[index].name} - ${context.watch<BleScan>().deviceList[index].macAddress}"),
            subtitle: Text("${context.watch<BleScan>().deviceList[index].manufacturerData}",style: TextStyle(fontSize: 13),),
            trailing: Text("${context.watch<BleScan>().deviceList[index].rssi}"),
          ),
        );
      },
    );
  }
}


