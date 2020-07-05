import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_extend/share_extend.dart';

class ViewPdf extends StatefulWidget {
  final String documentPath;
  final bool darkPdf, mobileView, spacing;
  ViewPdf({this.documentPath, this.darkPdf, this.mobileView, this.spacing});
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  int currentPage = 0;
  int pageNo = 0, totalPages;

  @override
  void initState() {
    super.initState();
  }

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
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                ShareExtend.share(widget.documentPath, "pdf");
              })
          // Container(
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          //   child: PopupMenuButton(
          //       icon: Icon(Icons.more_vert),
          //       onSelected: (i) {
          //         if (i == 0) {
          //           ShareExtend.share(widget.documentPath, "pdf");
          //         }
          //         // else if (i == 1) {
          //         //   print('Switch to dark pdf');
          //         //   setState(() {
          //         //     darkPdf = !darkPdf;
          //         //   });
          //         // } else if (i == 2) {
          //         //   print('Mobile View');
          //         //   setState(() {
          //         //     mobileView = !mobileView;
          //         //   });
          //         // } else if (i == 3) {
          //         //   print('Spacing');
          //         //   setState(() {
          //         //     spacing = !spacing;
          //         //   });
          //         // }
          //       },
          //       itemBuilder: (context) => [
          //             PopupMenuItem(
          //               value: 0,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: <Widget>[
          //                   Text(
          //                     'Share',
          //                   ),
          //                   Icon(
          //                     Icons.share,
          //                     size: 15,
          //                   )
          //                 ],
          //               ),
          //             ),
          //             PopupMenuItem(
          //                 value: 1,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: <Widget>[
          //                     Text(
          //                       'Dark PDF',
          //                     ),
          //                     Switch(
          //                         value: darkPdf,
          //                         onChanged: (val) {
          //                           darkPdf = val;
          //                           setState(() {});
          //                         })
          //                   ],
          //                 )),
          //             PopupMenuItem(
          //                 value: 2,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: <Widget>[
          //                     Text(
          //                       'Mobile View',
          //                     ),
          //                     Switch(
          //                         value: mobileView,
          //                         onChanged: (val) {
          //                           mobileView = val;
          //                           setState(() {});
          //                         })
          //                   ],
          //                 )),
          //             PopupMenuItem(
          //                 value: 3,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: <Widget>[
          //                     Text(
          //                       'Spacing',
          //                     ),
          //                     Switch(
          //                         value: spacing,
          //                         onChanged: (val) {
          //                           spacing = val;
          //                           setState(() {});
          //                         })
          //                   ],
          //                 )),
          //           ]),
          // )
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: path,
            enableSwipe: true,
            swipeHorizontal: widget.mobileView ?? false,
            autoSpacing: widget.spacing ?? false,
            pageFling: false,
            fitEachPage: false,
            fitPolicy: FitPolicy.BOTH,
            nightMode: widget.darkPdf ?? false,
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
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int page, int total) {
              // print('page change: $page/$total');
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
                totalPages != null ? '${pageNo + 1}/$totalPages' : '',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
