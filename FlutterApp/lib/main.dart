import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/landing_page.dart';

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new HomeScreen(),
  ));

    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}