import 'package:expense_tracker/googlesheetsapi.dart';
import 'package:expense_tracker/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
  GoogleSheetsApi().init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
