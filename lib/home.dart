/// Huy Ho
/// CPSC 481 Project
/// This file contain main home funciton and display for application


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

  List<Face> _faces = [];//list contain face object getting from detector
  List<String> data = [];//list contain object for display on screen
  final _scanKey = GlobalKey<CameraMlVisionState>();
  FlutterTts flutterTts = FlutterTts();// class object for text to speech
  String speakText = '';// string contain speak content
  bool playSpeak = false;//switch for play speak
  int count = 0;//count amount object get detected 
  DetectType detectType = DetectType.object; //whether use face detect or object detect
  CameraLensDirection cameraLensDirection = CameraLensDirection.back;//which camera to use
  ImageLabeler detector =
      FirebaseVision.instance.imageLabeler(ImageLabelerOptions(
    confidenceThreshold: 0.75,
  ));//initial image label detector
  FaceDetector faceDetector =
      FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    enableTracking: true,
    mode: FaceDetectorMode.accurate,
  ));//initial face detector

  @override
  void initState() {
    super.initState();
    flutterTts.setSpeechRate(0.8);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
       
        body: GestureDetector(
          //Decide whether to use face detect or object detect
          onTap: () {
            setState(() {
              detectType = DetectType.object;//if it is tap then set detect type to object
              playSpeak = true;
            });
          },
          onLongPress: () {
            setState(() {
              detectType = DetectType.face;//if it is long press then set detect type to face
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
                          if (playSpeak && detectType == DetectType.face) //if user touch screen and it is face detect
                          {
                            if (!mounted) //if camera is not turn on
                             {
                              return;
                            } else if (faces == null || faces.isEmpty) //else if face list is empty
                            {
                              setState(() {
                                count = 0;
                              });
                            } else //else list have some things
                            {
                              setState(() {
                                _faces = []..addAll(faces);//add all face to panter
                                count = faces.length;
                              });
                            }

                            if (count == 0) //if list is empty
                            {
                              flutterTts
                                  .speak('There maybe nothing, please try again');
                            } else // if list have faces
                            {
                              flutterTts.speak('There $count people');
                            }
                            setState(() {
                              count = 0;
                              playSpeak = false;
                              speakText = '';
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
                        if (playSpeak && detectType == DetectType.object) {
                          if (!labels.isEmpty) //if label list is not empty
                           {
                            for (ImageLabel label in labels) {
                              flutterTts.speak('There ');
                               if (data.contains(label.text)) //if label already in the list 
                               {
                                setState(() {
                                  if (count == 0) {
                                    speakText += label.text;
                                    count++;
                                  } 
                                  else{
                                    speakText += ' and  ${label.text}';
                                  }
                                });
                                
                              } else  {
                                setState(() {
                                  data.add(label.text);
                                  if (count == 0) {
                                    speakText += label.text;
                                    count++;
                                  } 
                                  else{
                                    speakText += ' and  ${label.text}';
                                  }
                                });
                              }

                              flutterTts.speak('There $speakText');

                              

                            }
                            setState(() {
                                speakText = '';
                                count = 0;
                                playSpeak = false;
                              });
                          } else {
                            flutterTts
                                .speak('There maybe nothing, please try again');
                            playSpeak = false;
                            
                          }
                        }
                      }),
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
      ),
    );
  }
}
