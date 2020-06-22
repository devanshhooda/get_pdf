import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:get_pdf/services/imageServices.dart';
import 'package:get_pdf/views/cameraScreen.dart';
import 'package:get_pdf/views/previewPage.dart';
import 'package:get_pdf/views/viewPdf.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ImageServices imageServices;
  FileHandling handler;
  List<File> images;
  bool filesPresent;
  var files;

  @override
  void initState() {
    imageServices = ImageServices();
    handler = FileHandling();
    initFileSystem();
    filesPresent = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get PDF'),
      ),
      body: Center(
        child: filesPresent
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, i) {
                      return homePageContent(i);
                    }),
              )
            : Text(
                'No data',
                style: TextStyle(color: Colors.white),
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: FloatingActionButton(
              heroTag: "gallery",
              onPressed: () async {
                await imageServices.pickImages().then((imagesList) {
                  print(imagesList);
                  if (imagesList != null && imagesList.isNotEmpty) {
                    setState(() {
                      images = imagesList;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PreviewPage(
                        imageList: images,
                    ))).then((_) {
                      print('pop from gallery ......');
                      setState(() {
                        files = handler.allFiles();
                        if (files != null && files.isNotEmpty) {
                          filesPresent = true;
                        }
                      });
                    });
                  }
                });
              },
              child: Icon(Icons.add_photo_alternate),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: FloatingActionButton(
              heroTag: "camera",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CameraScreen()
                )).then((images) {
                  print(images);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PreviewPage(imageList: images)
                  )).then((_) {
                    print('pop from camera ......');
                    setState(() {
                      files = handler.allFiles();
                      if (files != null && files.isNotEmpty) {
                        filesPresent = true;
                      }
                    });
                  });
                });
              },
              child: Icon(Icons.photo_camera),
            ),
          ),
        ],
      ),
    );
  }

  homePageContent(int i) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.redAccent),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${files[i].basename}'),
            subtitle: Text('${files[i].dirname}'),
            onTap: () {
              String filePath = files[i].path;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewPdf(
                        documentPath: filePath,
                      )));
            },
          ),
          Divider()
        ],
      ),
    );
  }

  initFileSystem() async {
    await handler.initSystem().then((value) {
      setState(() {
        files = handler.allFiles();
        if (files != null && files.isNotEmpty) {
          filesPresent = true;
        }
      });
    });
  }
}
