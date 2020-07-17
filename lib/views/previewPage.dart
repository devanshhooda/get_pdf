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
import '../services/pdfServices.dart';
import 'viewPdf.dart';

class PreviewPage extends StatefulWidget {
  final List<File> imageList;
  PreviewPage({this.imageList});
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
                  })
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
                  return GestureDetector(
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
                  );
                }),
          ),
          floatingActionButton: _floatingButton(),
        ));
  }
}
