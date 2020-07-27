import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_pdf/models/cameraPair.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:get_pdf/utils/constants.dart';
import 'package:get_pdf/utils/sizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as Img;

class CameraScreen extends StatefulWidget {
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras = [];
  CameraController cameraController;

  FileHandling handler = FileHandling();

  List<File> images = [];

  // CameraPair cameraPair = new CameraPair()

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    camerInitialisation();
    selectedOption = 'normal_scan';
    displayText = 'Document Scan';
    super.initState();
  }

  String selectedOption, displayText;

  Widget _cameraPageOptions(IconData _iconData, String type) {
    return CircleAvatar(
      backgroundColor: Colors.black26,
      radius: SizeConfig.font_size * 3,
      child: IconButton(
          iconSize: SizeConfig.font_size * 3.4,
          icon: Icon(_iconData),
          color: type == selectedOption ? Colors.deepOrange : Colors.white,
          onPressed: () {
            if (type == 'barcode_scan') {
              print('$type work');
              setState(() {
                selectedOption = type;
                displayText = 'Barcode Scan';
              });
            } else if (type == 'qrcode_scan') {
              print('$type work');
              setState(() {
                selectedOption = type;
                displayText = 'QR Code Scan';
              });
            } else if (type == 'card_scan') {
              print('$type work');
              if (images.length > 0) {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text('Switch to card scanning ?'),
                      content: Text('Your clicked images will be lost'),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                selectedOption = type;
                                displayText = 'Card Scan';
                                images.clear();
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.red),
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(color: Colors.green),
                            ))
                      ],
                    ));
              } else {
                setState(() {
                  selectedOption = type;
                  displayText = 'Card Scan';
                });
              }
            } else if (type == 'normal_scan') {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text('Switch to document scanning ?'),
                    content: Text('Your clicked image will be lost'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              selectedOption = type;
                              displayText = 'Document Scan';
                              images.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.red),
                          )),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(color: Colors.green),
                          ))
                    ],
                  ));
            } else if (type == 'back') {
              _handleBackButton();
            }
          }),
    );
  }

  _handleBackButton() {
    if (images.length > 0) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Are you sure to quit ?'),
            content: Text('Your current images and changes will be lost'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    images.clear();
                    Navigator.pop(context, images);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.green),
                  )),
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container();
    }
    Color darkness = Color(0xAA000000);
    return WillPopScope(
      onWillPop: () {
        _handleBackButton();
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
            selectedOption == 'card_scan'
                ? Column(
                    children: <Widget>[
                      Expanded(child: Container(color: darkness)),
                      Row(
                        children: <Widget>[
                          Container(
                            color: darkness,
                            width: SizeConfig.remainingWidth,
                            height: SizeConfig.cardHeight,
                          ),
                          Container(
                            color: Colors.transparent,
                            width: SizeConfig.cardWidth,
                            height: SizeConfig.cardHeight,
                          ),
                          Container(
                            color: darkness,
                            width: SizeConfig.remainingWidth,
                            height: SizeConfig.cardHeight,
                          )
                        ],
                      ),
                      Expanded(child: Container(color: darkness)),
                    ],
                  )
                : Container(),
            Positioned(
              left: (selectedOption == 'normal_scan')
                  ? SizeConfig.safeBlockHorizontal * 39
                  : (selectedOption == 'card_scan')
                      ? SizeConfig.safeBlockHorizontal * 43
                      : 0,
              top: SizeConfig.safeBlockVertical * 5,
              child: Text(
                '$displayText',
                style: TextStyle(color: Colors.white60),
              ),
            ),
            Positioned(
                bottom: SizeConfig.safeBlockVertical * 92,
                left: SizeConfig.safeBlockHorizontal * 4,
                child: _cameraPageOptions(Icons.keyboard_arrow_down, 'back')),
            Positioned(
                bottom: SizeConfig.safeBlockVertical * 92,
                left: SizeConfig.safeBlockHorizontal * 46,
                child: _cameraPageOptions(Icons.crop_portrait, 'normal_scan')),
            Positioned(
                bottom: SizeConfig.safeBlockVertical * 92,
                left: SizeConfig.safeBlockHorizontal * 88,
                child: _cameraPageOptions(Icons.credit_card, 'card_scan')),
            Positioned(
              top: SizeConfig.safeBlockVertical * 95,
              left: SizeConfig.safeBlockHorizontal * 13,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: SizeConfig.font_size * 4.5,
                backgroundImage: images.length > 0
                    ? FileImage(images[images.length - 1])
                    : null,
                child: selectedOption == 'normal_scan' && images.length > 0
                    ? Text(
                        images.length.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.font_size * 4),
                      )
                    : null,
              ),
            ),
            Positioned(
              top: SizeConfig.safeBlockVertical * 95,
              left: SizeConfig.safeBlockHorizontal * 43,
              child: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                radius: SizeConfig.font_size * 4.5,
                child: IconButton(
                  iconSize: SizeConfig.font_size * 4,
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
                        if (selectedOption == 'card_scan') {
                          cropImageAndAdd(image);
                        } else if (selectedOption == 'normal_scan') {
                          images.add(image);
                          setState(() {});
                        }
                      });
                    } on CameraException catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ),
            (selectedOption == 'normal_scan' && images.length > 0)
                ? Positioned(
                    top: SizeConfig.safeBlockVertical * 95,
                    left: SizeConfig.safeBlockHorizontal * 73,
                    child: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      radius: SizeConfig.font_size * 4.5,
                      child: IconButton(
                        color: Colors.white,
                        iconSize: SizeConfig.font_size * 4,
                        icon: Icon(Icons.done),
                        onPressed: () {
                          CameraPair cameraPair = new CameraPair(
                              images: images, scanType: 'normal_scan');
                          Navigator.pop(context, cameraPair);
                        },
                      ),
                    ),
                  )
                : Container(),
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
    try {
      await cameraController.initialize();
    } catch (err) {
      Navigator.pop(context, null);
      return;
    }
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

  void cropImageAndAdd(File image) {
    Img.Image photo = Img.decodeImage(image.readAsBytesSync());
    int x = ((SizeConfig.x / SizeConfig.screenWidth) * photo.height).floor();
    int y = ((SizeConfig.y / SizeConfig.screenHeight) * photo.width).floor();
    int w = ((SizeConfig.cardWidth / SizeConfig.screenWidth) * photo.height)
        .floor();
    int h = ((SizeConfig.cardHeight / SizeConfig.screenHeight) * photo.width)
        .floor();
    if (w < h) {
      x = x + y;
      y = x - y;
      x = x - y;
      w = w + h;
      h = w - h;
      w = w - h;
    }
    Img.Image newImg = Img.copyCrop(photo, y, x, h, w);
    image.writeAsBytesSync(Img.encodeJpg(newImg));
    images.add(image);
    if (images.length == 2) {
      CameraPair cameraPair =
          new CameraPair(images: images, scanType: 'card_scan');
      Navigator.pop(context, cameraPair);
    } else {
      setState(() {});
    }
  }
}
