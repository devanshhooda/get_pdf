import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get_pdf/utils/sizeConfig.dart';
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
            top: SizeConfig.safeBlockVertical * 5,
            left: SizeConfig.safeBlockHorizontal * 10,
            child: Container(
              padding: EdgeInsets.all(SizeConfig.font_size * 0.7),
              decoration: BoxDecoration(
                  color: widget.spacing == true ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                totalPages != null ? '${pageNo + 1}/$totalPages' : '',
                style: TextStyle(
                    color:
                        widget.spacing == true ? Colors.black : Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
