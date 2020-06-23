import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:get_pdf/services/imageServices.dart';
import 'package:get_pdf/views/cameraScreen.dart';
import 'package:get_pdf/views/previewPage.dart';
import 'package:get_pdf/views/settingsPage.dart';
import 'package:get_pdf/views/viewPdf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_extend/share_extend.dart';

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
  List<bool> selected = [];
  bool isSelection = false;

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
      appBar: isSelection
          ? AppBar(
              backgroundColor: Colors.deepOrangeAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selected = List<bool>(files.length);
                    isSelection = false;
                  });
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete selected files ?'),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    deleteFiles();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Yes')),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No'))
                            ],
                          );
                        });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    List<String> paths = [];
                    for (int i = 0; i < selected.length; i++) {
                      if (selected[i] == true) {
                        paths.add(files[i].path);
                      }
                    }
                    ShareExtend.shareMultiple(paths, "pdf");
                    setState(() {
                      isSelection = false;
                      selected = List<bool>(files.length);
                    });
                  },
                )
              ],
            )
          : AppBar(
              backgroundColor: Colors.deepOrangeAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Text(
                "Get PDF",
                style:
                    GoogleFonts.righteous(textStyle: TextStyle(fontSize: 30)),
              ),
              centerTitle: true,
            ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 15,
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Get PDF',
                          style: GoogleFonts.righteous(
                              textStyle: TextStyle(fontSize: 30)),
                        ),
                      ),
                      accountEmail: Text(
                        'Convert your images into PDF',
                        style: GoogleFonts.sofadiOne(),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: AssetImage('assets/appIcon.jpg'),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.red, Colors.yellow],
                              begin: Alignment.topLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40))),
                    ),
                    drawerButton(buttonName: 'Settings', icon: Icons.settings),
                    drawerButton(buttonName: 'Share App', icon: Icons.share),
                    drawerButton(buttonName: 'Rate App', icon: Icons.star),
                    drawerButton(buttonName: 'About Us', icon: Icons.info),
                  ],
                ),
              ),
              Expanded(flex: 1, child: Text('Version : 1.0.0'))
            ],
          ),
        ),
      ),
      body: Center(
        child: filesPresent
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: 270, top: 10, bottom: 10),
                        child: Text(
                          'Your files :',
                          style: GoogleFonts.amaranth(
                              textStyle: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, i) {
                            return homePageContent(i);
                          }),
                    ),
                  ],
                ),
              )
            : Text(
                'No history',
                style: TextStyle(color: Colors.white),
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: FloatingActionButton(
              backgroundColor: Colors.deepOrange,
              heroTag: "gallery",
              onPressed: () async {
                await imageServices.pickImages().then((imagesList) {
                  print(imagesList);
                  if (imagesList != null && imagesList.isNotEmpty) {
                    setState(() {
                      images = imagesList;
                    });
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => PreviewPage(
                                  imageList: images,
                                )))
                        .then((_) {
                      setState(() {
                        files = handler.allFiles();
                        if (files != null && files.isNotEmpty) {
                          selected = List<bool>(files.length);
                          filesPresent = true;
                        }
                      });
                    });
                  }
                });
              },
              child: Icon(
                Icons.add_photo_alternate,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: FloatingActionButton(
              backgroundColor: Colors.deepOrange,
              heroTag: "camera",
              onPressed: () {
                Navigator.of(context)
                    .push(
                        MaterialPageRoute(builder: (context) => CameraScreen()))
                    .then((images) {
                  print(images);
                  if (images.length == 0) return;
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => PreviewPage(imageList: images)))
                      .then((_) {
                    setState(() {
                      files = handler.allFiles();
                      if (files != null && files.isNotEmpty) {
                        selected = List<bool>(files.length);
                        filesPresent = true;
                      }
                    });
                  });
                });
              },
              child: Icon(
                Icons.photo_camera,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  homePageContent(int i) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              colors: [Colors.red, Colors.orangeAccent],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Column(
        children: <Widget>[
          ListTile(
            selected:
                selected[i] != null ? (selected[i] ? true : false) : false,
            leading: isSelection && selected[i] == true
                ? CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.done),
                  )
                : CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/fileIcon.png'),
                  ),
            title: Text(
              '${files[i].basename}',
              style: GoogleFonts.philosopher(
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            onTap: () {
              if (isSelection) {
                setState(() {
                  selected[i] = selected[i] == true ? false : true;
                  if (selected.isEmpty) {
                    isSelection = false;
                  }
                });
              } else {
                String filePath = files[i].path;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewPdf(
                          documentPath: filePath,
                        )));
              }
            },
            onLongPress: () {
              setState(() {
                if (isSelection) {
                  selected[i] = selected[i] == true ? false : true;
                } else {
                  isSelection = true;
                  selected[i] = selected[i] == true ? false : true;
                }
              });
            },
          ),
          // Divider()
        ],
      ),
    );
  }

  Widget drawerButton({String buttonName, IconData icon}) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(
        top: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.cyanAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), bottomRight: Radius.circular(40))),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {
          if (buttonName == 'Settings') {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SettingsPage()));
          }
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '$buttonName',
                style:
                    GoogleFonts.cantoraOne(textStyle: TextStyle(fontSize: 17)),
              ),
              Icon(
                icon,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteFiles() async {
    for (int i = 0; i < selected.length; i++) {
      if (selected[i] == true) {
        handler.deleteFile(files[i]);
      }
    }
    setState(() {
      files = handler.allFiles();
      if (files != null && files.isNotEmpty) {
        selected = List<bool>(files.length);
        filesPresent = true;
      }
      isSelection = false;
    });
  }

  initFileSystem() async {
    await handler.initSystem().then((value) {
      setState(() {
        files = handler.allFiles();
        if (files != null && files.isNotEmpty) {
          selected = List<bool>(files.length);
          filesPresent = true;
        }
      });
    });
  }
}
