import 'package:bluetooth_flutter/Const/Colors.dart';
import 'package:bluetooth_flutter/Views/controlPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        backgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
          primary: MyColors.buttonColor,
            onPrimary: MyColors.white,
            padding: const EdgeInsets.all(10.0),
          )
        )

      ),
      home: ControlPage(),
    );
  }
}

