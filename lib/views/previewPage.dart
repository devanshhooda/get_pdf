import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_pdf/services/imageServices.dart';
import 'package:get_pdf/views/cameraScreen.dart';
import 'package:get_pdf/views/editorPage.dart';
import 'package:google_fonts/google_fonts.dart';
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
            backgroundColor: Colors.deepOrangeAccent,
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
            backgroundColor: Colors.deepOrangeAccent,
            title: Text(
              'Selected images',
              style: GoogleFonts.amaranth(),
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
                              children: <Widget>[
                                Text('Preparing document, please wait   '),
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        });
                    String filename =
                        await pdfServices.createPdfFromImages(widget.imageList);
                    Navigator.of(context).pop();
                    if (filename == null) return;
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ViewPdf(
                                  documentPath: filename,
                                )))
                        .then((value) => Navigator.of(context).pop());
                  })
            ],
          );
  }

  Widget _floatingButton() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      curve: Curves.easeInSine,
      backgroundColor: Colors.deepOrange,
      overlayColor: Colors.orangeAccent,
      overlayOpacity: 0.4,
      children: [
        SpeedDialChild(
          label: 'Take pictures using Camera',
          labelStyle: TextStyle(fontSize: 15, color: Colors.white),
          labelBackgroundColor: Colors.deepOrange,
          child: Icon(Icons.photo_camera),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CameraScreen()))
                .then((images) {
              widget.imageList.addAll(images);
              setState(() {});
            });
          },
        ),
        SpeedDialChild(
          label: 'Import images from Gallery',
          labelStyle: TextStyle(fontSize: 15, color: Colors.white),
          labelBackgroundColor: Colors.deepOrange,
          child: Icon(Icons.add_photo_alternate),
          onTap: () async {
            await ImageServices().pickImages().then((images) {
              widget.imageList.addAll(images);
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
                                    EditImage(widget.imageList[i])))
                            .then((imageFile) {
                          if (imageFile != null) {
                            widget.imageList
                                .replaceRange(i, i + 1, [imageFile]);
                            setState(() {});
                          }
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
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(2),
                      color: isSelection && selected[i] == true
                          ? Colors.orange
                          : Colors.white,
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
