import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:get_pdf/services/imageServices.dart';
import 'package:get_pdf/utils/constants.dart';
import 'package:get_pdf/utils/sizeConfig.dart';
import 'package:get_pdf/views/aboutPage.dart';
import 'package:get_pdf/views/cameraScreen.dart';
import 'package:get_pdf/views/previewPage.dart';
import 'package:get_pdf/views/settingsPage.dart';
import 'package:get_pdf/views/viewPdf.dart';
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
  bool isListView;
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

  Widget _appBar() {
    return isSelection
        ? AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
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
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            title: Text(
              "Indocanner",
              style: TextStyle(
                  fontFamily: 'Anton',
                  fontStyle: FontStyle.italic,
                  letterSpacing: 5,
                  fontSize: SizeConfig.font_size * 4),
            ),
            centerTitle: true,
          );
  }

  Widget _floatingButton() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      curve: Curves.easeInSine,
      foregroundColor: Colors.black,
      overlayColor: Colors.orangeAccent,
      overlayOpacity: 0.4,
      children: [
        SpeedDialChild(
          label: 'Take pictures using Camera',
          labelStyle: TextStyle(
              fontSize: SizeConfig.font_size * 2.2, color: Colors.white),
          labelBackgroundColor: Colors.deepOrange,
          child: Icon(Icons.photo_camera),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CameraScreen()))
                .then((images) {
              print(images);
              if (images == null || images.length == 0) return;
              Navigator.of(context)
                  .push(CupertinoPageRoute(
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
        ),
        SpeedDialChild(
          label: 'Import images from Gallery',
          labelStyle: TextStyle(
              fontSize: SizeConfig.font_size * 2.2, color: Colors.white),
          labelBackgroundColor: Colors.deepOrange,
          child: Icon(Icons.add_photo_alternate),
          onTap: () async {
            await imageServices.pickImages().then((imagesList) {
              print(imagesList);
              if (imagesList != null && imagesList.isNotEmpty) {
                setState(() {
                  images = imagesList;
                });
                Navigator.of(context)
                    .push(CupertinoPageRoute(
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
        ),
      ],
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 15,
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(''),
                    accountEmail: Text(''),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/indocanner-logo.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Dark mode',
                          style: TextStyle(
                              fontFamily: 'MedriendaOne',
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.font_size * 3)),
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
                  // drawerButton(buttonName: 'Share App', icon: Icons.share),
                  // drawerButton(buttonName: 'Rate App', icon: Icons.star),
                  drawerButton(buttonName: 'About Us', icon: Icons.info),
                ],
              ),
            ),
            Expanded(flex: 1, child: Text('Version : 1.0.0'))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        if (isSelection) {
          isSelection = false;
          selected = List<bool>(files.length);
          setState(() {});
          return;
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return;
        }
      },
      child: Scaffold(
        appBar: _appBar(),
        drawer: _drawer(),
        body: Center(
          child: filesPresent
              ? Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.safeBlockHorizontal * 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Your files :',
                                  style: TextStyle(
                                      fontFamily: 'MedriendaOne',
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig.font_size * 2.7)),
                              FlatButton(
                                  onPressed: () {
                                    isListView = !isListView;
                                    prefs.setBool("isListView", isListView);
                                  },
                                  child: Row(
                                    children: isListView
                                        ? <Widget>[
                                            Text('Grid View'),
                                            Icon(Icons.view_module)
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
        floatingActionButton: _floatingButton(),
      ),
    );
  }

  gridViewContent(int i) {
    var docThumbnail =
        Image.file(handler.thumbPath(files[i].path), fit: BoxFit.fill);
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.all(SizeConfig.font_size * 1),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 4,
              vertical: SizeConfig.safeBlockVertical * 1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.purpleAccent[700]],
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft)),
          child: GridTile(
              header: isSelection && selected[i] == true
                  ? Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 25),
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        radius: SizeConfig.font_size * 3.5,
                        child: Icon(Icons.done),
                      ),
                    )
                  : Container(
                      height: SizeConfig.safeBlockVertical * 16,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                              image: docThumbnail == null
                                  ? AssetImage('assets/fileIcon.png')
                                  : docThumbnail.image)),
                    ),
              footer: Text(
                '${files[i].path.split('/').removeLast()}',
                style: TextStyle(
                    color: Colors.white, fontSize: SizeConfig.font_size * 2.5),
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
          navigate2view(filePath);
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
    var docThumbnail = Image.file(
      handler.thumbPath(files[i].path),
      fit: BoxFit.fill,
    );
    return Container(
      margin: EdgeInsets.all(SizeConfig.font_size * 1),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 2,
          vertical: SizeConfig.safeBlockVertical * 1.5),
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
                radius: SizeConfig.font_size * 3.5,
                child: Icon(Icons.done),
                backgroundColor: Colors.black,
              )
            : CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: SizeConfig.font_size * 3.5,
                backgroundImage: docThumbnail == null
                    ? AssetImage('assets/fileIcon.png')
                    : docThumbnail.image,
              ),
        title: Text(
          '${files[i].path.split('/').removeLast()}',
          style: TextStyle(
              color: Colors.white, fontSize: SizeConfig.font_size * 2.7),
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
            navigate2view(filePath);
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
      height: SizeConfig.blockSizeVertical * 7,
      margin: EdgeInsets.only(
          top: SizeConfig.safeBlockVertical * 1,
          right: SizeConfig.safeBlockHorizontal * 3),
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
          } else if (buttonName == 'About Us') {
            Navigator.of(context)
                .push(CupertinoPageRoute(builder: (context) => AboutPage()));
          }
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('$buttonName',
                  style: TextStyle(
                    fontSize: SizeConfig.font_size * 3,
                    fontFamily: 'MedriendaOne',
                  )),
              Icon(
                icon,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigate2view(String filePath) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    bool darkPdf = prefs.getBool(Constants.darkPdf) ?? false;
    bool mobileView = prefs.getBool(Constants.mobileView) ?? false;
    bool spacing = prefs.getBool(Constants.autoSpacing) ?? true;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ViewPdf(
              documentPath: filePath,
              darkPdf: darkPdf,
              mobileView: mobileView,
              spacing: spacing,
            )));
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
      if (value == false) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return;
      }
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
    isListView = prefs.getBool("isListView") ?? false;
    setState(() {});
  }
}
