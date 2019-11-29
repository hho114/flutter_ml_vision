// // Copyright 2018 The Flutter team. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

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

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isTap = false;
  List<String> data = [];
  final _scanKey = GlobalKey<CameraMlVisionState>();
  FlutterTts flutterTts = FlutterTts();
  String speakText='';
  // BarcodeDetector detector = FirebaseVision.instance.barcodeDetector();
  ImageLabeler detector =
      FirebaseVision.instance.imageLabeler(ImageLabelerOptions(
    confidenceThreshold: 0.8,
  ));

@override
void initState() { 
  super.initState();
  flutterTts.setSpeechRate(0.8);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onTap: () {
          isTap = true;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            CameraMlVision<List<ImageLabel>>(
              key: _scanKey,
              detector: detector.processImage,
              onResult: (labels) {
                if (isTap) {
                  
                
                for (ImageLabel label in labels) {

                  if ( !mounted) {
                    return;
                  }
                  
                  else if (data.contains(label.text)) {
                    speakText+=' ' +label.text;

                    
                  }else
                  {
                      setState(() {
                    data.add(label.text);
                    speakText+=' ' +label.text;
                   
                    });
                  }

                  
                }
                
                if (speakText == '') {
                  flutterTts.speak('There may be nothing, please try again');
                  
                }
                flutterTts.speak('There are $speakText');
                setState(() {
                  isTap=false;
                  speakText='';
                  // data.clear();
                });
                }
              },
              onDispose: () {
                detector.close();
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 250),
                    child: Scrollbar(
                      child: ListView(
                        children: data.map((d) {
                          return Container(
                            color: Color(0xAAFFFFFF),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(d),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          _scanKey.currentState.toggle();
                        },
                        child: Text('Start/Pause camera'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => _SecondScreen()));
                        },
                        child: Text('Push new route'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RaisedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => _SecondScreen(),
          ));
        },
        child: Text('Push new route'),
      ),
    );
  }
}
