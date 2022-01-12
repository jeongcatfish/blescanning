import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blescanning/provider/qrCodeScannerProvider.dart';

class QrSecondPage extends StatefulWidget {
  const QrSecondPage({Key? key}) : super(key: key);

  @override
  State<QrSecondPage> createState() => _QrSecondPageState();
}

class _QrSecondPageState extends State<QrSecondPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<QrCodeScanner>().setQrCodeScannedFalse();
        print('Backbutton pressed (device or appbar button), do whatever you want.');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(title: Text("QR SECOND PAGE"),),
      ),
    );
  }
}
