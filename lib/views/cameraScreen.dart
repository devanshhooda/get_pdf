import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:get_pdf/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
            ),
            Positioned(
              bottom: 825,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 20,
                child: IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () {
                      Navigator.pop(context, images);
                    }),
              ),
            ),
            Positioned(
              top: 850,
              left: 50,
              child: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                radius: 30,
                backgroundImage: images.length > 0
                    ? AssetImage(images[images.length - 1].path)
                    : null,
                child: Text(
                  images.length.toString(),
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 850,
              left: 180,
              child: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                radius: 30,
                child: IconButton(
                  iconSize: 30,
                  color: Colors.white,
                  icon: Icon(Icons.camera),
                  onPressed: () async {
                    File image = handler.getTempFile(
                        name: DateTime.now().millisecondsSinceEpoch.toString() +
                            '.jpg');
                    try {
                      await cameraController
                          .takePicture(image.path)
                          .whenComplete(() {
                        images.add(image);
                        setState(() {});
                      });
                    } on CameraException catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ),
            Positioned(
              top: 850,
              left: 310,
              child: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                radius: 30,
                child: IconButton(
                  color: Colors.white,
                  iconSize: 25,
                  icon: Icon(Icons.done),
                  onPressed: () {
                    Navigator.pop(context, images);
                  },
                ),
              ),
            ),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int resol = prefs.getInt(Constants.cameraResolution) ?? 2;
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], getResol(resol));
    await cameraController.initialize();
    await handler.initSystem();
    setState(() {});
  }

  ResolutionPreset getResol(val) {
    switch (val) {
      case 0:
        return ResolutionPreset.low;
      case 1:
        return ResolutionPreset.medium;
      case 2:
        return ResolutionPreset.high;
      case 3:
        return ResolutionPreset.veryHigh;
      case 4:
        return ResolutionPreset.ultraHigh;
      case 5:
        return ResolutionPreset.max;
      default:
        return ResolutionPreset.low;
    }
  }
}
