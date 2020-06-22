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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    camerInitialisation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container();
    }
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, images);
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: images.length > 0
                        ? AssetImage(images[images.length - 1].path)
                        : null,
                    child: Text(
                      images.length.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.photo_camera),
                      onPressed: () async {
                        File image = handler.getTempFile(
                            name: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString() +
                                '.jpg');
                        try {
                          await cameraController.takePicture(image.path);
                          setState(() {
                            images.add(image);
                          });
                          print(image);
                        } on CameraException catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    child: IconButton(
                      iconSize: 25,
                      icon: Icon(Icons.done),
                      onPressed: () {
                        Navigator.pop(context, images);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  camerInitialisation() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await cameraController.initialize();
    await handler.initSystem();
    setState(() {
      // TODO: anything
    });
  }
}
