import 'package:botapp/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';

class PosenetScreen extends StatefulWidget {
  late final List<CameraDescription> cameras;
  PosenetScreen(this.cameras);
  @override
  _PosenetScreenState createState() => new _PosenetScreenState();
}

class _PosenetScreenState extends State<PosenetScreen> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    loadModel();
    Future.delayed(Duration(seconds: 2), () {});
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: AppHeader(
        key: UniqueKey(),
        hasBackButton: true,
        hasLogOut: false,
        child: Stack(
          children: [
            Camera(
              widget.cameras,
              _model,
              setRecognitions,
            ),
            BndBox(
                _recognitions,
                math.max(_imageHeight, _imageWidth),
                math.min(_imageHeight, _imageWidth),
                screen.height,
                screen.width,
                _model),
          ],
        ),
      ),
    );
  }
}
