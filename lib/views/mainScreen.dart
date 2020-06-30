import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:get_pdf/services/imageServices.dart';
import 'package:get_pdf/utils/colors.dart';
import 'package:get_pdf/views/cameraScreen.dart';
import 'package:get_pdf/views/previewPage.dart';
import 'package:get_pdf/views/settingsPage.dart';
import 'package:get_pdf/views/viewPdf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ImageServices imageServices;
  FileHandling handler;
  List<File> images;
  bool filesPresent;
  List<FileSystemEntity> files;
  List<bool> selected = [];
  bool isSelection = false;
  bool isDark;
  bool isListView = false;
  SharedPreferences prefs;

  @override
  void initState() {
    imageServices = ImageServices();
    handler = FileHandling();
    initFileSystem();
    initSP();
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
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      topLeft: Radius.circular(25))),
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
                "Indocanner",
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
                          'Indocanner',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Dark mode',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Switch(
                            value: isDark,
                            onChanged: (val) async {
                              isDark = val;
                              await prefs.setBool("isDark", isDark);
                              context.findAncestorStateOfType().setState(() {});
                            })
                      ],
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
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Your files :',
                              style: GoogleFonts.amaranth(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            FlatButton(
                                onPressed: () {
                                  isListView = !isListView;
                                },
                                child: Row(
                                  children: isListView
                                      ? <Widget>[
                                          Text('Grid View'),
                                          Icon(Icons.grid_on)
                                        ]
                                      : <Widget>[
                                          Text('List View'),
                                          Icon(Icons.list)
                                        ],
                                ))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: isListView
                          ? ListView.builder(
                              itemCount: files.length,
                              itemBuilder: (context, i) {
                                return listViewContent(i);
                              })
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemCount: files.length,
                              itemBuilder: (context, i) {
                                return gridViewContent(i);
                              }),
                    ),
                  ],
                ),
              )
            : Text(
                'You have no saved files',
                style: TextStyle(color: Colors.grey),
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => PreviewPage(
                                  imageList: images,
                                )))
                        .then((_) {
                      setState(() {
                        files = handler.allFiles();
                        files.sort((a, b) => b.path.compareTo(a.path));
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
                // color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: FloatingActionButton(
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
                      files.sort((a, b) => b.path.compareTo(a.path));
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
                // color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  gridViewContent(int i) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.purpleAccent[700]],
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft)),
          child: GridTile(
              header: isSelection && selected[i] == true
                  ? Padding(
                      padding: EdgeInsets.only(right: 100),
                      child: CircleAvatar(
                        backgroundColor: Colors.purpleAccent,
                        radius: 25,
                        child: Icon(Icons.done),
                      ),
                    )
                  : null,
              footer: Text(
                '${files[i].path.split('/').removeLast()}',
                style: GoogleFonts.philosopher(
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ),
              child: Text(''))),
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
          isSelection = true;
          selected[i] = selected[i] == true ? false : true;
        });
      },
    );
  }

  listViewContent(int i) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.purpleAccent[700]],
              end: Alignment.bottomRight,
              begin: Alignment.topLeft)),
      child: ListTile(
        selected: selected[i] != null ? (selected[i] ? true : false) : false,
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
          '${files[i].path.split('/').removeLast()}',
          style: GoogleFonts.philosopher(
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
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
            isSelection = true;
            selected[i] = selected[i] == true ? false : true;
          });
        },
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
                .push(CupertinoPageRoute(builder: (context) => SettingsPage()));
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
      files.sort((a, b) => b.path.compareTo(a.path));
      if (files != null && files.isNotEmpty) {
        selected = List<bool>(files.length);
        filesPresent = true;
      }
      isSelection = false;
    });
  }

  initFileSystem() async {
    await handler.initSystem().then((value) {
      handler.deleteTemp();
      setState(() {
        files = handler.allFiles();
        files.sort((a, b) => b.path.compareTo(a.path));
        if (files != null && files.isNotEmpty) {
          selected = List<bool>(files.length);
          filesPresent = true;
        }
      });
    });
  }

  initSP() async {
    prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("isDark") ?? true;
    setState(() {});
  }
}
