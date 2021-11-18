import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:botapp/widgets/camera_widgets/bottom_bar.dart';
import 'package:botapp/widgets/camera_widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as IMG;
import 'dart:math' as math;

import 'bndbox.dart';

class PosenetScreen extends StatefulWidget {
  @override
  _PosenetScreenState createState() => _PosenetScreenState();
}

class _PosenetScreenState extends State<PosenetScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _focus = false;
  ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<double> _zoomNotifier = ValueNotifier(0);
  ValueNotifier<Size> _photoSize = ValueNotifier(Size(300, 300));
  ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.FRONT);
  bool isDetecting = false;
  var counter = 0;
  late final String myImagePath;

  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    loadModel();
    loadStorage();
  }

  loadStorage() async {
    // getting a directory path for saving
    // This will not work in IOS
    // TODO: Fix this if need to run in IOS
    await getExternalStorageDirectory()
        .then((dir) => myImagePath = dir!.path + "/myimg.png");
  }

  loadModel() async {
    var res = await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
    print(res);
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void dispose() {
    _switchFlash.dispose();
    _zoomNotifier.dispose();
    _photoSize.dispose();
    _sensor.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildFullscreenCamera(),
          _buildInterface(),
          BndBox(
            _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Transform.rotate(
              angle: pi / 2,
              child: BackButton(
                color: Colors.white,
                onPressed: () {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft
                  ]);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterface() {
    return Stack(
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: TopBarWidget(
            key: UniqueKey(),
            onChangeSensorTap: () {
              this._focus = !_focus;
              if (_sensor.value == Sensors.FRONT) {
                _sensor.value = Sensors.BACK;
              } else {
                _sensor.value = Sensors.FRONT;
              }
            },
          ),
        ),
        BottomBarWidget(
          key: UniqueKey(),
          onZoomInTap: () {
            if (_zoomNotifier.value <= 0.9) {
              _zoomNotifier.value += 0.1;
            }
            setState(() {});
          },
          onZoomOutTap: () {
            if (_zoomNotifier.value >= 0.1) {
              _zoomNotifier.value -= 0.1;
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  void _onPermissionsResult(bool? granted) {
    granted = granted ?? false;
    if (!granted) {
      AlertDialog alert = AlertDialog(
        title: Text('Error'),
        content: Text(
            'It seems you doesn\'t authorized some permissions. Please check on your settings and try again.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      setState(() {});
      print("granted");
    }
  }

  void drawBoundedBoxes(Uint8List img) async {
    if (mounted) {
      // Process every 5th frame
      if (counter % 5 == 0) {
        // process the frame
        if (!isDetecting) {
          isDetecting = true;
          IMG.Image? image = IMG.decodeImage(img);

          if (image != null && myImagePath != null) {
            File imageFile = File(myImagePath);
            if (!await imageFile.exists()) {
              imageFile.create(recursive: true);
            }
            // The actual detection is wrong
            // Probably got something to do with the rotation
            // TODO: Fix this
            imageFile.writeAsBytes(img).then((res) => Tflite.runPoseNetOnImage(
                        path: myImagePath, numResults: 2, threshold: 0.5)
                    .then((recognitions) {
                  print(recognitions?.length);
                  if (mounted) {
                    setRecognitions(recognitions ?? [], image.width.toInt(),
                        image.height.toInt());

                    isDetecting = false;
                  }
                }));
          }
        }
      }

      // Don't let counter go out of control forever
      if (counter == 1000) {
        counter = 0;
      } else {
        counter++;
      }
    }
  }

  Widget buildFullscreenCamera() {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Center(
        child: CameraAwesome(
          orientation: DeviceOrientation.portraitUp,
          onPermissionsResult: _onPermissionsResult,
          selectDefaultSize: (availableSizes) {
            return availableSizes[0];
          },
          captureMode: ValueNotifier(CaptureModes.PHOTO),
          photoSize: ValueNotifier(Size(300, 300)),
          sensor: _sensor,
          enableAudio: ValueNotifier(true),
          zoom: _zoomNotifier,
          imagesStreamBuilder: (imageStream) {
            /// listen for images preview stream
            /// you can use it to process AI recognition or anything else...
            imageStream?.listen((Uint8List imageData) {
              drawBoundedBoxes(imageData);
            });
          },
        ),
      ),
    );
  }
}
