///Huy Ho
///CPSC 481 Project
///This file contain the main root file where application compile will launch

import 'package:flutter/material.dart';
import 'package:flutter_ml_vision/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(), //call Home screen class, check out home.dart file for detail 
      
      
    );
  }
}

