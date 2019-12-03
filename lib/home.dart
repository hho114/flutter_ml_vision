import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isTap = false;
  List<String> data = [];
  final _scanKey = GlobalKey<CameraMlVisionState>();
  FlutterTts flutterTts = FlutterTts();
  String speakText = '';
  int count = 0;
  // BarcodeDetector detector = FirebaseVision.instance.barcodeDetector();
  ImageLabeler detector =
      FirebaseVision.instance.imageLabeler(ImageLabelerOptions(
    confidenceThreshold: 0.75,
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
        title: Text('AI VISION'),
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
                    if (!mounted) {
                      return;
                    } else if (data.contains(label.text)) {

                      setState(() {
                        
                        if (count == 0) {
                          speakText += label.text;
                          count++;
                        } else {
                          speakText += ' and ' +label.text;
                          
                        }
                        
                      });
                    } else {
                      setState(() {
                        data.add(label.text);
                        if (count == 0) {
                          speakText += label.text;
                          count++;
                        } else {
                          speakText += ' and ' +label.text;
                          
                        }
                        
                      });
                    }
                  }

                  if (speakText.isEmpty) {
                    flutterTts.speak('There maybe nothing, please try again');
                  } else {
                    flutterTts.speak('There $speakText');
                  }

                  setState(() {

                    isTap = false;
                    speakText = '';
                    count =0;
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
                  
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
