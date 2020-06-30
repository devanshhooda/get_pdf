import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_extend/share_extend.dart';

class ViewPdf extends StatefulWidget {
  final String documentPath;
  ViewPdf({this.documentPath});
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  int currentPage = 0;
  bool darkPdf = false;
  bool mobileView = false;
  bool spacing = false;
  int pageNo = 0, totalPages;

  @override
  Widget build(BuildContext context) {
    String path = widget.documentPath;
    String fileName = path.split('/').removeLast();
    final Completer<PDFViewController> _controller =
        Completer<PDFViewController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          '$fileName',
          style: GoogleFonts.cantoraOne(),
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (i) {
                  if (i == 0) {
                    ShareExtend.share(widget.documentPath, "pdf");
                  }
                  //  else if (i == 1) {
                  //   setState(() {
                  //     darkPdf = !darkPdf;
                  //   });
                  // }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Share',
                              // style: TextStyle(fontSize: 20),
                            ),
                            Icon(
                              Icons.share,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                          value: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Dark PDF',
                              ),
                              Switch(
                                  value: darkPdf,
                                  onChanged: (val) {
                                    darkPdf = val;
                                    // setState(() {});
                                    context.findAncestorStateOfType().setState(() {});
                                  })
                            ],
                          )),
                      PopupMenuItem(
                          value: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Mobile View',
                              ),
                              Switch(
                                  value: mobileView,
                                  onChanged: (val) {
                                    mobileView = val;
                                    setState(() {});
                                  })
                            ],
                          )),
                      PopupMenuItem(
                          value: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Spacing',
                              ),
                              Switch(
                                  value: spacing,
                                  onChanged: (val) {
                                    spacing = val;
                                    setState(() {});
                                  })
                            ],
                          )),
                    ]),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: path,
            enableSwipe: true,
            swipeHorizontal: mobileView,
            autoSpacing: true,
            pageFling: false,
            fitEachPage: false,
            fitPolicy: FitPolicy.BOTH,
            nightMode: darkPdf,
            onRender: (_pages) {
              setState(() {
                totalPages = _pages;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              // _controller.complete(pdfViewController);
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                pageNo = page;
                totalPages = total;
              });
            },
          ),
          Positioned(
            top: 35,
            left: 35,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Text(
                '$pageNo/$totalPages',
                style: TextStyle(
                  color: Colors.black,
                  // backgroundColor: Colors.white
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // PopupMenuItem popUpButton(String buttonName, IconData iconData) {
  //   return
  // }
}
