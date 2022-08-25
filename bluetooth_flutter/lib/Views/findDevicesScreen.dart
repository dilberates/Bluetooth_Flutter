import 'dart:ui';

import 'package:bluetooth_flutter/Const/languageItems.dart';
import 'package:bluetooth_flutter/Widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'devicesScreen.dart';
class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageItem.appBarTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
        FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: Column(
          children: [
            _ConnectButton(),
            _ScanResults(),
          ],
        ),
      ),
    );
  }
}

class _ConnectButton extends StatelessWidget {
  const _ConnectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BluetoothDevice>>(
      stream: Stream.periodic(Duration(seconds: 2))
          .asyncMap((_) => FlutterBlue.instance.connectedDevices),
      initialData: [],
      builder: (context, snapshot) => Column(
        children: snapshot.data!
            .map((d) => ListTile(
          title: Text(d.name),
          subtitle: Text(d.id.toString()),
          trailing: StreamBuilder<BluetoothDeviceState>(
            stream: d.state,
            initialData: BluetoothDeviceState.disconnected,
            builder: (c, snapshot) {
              if (snapshot.data ==
                  BluetoothDeviceState.connected) {
                return ElevatedButton(
                  child: Text(LanguageItem.openTitle),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              DevicesScreen(devices: d))),
                );
              }
              return Text(snapshot.data.toString());
            },
          ),
        ))
            .toList(),
      ),
    );
  }
}

class _ScanResults extends StatelessWidget {
  const _ScanResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        initialData: [],
        builder:(c, snapshot) => Column(
          children: snapshot.data!
              .map(
                (r) => ScanResultTile(
                    result: r,
                    onTap: () => Navigator.of(context).
                push(MaterialPageRoute(builder: (context) {
                  r.device.connect();
                  return DevicesScreen(devices: r.device);
                    })
                    )
                )
          ).toList(),
        ),
    );
  }
}


