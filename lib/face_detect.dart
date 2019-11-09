import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FaceDetect extends StatefulWidget {
  static const String id = 'face_detect';

  @override
  _FaceDetectState createState() => _FaceDetectState();
}

class _FaceDetectState extends State<FaceDetect> {
  File _image;
  bool _loading = false;
  int faceCounter =0;

  List<Face> faces;
    FlutterTts flutterTts = new FlutterTts();

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Use Image Picker'),
      ),
      body: ModalProgressHUD(
        child: _image == null
            ? Text('No image selected.')
            : ImageAndLabel(
                imageFile: _image,
                faceCounter: faceCounter,
                
              ),
        inAsyncCall: _loading,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getNumberOfFace(),
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getNumberOfFace() async {
    setState(() {
      _loading = true;
    });

    try {
      final imageFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile == null) {
        throw Exception('File is not available');
      }
      final image = FirebaseVisionImage.fromFile(imageFile);
      final faceDetector = FirebaseVision.instance.faceDetector();
      faces = await faceDetector.processImage(image);

      setState(() {
        _image = imageFile;
        faceCounter = faces.length;
        _loading = false;
        
      });
      await flutterTts.speak('There $faceCounter people in the image');

      
      faceDetector.close();
    } catch (e) {
      print(e);
    }
  }
}

class ImageAndLabel extends StatelessWidget {
  ImageAndLabel({this.imageFile, this.faceCounter});
  final File imageFile;
  final int faceCounter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
              constraints: BoxConstraints.expand(),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              )),
        ),
        SizedBox(
          height: 20,
        ),
        Flexible(
          flex: 1,
          child: Text('Number of people in the image: $faceCounter'),
        ),
      ],
    );
  }
}
