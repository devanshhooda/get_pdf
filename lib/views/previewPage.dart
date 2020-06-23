import 'dart:io';

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

  @override
  void initState() {
    selected = List<bool> (widget.imageList.length);
    isSelection = false;
    pdfServices = PdfServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelection ? AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            isSelection = false;
            selected = List<bool> (widget.imageList.length);
            setState(() {});
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              int k = 0;
              for (int i=0; i<selected.length; i++) {
                if (selected[i] == true) {
                  widget.imageList.removeAt(i + k);
                  k--;
                }
              }
              isSelection = false;
              selected = List<bool> (widget.imageList.length);
              setState(() {});
            },
          )
        ],
      ) : AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'Preview',
          style: GoogleFonts.cantoraOne(),
        ),
      ),
      body: Container(
        child: GridView.builder(
            itemCount: widget.imageList.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  if (isSelection) {
                    setState(() {
                      selected[i] = selected[i] == true ? false : true;
                    });
                  } else {
                    print('Editing image process to be done');
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
                  color: isSelection && selected[i] == true ? Colors.orange : Colors.white,
                  child: Image.file(
                    widget.imageList[i],
                    fit: BoxFit.contain,
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
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              });
          String filename =
              await pdfServices.createPdfFromImages(widget.imageList);
          Navigator.of(context).pop();
          if (filename == null) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewPdf(
                documentPath: filename,
              )
            )
          ).then((value) => Navigator.of(context).pop());
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
