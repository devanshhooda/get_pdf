import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelection
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
                    setState(() {});
                  },
                )
              ],
            )
          : AppBar(
              backgroundColor: Colors.deepOrangeAccent,
              title: Text(
                'Selected images',
                style: GoogleFonts.cantoraOne(),
              ),
            ),
      body: Container(
        child: GridView.builder(
            itemCount: widget.imageList.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, i) {
              return DragTarget(
                // onWillAccept: (File file) {
                //   return true;
                // },
                // onAccept: (File file) {
                //   widget.imageList.remove(file);
                // },
                builder: (context, incomingData, outgoingData) => Draggable(
                  data: widget.imageList,
                  maxSimultaneousDrags: 1,
                  feedback: Opacity(
                    opacity: 0.7,
                    child: Material(
                      child: Container(
                        height: 200,
                        color: Colors.orange,
                        child: Image.file(
                          widget.imageList[i],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (isSelection) {
                        setState(() {
                          selected[i] = selected[i] == true ? false : true;
                        });
                      } else {
                        // getImageEditor(widget.imageList[i]);
                      }
                    },
                    onDoubleTap: () {
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
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  // contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
        },
        child: Icon(
          Icons.picture_as_pdf,
          color: Colors.white,
        ),
      ),
    );
  }
}
