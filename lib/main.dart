import 'dart:async';
import 'dart:io' show Platform;
import 'package:blescanning/provider/bleScanProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => BleScan()),
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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000),(){
      context.read<BleScan>().setScanStarted();
      context.read<BleScan>().startScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FLUTTER BLE SCANNER"),backgroundColor: Colors.green,),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
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
        ),
      )
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


