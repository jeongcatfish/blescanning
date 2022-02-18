import 'dart:async';

import 'package:blescanning/provider/bleScanProvider.dart';
import 'package:blescanning/provider/locationVariableProvider.dart';
import 'package:blescanning/static/commonVariable.dart';
import 'package:blescanning/util/ForeGroundService.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:provider/src/provider.dart';


class BleScanPage extends StatefulWidget {
  const BleScanPage({Key? key}) : super(key: key);

  @override
  _BleScanPageState createState() => _BleScanPageState();
}

class _BleScanPageState extends State<BleScanPage> {
  var bleScanController = Get.put(BleScan());
  var foreGroundTaskController = Get.put(ForeGroundService());
  int _selectedIndex = 0;
  var bleScanTimeOut = 60 * 25;
  var bleScanTime = 0;


  turnOnAndOffBle(){
    Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        bleScanTime +=1;
      });
      if(bleScanTime >= bleScanTimeOut){
        bleScanTime = 0;
        bleScanController.clearDeviceList();
        Future.delayed(const Duration(milliseconds: 1000),(){
          // context.read<BleScan>().scanStream.resume();
          var scanFilterList = [];
          bleScanController.startScan(scanFilterList);
        });
      }
      // Get.put(GeolocationService().getCurrentGeoPosition());
    });
  }

  getServerDataAndStartBleScan() async{
    // var scanFilterList = await getServerData();
    var dummy = [];
    bleScanController.startScan(dummy);
  }

  initForeGroundService() async{
    await foreGroundTaskController.initForegroundTask();
    foreGroundTaskController.startForegroundTask();
  }

  void _onItemTapped(int index) {
    setState(() {
      if(index == 1){
        Get.find<LocationVariable>().setDataRight();
      }
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();

    Get.find<LocationVariable>().initData();
    turnOnAndOffBle();
    getServerDataAndStartBleScan();
    // initForeGroundService();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FLUTTER BLE SCANNER"),backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: (){
            // context.read<ForeGroundService>().stopForegroundTask();
            foreGroundTaskController.stopForegroundTask();
          }, icon: Icon(Icons.stop)),
          IconButton(onPressed: (){
            initForeGroundService();
          }, icon: Icon(Icons.play_arrow)),
          IconButton(onPressed: (){
            print(bleScanController.scanStream.isPaused.toString());
            bleScanController.setIsScanPaused(bleScanController.scanStream.isPaused);
          }, icon: Icon(Icons.info))
        ],),

      backgroundColor: Colors.white,
      body: [HomeView(bleScanTime : bleScanTime),SettingView()][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
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
              Text("TOTAL COUNT : ${Get.find<BleScan>().deviceList.length.toString()}",
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

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final double buttonPadding = 15;

  final Color buttonColor = Colors.green;

  final double modalTitleFontSize = 20;

  final double modalDescFontSize = 15;

  final LocationVariable loactionVariableController = Get.put(LocationVariable());

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
                    loactionVariableController.minus1SectionIdx();
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
                    Text("hi")
                    // Text(context.watch<LocationVariable>().sectionIdx.toString(),
                    //   style: TextStyle(fontSize: 50),)
                ),
                ElevatedButton(
                  onPressed: () {loactionVariableController.plus1SectionIdx();},
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
                  onPressed: () {loactionVariableController.minus1PlaceIdx();},
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
                    Text(loactionVariableController.placeIdx.toString(),
                      style: TextStyle(fontSize: 50),)
                ),
                ElevatedButton(
                  onPressed: () {loactionVariableController.plus1PlaceIdx();},
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
                  onPressed: () {loactionVariableController.minus1PhoneIdx();},
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
                    Text(loactionVariableController.phoneIdx.toString(),
                      style: TextStyle(fontSize: 50),)
                ),
                ElevatedButton(
                  onPressed: () {loactionVariableController.plus1PhoneIdx();},
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
                          Text("placeIdx ${loactionVariableController.oldSectionIdx} -> ${loactionVariableController.sectionIdx}",style: TextStyle(fontSize: modalDescFontSize)),
                          Text("placeIdx ${loactionVariableController.oldPlaceIdx} -> ${loactionVariableController.placeIdx}",style: TextStyle(fontSize: modalDescFontSize)),
                          Text("placeIdx ${loactionVariableController.oldPhoneIdx} -> ${loactionVariableController.phoneIdx}",style: TextStyle(fontSize: modalDescFontSize)),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.red),onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text("취소")),margin: EdgeInsets.all(10),),
                                Container(child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.green),onPressed: (){
                                  loactionVariableController.setStorageData();
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
      itemCount: Get.find<BleScan>().deviceList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          child: ListTile(
            //디바이스 이름과 맥주소 그리고 신호 세기를 표시한다.
            leading: CircleAvatar(child: Icon(Icons.bluetooth),),
            title: Text("[${(index+1)}] ${Get.find<BleScan>().deviceList[index].name} - ${Get.find<BleScan>().deviceList[index].macAddress}"),
            subtitle: Text("${Get.find<BleScan>().deviceList[index].manufacturerData}",style: TextStyle(fontSize: 13),),
            trailing: Text("${Get.find<BleScan>().deviceList[index].rssi}"),
          ),
        );
      },
    );
  }
}