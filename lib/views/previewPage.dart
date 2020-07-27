import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_pdf/services/imageServices.dart';
import 'package:get_pdf/utils/constants.dart';
import 'package:get_pdf/utils/sizeConfig.dart';
import 'package:get_pdf/views/cameraScreen.dart';
import 'package:get_pdf/views/editorPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as Img;
import '../services/pdfServices.dart';
import 'viewPdf.dart';

class PreviewPage extends StatefulWidget {
  final bool isNormalScan;
  final List<File> imageList;
  PreviewPage({this.imageList, this.isNormalScan});
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  PdfServices pdfServices;
  List<bool> selected;
  bool isSelection;
  var getEditImage;

  @override
  void initState() {
    selected = List<bool>(widget.imageList.length);
    isSelection = false;
    pdfServices = PdfServices();
    super.initState();
  }

  Widget _appBar() {
    return isSelection
        ? AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                isSelection = false;
                selected = List<bool>(widget.imageList.length);
                setState(() {});
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  int k = 0;
                  for (int i = 0; i < selected.length; i++) {
                    if (selected[i] == true) {
                      widget.imageList.removeAt(i + k);
                      k--;
                    }
                  }
                  isSelection = false;
                  selected = List<bool>(widget.imageList.length);
                  if (widget.imageList.isEmpty) {
                    Navigator.of(context).pop();
                  }
                  setState(() {});
                },
              )
            ],
          )
        : AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Selected images',
              style: TextStyle(
                fontFamily: 'MedriendaOne',
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.picture_as_pdf),
                onPressed: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Preparing document..  '),
                              CircularProgressIndicator(),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.safeBlockHorizontal * 7,
                              vertical: SizeConfig.safeBlockVertical * 3),
                        );
                      });
                  if (!widget.isNormalScan) {
                    mergeImages(0, 1, vp: 80, hp: 40);
                  }
                  String filename =
                      await pdfServices.createPdfFromImages(widget.imageList);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  bool darkPdf = prefs.getBool(Constants.darkPdf) ?? false;
                  bool mobileView =
                      prefs.getBool(Constants.mobileView) ?? false;
                  bool spacing = prefs.getBool(Constants.autoSpacing) ?? true;
                  Navigator.of(context).pop();
                  if (filename == null) return;
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => ViewPdf(
                            documentPath: filename,
                            darkPdf: darkPdf,
                            mobileView: mobileView,
                            spacing: spacing,
                          )));
                  // ModalRoute.withName('/'));
                },
              ),
              // IconButton(
              //     icon: Icon(Icons.sentiment_very_satisfied),
              //     onPressed: () async {})
            ],
          );
  }

  Widget _floatingButton() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      curve: Curves.easeInSine,
      foregroundColor: Colors.black,
      overlayColor: Colors.orangeAccent,
      overlayOpacity: 0.4,
      children: [
        SpeedDialChild(
          label: 'Add pictures using Camera',
          labelStyle: TextStyle(
              fontSize: SizeConfig.font_size * 2.2, color: Colors.white),
          labelBackgroundColor: Colors.deepOrange,
          child: Icon(Icons.photo_camera),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CameraScreen()))
                .then((images) {
              widget.imageList.addAll(images);
              isSelection = false;
              selected = List<bool>(widget.imageList.length);
              setState(() {});
            });
          },
        ),
        SpeedDialChild(
          label: 'Add images from Gallery',
          labelStyle: TextStyle(
              fontSize: SizeConfig.font_size * 2.2, color: Colors.white),
          labelBackgroundColor: Colors.deepOrange,
          child: Icon(Icons.add_photo_alternate),
          onTap: () async {
            await ImageServices().pickImages().then((images) {
              widget.imageList.addAll(images);
              isSelection = false;
              selected = List<bool>(widget.imageList.length);
              setState(() {});
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (isSelection) {
            isSelection = false;
            selected = List<bool>(widget.imageList.length);
            setState(() {});
            return;
          } else {
            Navigator.of(context).pop();
            return;
          }
        },
        child: Scaffold(
          appBar: _appBar(),
          body: Container(
            child: GridView.builder(
                itemCount: widget.imageList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, i) {
                  return Hero(
                    tag: i,
                    child: GestureDetector(
                      onTap: () {
                        if (isSelection) {
                          setState(() {
                            selected[i] = selected[i] == true ? false : true;
                          });
                        } else {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) =>
                                      EditImage(widget.imageList, i)))
                              .then((data) {
                            setState(() {});
                          });
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          selected[i] = selected[i] == true ? false : true;
                          isSelection = true;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(SizeConfig.font_size * 0.7),
                        padding: EdgeInsets.all(SizeConfig.font_size * 0.3),
                        color: isSelection && selected[i] == true
                            ? Colors.orange
                            : Colors.grey[400],
                        child: Image.file(
                          widget.imageList[i],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }),
          ),
          floatingActionButton: _floatingButton(),
        ));
  }

  int max(int x, int y) {
    return x > y ? x : y;
  }

  void mergeImages(int idx1, int idx2,
      {bool light = true, int vp = 20, int hp = 20}) {
    Img.Image im1 = Img.decodeImage(widget.imageList[idx1].readAsBytesSync());
    Img.Image im2 = Img.decodeImage(widget.imageList[idx2].readAsBytesSync());
    int w = max(im1.height, im2.height) + 2 * hp;
    int h = im1.width + im2.width + 3 * vp;
    Img.Image merge = Img.Image(w, h);
    // Fill Background
    light ? merge.fill(0xFFFFFFFF) : merge.fill(0xFF000000);
    for (int i = 0; i < im1.width; i++) {
      for (int j = 0; j < im1.height; j++) {
        merge.setPixel(j + hp, i + vp, im1.getPixel(i, im1.height - j - 1));
      }
    }
    for (int i = 0; i < im2.width; i++) {
      for (int j = 0; j < im2.height; j++) {
        merge.setPixel(j + hp, i + 2 * vp + im1.width,
            im2.getPixel(i, im2.height - j - 1));
      }
    }
    widget.imageList.removeAt(idx2);
    widget.imageList[idx1].writeAsBytesSync(Img.encodeJpg(merge));
    isSelection = false;
    selected = List<bool>(widget.imageList.length);
  }
}
