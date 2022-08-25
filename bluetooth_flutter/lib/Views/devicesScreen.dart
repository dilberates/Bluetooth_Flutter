import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
class DevicesScreen extends StatelessWidget {
  final BluetoothDevice? devices;
  const DevicesScreen(
      {
        Key? key,
        required this.devices
      }) : super(key: key);


  /*List<Widget> _buildServiceTile(List<BluetoothService> services){
    return services.map((e) => ServiceTile(

    ))
  }*/

  @override
  Widget build(BuildContext context) {
    return ;
  }
}
