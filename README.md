# AI is your eyes Project

I’m passionate about building great mobile application that make people’s lives easier. Therefore I create this application to help visually impaired people. 
The application goals are simple and reliable.

## IDE Setup

- [Get started with Flutter on Windows](https://medium.com/fnplus/setting-up-flutter-for-windows-ca2c5e643fdf)

- [Get started with Flutter on Linux Ubuntu](https://link.medium.com/wnUcqyGaUZ)

- [Get started with Flutter on Mac](https://medium.com/@sethladd/installing-flutter-on-a-mac-13a26340f80a)

## Tips and Tricks

- Use [VS Code](https://code.visualstudio.com/) for light weight code editing

- [Useful extension for VS Code](https://medium.com/flutter-community/must-have-vs-code-extensions-for-working-with-flutter-e31a421b9c68)

- Quick create android emulator:

```

flutter emulator --create

flutter emulator --launch flutter_emulator

```

- Check if enough IDE for flutter:

```

flutter doctor

```

## To run project

Requires: Either emulator(IPhone/Android) or usb debug connected device  

```

flutter run

```

## Code Style

Follow effective dart style

[![js-standard-style](https://img.shields.io/badge/code%20style-standard-brightgreen.svg?style=flat)](https://dart.dev/guides/language/effective-dart/style)

## Code Example

main.dart

```dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }

```

## Packages and Plugins for Dart

- [Firebase ML Vision](https://pub.dev/packages/firebase_ml_vision)

- [Flutter Camera ML Vision](https://pub.dev/packages/flutter_camera_ml_vision)

- [Camera](https://pub.dev/packages/camera)


## Credits

[Alex Ho](https://github.com/hho114): front-end, back-end, research, maintenance, testing.
