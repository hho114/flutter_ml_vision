// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'package:flutter/material.dart';
// import 'package:flutter_ml_vision/ai_use_camera.dart';
// import 'package:flutter_ml_vision/ai_use_gallery.dart';
// import 'package:flutter_ml_vision/face_detect.dart';
// import 'package:flutter_ml_vision/home.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(

//       debugShowCheckedModeBanner: false,
//       initialRoute: Home.id,
//       routes:
//       {
//         'home': (context)=> Home(),
//         'gallery': (context)=> AIUseGallery(),
//         'camera': (context)=> AIUseCamera(),
//         'face_detect': (context)=> FaceDetect(),

//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_ml_vision/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

