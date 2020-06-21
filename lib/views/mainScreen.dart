import 'package:flutter/material.dart';
import 'package:get_pdf/services/pdfServices.dart';
import 'package:get_pdf/services/imageServices.dart';
import 'package:get_pdf/views/viewPdf.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PdfServices pdfServices;
  ImageServices imageServices;
  List<Asset> images;
  bool selected;
  @override
  void initState() {
    pdfServices = PdfServices();
    imageServices = ImageServices();
    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Get PDF'), actions: <Widget>[
        selected ? IconButton(
          icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                selected = false;
                images = null;
              });
            }
          ) : IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () async {
              await imageServices.pickImages().then((imagesList) {
                if (imagesList != null && imagesList.isNotEmpty) {
                  setState(() {
                    images = imagesList;
                    selected = true;
                  });
                }
              });
            }
          ),
      ]),
      body: Center(
          child: images == null
              ? Text(
                  'No data',
                  style: TextStyle(color: Colors.white),
                )
              : ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, i) {
                    return homePageContent(i);
                  })),
      floatingActionButton: selected
          ?
          // ? FloatingActionButton(
          //     onPressed: () {
          //       print('editing');
          //     },
          //     child: Icon(Icons.edit),
          //   )
          // :
          FloatingActionButton(
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
                String filename = await pdfServices.createPdfFromImages(images);
                Navigator.of(context).pop();
                if (filename == null) return ;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewPdf(
                    documentPath: filename,
                )));
              },
              child: Icon(Icons.save_alt),
            )
          : null,
    );
  }

  homePageContent(int i) {
    return Column(
      children: <Widget>[
        AssetThumb(
            asset: images[i],
            width: images[i].originalWidth,
            height: images[i].originalHeight),
        Divider()
      ],
    );
  }
}
