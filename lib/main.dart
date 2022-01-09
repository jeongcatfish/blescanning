import 'dart:async';
import 'dart:io' show Platform;
import 'package:blescanning/provider/bleScanProvider.dart';
import 'package:blescanning/provider/locationVariableProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => BleScan()),
        ChangeNotifierProvider(create: (c) => LocationVariable()),
      ],
        child: MaterialApp(home: HomePage())),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000),(){
      context.read<BleScan>().setScanStarted();
      context.read<BleScan>().startScan();
    });
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FLUTTER BLE SCANNER"),backgroundColor: Colors.green,),

      backgroundColor: Colors.white,
      body: [HomeView(),SettingView()][_selectedIndex],
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
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(30),
          child: Text("TOTAL COUNT : ${context.watch<BleScan>().deviceList.length.toString()}",
            style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
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
                  onPressed: () {context.read<LocationVariable>().minus1SectionIdx();},
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
        return ListTile(
          //디바이스 이름과 맥주소 그리고 신호 세기를 표시한다.
          title: Text((index+1).toString()+"    " + context.watch<BleScan>().deviceList[index].name),
          subtitle: Text(context.watch<BleScan>().deviceList[index].macAddress),
          trailing: Text("${context.watch<BleScan>().deviceList[index].rssi}"),
        );
      },
    );
  }
}


