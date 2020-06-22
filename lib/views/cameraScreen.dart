import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_pdf/services/fileHandling.dart';

class CameraScreen extends StatefulWidget {
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras = [];
  CameraController cameraController;

  FileHandling handler = FileHandling();

  List<File> images = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState> ();

  @override
  void initState() {
    realInitState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: cameraController.value.aspectRatio,
            child: CameraPreview(
                cameraController
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () async {
                  File image = handler.getTempFile(name: DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
                  try {
                    await cameraController.takePicture(image.path);
                    images.add(image);
                    print(image);
                  } on CameraException catch (e) {
                    // TODO: show camera exception
                    print(e);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: ()  {
                  Navigator.pop(context, images);
                },
              ),
              Expanded(
                child: Container(),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  realInitState() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await cameraController.initialize();
    await handler.initSystem();
    setState(() {
      // TODO: anything
    });
  }

}