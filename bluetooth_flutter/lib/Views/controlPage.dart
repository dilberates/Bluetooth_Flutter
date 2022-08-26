import 'package:bluetooth_flutter/Views/bluetoothOffScreen.dart';
import 'package:bluetooth_flutter/Views/findDevicesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>( //Her yeni veri geldiğinde builder fonksiyonu yeniden çalışır.
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context,snapshot) {
          final state=snapshot.data;
          if(state==BluetoothState.on)
            return const FindDevicesScreen();
          return BluetoothOffScreen(state:state);
        }
    );
  }
}
