import 'package:blescanning/provider/requestServerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeaconListPage extends StatelessWidget {
  const BeaconListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beacon List"),),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text("From Server Data",style: TextStyle(fontSize: 20),),
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey,
                child: ListView.builder(
                  itemCount: context.watch<RequestServer>().beaconList.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      leading: Text(context.watch<RequestServer>().beaconList[index]["beacon_mac"]),
                      title: Text(context.watch<RequestServer>().beaconList[index]["taken"].toString()),
                      trailing: Text(context.watch<RequestServer>().beaconList[index]["yes_no"].toString()),
                    );
                  },
                ),
              )
          ),
        ],
      ),
    );
  }
}
