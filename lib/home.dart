import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:flutter_ml_vision/face_detector_painter.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum DetectType { face, object }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Face> _faces = [];
  List<String> data = [];
  final _scanKey = GlobalKey<CameraMlVisionState>();
  FlutterTts flutterTts = FlutterTts();
  String speakText = '';
  bool playSpeak = false;
  int count = 0;
  DetectType detectType = DetectType.object;
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;
  // BarcodeDetector detector = FirebaseVision.instance.barcodeDetector();
  ImageLabeler detector =
      FirebaseVision.instance.imageLabeler(ImageLabelerOptions(
    confidenceThreshold: 0.75,
  ));
  FaceDetector faceDetector =
      FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    enableTracking: true,
    mode: FaceDetectorMode.accurate,
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
        title: Text(''),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            detectType = DetectType.object;
            playSpeak = true;
          });
        },
        onLongPress: () {
          setState(() {
            detectType = DetectType.face;
            playSpeak = true;
          });
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            (detectType == DetectType.face)
                ? SizedBox.expand(
                    child: CameraMlVision<List<Face>>(
                      key: _scanKey,
                      cameraLensDirection: cameraLensDirection,
                      detector: faceDetector.processImage,
                      overlayBuilder: (c) {
                        return CustomPaint(
                          painter: FaceDetectorPainter(
                              _scanKey
                                  .currentState.cameraValue.previewSize.flipped,
                              _faces,
                              reflection: cameraLensDirection ==
                                  CameraLensDirection.front),
                        );
                      },
                      onResult: (faces) {
                        if (playSpeak && detectType == DetectType.face) {
                          if (faces == null || faces.isEmpty || !mounted) {
                            return;
                          } else {
                            setState(() {
                              _faces = []..addAll(faces);
                              count = faces.length;
                            });
                          }

                          if (count == 0) {
                            flutterTts
                                .speak('There maybe nothing, please try again');
                          } else {
                            flutterTts.speak('There $count people');
                          }
                          setState(() {
                            count = 0;
                            playSpeak = false;
                            speakText='';
                          });
                        }
                      },
                      // onDispose: () {
                      //   faceDetector.close();

                      // },
                    ),
                  )
                : CameraMlVision<List<ImageLabel>>(
                    key: _scanKey,
                    detector: detector.processImage,
                    onResult: (labels) {
                      for (ImageLabel label in labels) {
                        if (playSpeak && detectType == DetectType.object) {
                          if (!mounted) {
                            return;
                          } else if (data.contains(label.text)) {
                            setState(() {
                              if (count == 0) {
                                speakText += label.text;
                                count++;
                              } else {
                                speakText += ' and ' + label.text;
                              }
                            });
                          } else {
                            setState(() {
                              data.add(label.text);
                              if (count == 0) {
                                speakText += label.text;
                                count++;
                              } else {
                                speakText += ' and ' + label.text;
                              }
                            });
                          }

                          if (speakText.isEmpty) {
                            flutterTts
                                .speak('There maybe nothing, please try again');
                          } else {
                            flutterTts.speak('There $speakText');
                          }

                          setState(() {
                            speakText = '';
                            count = 0;
                            playSpeak = false;
                          });
                          // onDispose: () {
                          //   detector.close();
                          // },
                        }
                      }
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
