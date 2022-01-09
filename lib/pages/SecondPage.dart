import 'package:blescanning/provider/requestServerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("secodnPAge"),),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text("From Server Data",style: TextStyle(fontSize: 20),),
          ),
          Flexible(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: context.watch<RequestServer>().beaconMap.length,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: Text(context.watch<RequestServer>().workerBeaconDto[index]["workerName"]),
                    title: Text(context.watch<RequestServer>().workerBeaconDto[index]["beaconMac"]),
                    trailing: Text(context.watch<RequestServer>().workerBeaconDto[index]["active"].toString()),
                  );
                },
              ),
            )
          ),
          Flexible(
            flex: 1,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 5,color: Colors.red),
                      color: Colors.blue
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  }, child: Text("out",style: TextStyle(fontSize: 50),))
                ],
              )
        )
        ],
      ),
    );
  }
}
