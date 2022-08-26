import 'package:bluetooth_flutter/Const/Colors.dart';
import 'package:bluetooth_flutter/Const/languageItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
class BluetoothOffScreen extends StatelessWidget {
  final BluetoothState? state;

  const BluetoothOffScreen({
    Key? key,
    this.state
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                 color: MyColors.white,
            ),
            Text(
              '${LanguageItem.adapterText} ${state != null ? state.toString().substring(15): LanguageItem.availableText }',
              style: Theme.of(context)
              .primaryTextTheme
              .subtitle1?.
              copyWith(color:MyColors.white),
            )
          ],
        ),
      ),
    );
  }
}
