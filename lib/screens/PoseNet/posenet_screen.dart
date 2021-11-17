import 'dart:async';
import 'dart:io';
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
  ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<bool> _enableAudio = ValueNotifier(true);
  late final String myImagePath;

  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;

  /// list of available sizes
  late List<Size> _availableSizes;

  late AnimationController _iconsAnimationController,
      _previewAnimationController;
  late Animation<Offset> _previewAnimation;
  // StreamSubscription<Uint8List> previewStreamSub;
  Stream<Uint8List>? previewStream;

  @override
  void initState() {
    super.initState();
    loadModel();
    loadStorage();
    _iconsAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _previewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    _previewAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _previewAnimationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn,
      ),
    );
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
    _iconsAnimationController.dispose();
    _previewAnimationController.dispose();
    // previewStreamSub.cancel();
    _photoSize.dispose();
    _captureMode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_iconsAnimationController == null ||
        _previewAnimationController == null ||
        _previewAnimation == null) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_iconsAnimationController != null ||
          _previewAnimationController == null ||
          _previewAnimation != null) {
        dispose();
        Future.delayed(Duration(seconds: 2), () {
          initState();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildFullscreenCamera(screen: screen),
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
            enableAudio: _enableAudio,
            photoSize: _photoSize,
            captureMode: _captureMode,
            switchFlash: _switchFlash,
            rotationController: _iconsAnimationController,
            onFlashTap: () {
              switch (_switchFlash.value) {
                case CameraFlashes.NONE:
                  _switchFlash.value = CameraFlashes.ON;
                  break;
                case CameraFlashes.ON:
                  _switchFlash.value = CameraFlashes.AUTO;
                  break;
                case CameraFlashes.AUTO:
                  _switchFlash.value = CameraFlashes.ALWAYS;
                  break;
                case CameraFlashes.ALWAYS:
                  _switchFlash.value = CameraFlashes.NONE;
                  break;
              }
              setState(() {});
            },
            onAudioChange: () {
              this._enableAudio.value = !this._enableAudio.value;
              setState(() {});
            },
            onChangeSensorTap: () {
              this._focus = !_focus;
              if (_sensor.value == Sensors.FRONT) {
                _sensor.value = Sensors.BACK;
              } else {
                _sensor.value = Sensors.FRONT;
              }
            },
            onResolutionTap: () => _buildChangeResolutionDialog(),
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
          rotationController: _iconsAnimationController,
          captureMode: _captureMode,
        ),
      ],
    );
  }

  _buildChangeResolutionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => ListTile(
          key: ValueKey("resOption"),
          onTap: () {
            this._photoSize.value = _availableSizes[index];
            setState(() {});
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.aspect_ratio),
          title: Text(
              "${_availableSizes[index].width}/${_availableSizes[index].height}"),
        ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: _availableSizes.length,
      ),
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

  bool isDetecting = false;
  var counter = 0;

  void drawBoundedBoxes(Uint8List img, Size size) async {
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
                        path: myImagePath, numResults: 2, threshold: 0.8)
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

  Widget buildFullscreenCamera({required Size screen}) {
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
            this._availableSizes = availableSizes;
            return availableSizes[0];
          },
          captureMode: _captureMode,
          photoSize: _photoSize,
          sensor: _sensor,
          enableAudio: _enableAudio,
          switchFlashMode: _switchFlash,
          zoom: _zoomNotifier,
          imagesStreamBuilder: (imageStream) {
            /// listen for images preview stream
            /// you can use it to process AI recognition or anything else...
            print("-- init CamerAwesome images stream");
            setState(() {
              previewStream = imageStream;
            });

            imageStream?.listen((Uint8List imageData) {
              drawBoundedBoxes(imageData, screen);
              print(
                  "...${DateTime.now()} new image received... ${imageData.lengthInBytes} bytes");
            });
          },
        ),
      ),
    );
  }
}
