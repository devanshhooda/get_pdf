import 'package:flutter/material.dart';
import 'package:get_pdf/services/fileServices.dart';
import 'package:get_pdf/services/imageServices.dart';
import 'package:get_pdf/views/viewPdf.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FileServices fileServices;
  ImageServices imageServices;
  List<Asset> images;
  @override
  void initState() {
    fileServices = FileServices();
    imageServices = ImageServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get PDF'),
      ),
      body: Center(
          child: images == null
              ? RaisedButton(
                  onPressed: () async {
                    await imageServices.pickImages().then((imagesList) {
                      setState(() {
                        images = imagesList;
                      });
                    });
                  },
                  child: Text('Get images'),
                )
              : ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, i) {
                    return homePageContent(i);
                  })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await fileServices.createFile();
          } catch (e) {
            print(e);
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ViewPdf(
                    documentPath: fileServices.fileName,
                  )));
        },
        child: Icon(Icons.add),
      ),
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
