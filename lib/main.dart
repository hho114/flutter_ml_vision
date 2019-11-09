// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ml_vision/face_detect.dart';
import 'package:flutter_ml_vision/home.dart';
import 'package:flutter_ml_vision/image_label_camera.dart';
import 'package:flutter_ml_vision/image_label_gallery.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      initialRoute: Home.id,
      routes: 
      {
        'home': (context)=> Home(),
        'gallery': (context)=> ImageLabelDetectorGallery(),
        'camera': (context)=> ImageLabelDetectorCamera(),
        'face_detect': (context)=> FaceDetect(),
        
      },
    );
  }
} 