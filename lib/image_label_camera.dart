import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ImageLabelDetectorCamera extends StatefulWidget {
  static const String id = 'camera';

  @override
  _ImageLabelDetectorCameraState createState() =>
      _ImageLabelDetectorCameraState();
}

class _ImageLabelDetectorCameraState extends State<ImageLabelDetectorCamera> {
  File _image;
  bool _loading = false;

  List<ImageLabel> labels;
  List<String> labelList;

  List<double> confidenceList;
  String speakText;
  FlutterTts flutterTts = FlutterTts();

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
                labelList: labelList,
                confidenceList: confidenceList,
              ),
        inAsyncCall: _loading,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImage(),
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getImage() async {
    setState(() {
      _loading = true;
    });

    try {
      final imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      if (imageFile == null) {
        throw Exception('File is not available');
      }
      final image = FirebaseVisionImage.fromFile(imageFile);
      final imageLabeler =
          FirebaseVision.instance.imageLabeler(ImageLabelerOptions(
        confidenceThreshold: 0.60,
      ));
      labels = await imageLabeler.processImage(image);
      setState(() {
        _image = imageFile;
        _loading = false;
      });
      labelList = new List();
      speakText = '';
      for (ImageLabel label in labels) {
        labelList.add(label.text);
        speakText += ' ' + label.text;
      }

      confidenceList = new List();
      for (ImageLabel label in labels) {
        confidenceList.add(label.confidence);
      }
      await flutterTts.speak('The image ralate to $speakText');

      imageLabeler.close();
    } catch (e) {
      print(e);
    }
  }
}

class ImageAndLabel extends StatelessWidget {
  ImageAndLabel({this.imageFile, this.labelList, this.confidenceList});
  final File imageFile;
  final List<String> labelList;
  final List<double> confidenceList;

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
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Column(
                  children: labelList.map((item) => new Text(item)).toList()),
              SizedBox(
                width: 10,
              ),
              confidenceList != null
                  ? Column(
                      children: confidenceList
                          .map((item) =>
                              new Text((item * 100).toStringAsFixed(1) + '%'))
                          .toList())
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
