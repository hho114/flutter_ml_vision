import 'package:flutter/material.dart';
import 'package:flutter_ml_vision/components/round_button.dart';
import 'package:flutter_ml_vision/face_detect.dart';
import 'package:flutter_ml_vision/image_label_camera.dart';
import 'package:flutter_ml_vision/image_label_gallery.dart';

class Home extends StatelessWidget {
  static const String id = 'home';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Label Image Detector'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Use Gallery Image',
                onPressed: () => Navigator.pushNamed(context, ImageLabelDetectorGallery.id),
              ),
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Use Camera',
                onPressed: () => Navigator.pushNamed(context, ImageLabelDetectorCamera.id),
              ),
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Face Detector',
                onPressed: () => Navigator.pushNamed(context, FaceDetect.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
