import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcPage extends StatefulWidget {
  const NfcPage({Key? key}) : super(key: key);

  @override
  _NfcPageState createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tagRead();
  }
  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      print("result : ${tag.data}");
      NfcManager.instance.stopSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("nfc tag!"),),
    );
  }
}
