import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ImageLabelDetectorGallery extends StatefulWidget {
  static const String id = 'gallery';

  @override
  _ImageLabelDetectorGalleryState createState() => _ImageLabelDetectorGalleryState();
}

class _ImageLabelDetectorGalleryState extends State<ImageLabelDetectorGallery> {
  File _image;
  bool _loading = false;

  List<ImageLabel> labels;
  List<String> labelList;
  List<String> entityIdList;
  List<double> confidenceList;

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
      final imageFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile == null) {
        throw Exception('File is not available');
      }
      final image = FirebaseVisionImage.fromFile(imageFile);
      final imageLabeler = FirebaseVision.instance.imageLabeler();
      labels = await imageLabeler.processImage(image);
      setState(() {
        _image = imageFile;
        _loading = false;
      });
      labelList = new List();
      for (ImageLabel label in labels) {
        labelList.add(label.text);
        // entityIdList.add(label.entityId);
        // confidenceList.add(label.confidence);
      }
      confidenceList = new List();
      for (ImageLabel label in labels) {
        // labelList.add(label.text);
        // entityIdList.add(label.entityId);
        confidenceList.add(label.confidence);
      }

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
