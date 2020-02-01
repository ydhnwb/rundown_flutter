import 'package:flutter/material.dart';
import 'package:rundown_flutter/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rundown',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}