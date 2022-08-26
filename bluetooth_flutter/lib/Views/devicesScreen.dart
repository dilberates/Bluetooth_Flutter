import 'dart:math';

import 'package:bluetooth_flutter/Const/Colors.dart';
import 'package:bluetooth_flutter/Const/languageItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../Widgets/widgets.dart';
class DevicesScreen extends StatelessWidget {
  final BluetoothDevice? devices;
  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService>? services) {
    return services!
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => CharacteristicTile(
            characteristic: c,
            onReadPressed: () => c.read(),
            onWritePressed: () async {
              await c.write(_getRandomBytes(), withoutResponse: true);
              await c.read();
            },
            onNotificationPressed: () async {
              await c.setNotifyValue(!c.isNotifying);
              await c.read();
            },
            descriptorTiles: c.descriptors
                .map(
                  (d) => DescriptorTile(
                descriptor: d,
                onReadPressed: () => d.read(),
                onWritePressed: () => d.write(_getRandomBytes()),
              ),
            )
                .toList(),
          ),
        )
            .toList(),
      ),
    )
        .toList();
  }
  const DevicesScreen(
      {
        Key? key,
        required this.devices
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(devices!.name),
        actions: [
          _AppBarButton(devices:devices),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _DeviceProperties(devices: devices),
            _Edit(devices: devices),
            StreamBuilder<List<BluetoothService>>(
                stream: devices!.services,
                initialData: [],
                builder: (c,snapshot) {
                  return Column(
                    children: _buildServiceTiles(snapshot.data),
                  );
                }
                ),
          ],
        ),
      ),
    ) ;
  }
}
class _AppBarButton extends StatelessWidget {
  final BluetoothDevice? devices;
  const _AppBarButton({
    Key? key,
    required this.devices
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: devices!.state,
        initialData: BluetoothDeviceState.connecting,
        builder:(context,snapshot) {
          VoidCallback onPressed;
          String text;
          switch(snapshot.data){
            case BluetoothDeviceState.connected:
              onPressed=() => devices?.disconnect();
              text=LanguageItem.disconnectTitle;
              break;
            case BluetoothDeviceState.disconnected:
              onPressed = () => devices?.connect();
              text=LanguageItem.connectTitle;
              break;
            default:
              onPressed=() => null;
              text=snapshot.data.toString().substring(21).toUpperCase();
          }
          return ElevatedButton(
              onPressed: onPressed,
              child:Text(text,
                style: Theme.of(context).primaryTextTheme.button?.copyWith(color: MyColors.grey
                ),)
          );
        }
    );
  }
}

class _DeviceProperties extends StatelessWidget {

  final BluetoothDevice? devices;
  const _DeviceProperties({Key? key,
  required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: devices!.state,
      initialData: BluetoothDeviceState.connecting,
      builder: (context, snapshot) => ListTile(
        leading: (snapshot.data == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: Text(
            '${LanguageItem.descrepcions} ${snapshot.data.toString().split('.')[1]}.'),
        subtitle: Text('${devices!.id}'),
        trailing: StreamBuilder<bool>(
          stream: devices!.isDiscoveringServices,
          initialData: false,
          builder: (context,snapshot) => IndexedStack(
            index: snapshot.data! ? 1 : 0 ,
            children: [
              IconButton(
                  onPressed: () => devices!.discoverServices(),
                  icon: const Icon(Icons.replay_circle_filled,
                    color: MyColors.green,)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _Edit extends StatelessWidget {
  final BluetoothDevice? devices;
  const _Edit({
    Key? key,
  required this.devices
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: devices!.mtu,
      initialData: 0,
      builder: (context,snapshot)=> ListTile(
        title: Text(LanguageItem.mtuText),
        subtitle: Text('${snapshot.data} bytes'),
        trailing: IconButton(
          icon: const Icon(Icons.edit,
            color: MyColors.black,),
          onPressed:() => devices!.requestMtu(223),
        ),
      ),
    );
  }
}



