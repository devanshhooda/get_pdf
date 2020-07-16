import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:get_pdf/utils/sizeConfig.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_editor/image_editor.dart';

class EditImage extends StatefulWidget {
  final List<File> images;
  final int index;
  EditImage(this.images, this.index);
  EditImageState createState() => EditImageState();
}

class EditImageState extends State<EditImage> {
  FileHandling _fileHandling = FileHandling();
  List<File> imageList;
  Uint8List imageData;
  int idx;
  bool changed = false;
  bool changedAny = false;
  PageController controller;

  @override
  void initState() {
    // editorOption.addOption(ClipOption(x: 0, y: 0, width: 750, height: 300));
    // editorOption.outputFormat = OutputFormat.png(88);
    _fileHandling.initSystem();
    idx = widget.index;
    imageList = List<File>();
    widget.images.forEach((file) {
      imageList.add(File(file.path));
    });
    imageData = widget.images[idx].readAsBytesSync();
    controller = PageController(
      initialPage: idx,
    );
    super.initState();
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Edit image',
        style: GoogleFonts.amaranth(),
      ),
      actions: <Widget>[
        MaterialButton(
            child: Text('Done'),
            onPressed: () {
              if (changedAny) {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text('Save changes ?'),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () async {
                              if (changed) {
                                File imageFile = await saveImage();
                                imageList
                                    .replaceRange(idx, idx + 1, [imageFile]);
                              }
                              Navigator.of(context).pop();
                              widget.images
                                  .replaceRange(0, imageList.length, imageList);
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes')),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No')),
                      ],
                    ));
              } else {
                Navigator.of(context).pop();
              }
            }),
      ],
    );
  }

  Widget _bottomBar() {
    return Container(
      height: SizeConfig.blockSizeVertical * 5,
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _editButton(Icons.settings_backup_restore, 0),
          _editButton(Icons.flip, 3),
          _editButton(Icons.swap_vert, 4),
          _editButton(Icons.crop_rotate, 5),
          _editButton(Icons.rotate_left, 1),
          _editButton(Icons.rotate_right, 2),
        ],
      ),
    );
  }

  Widget _editButton(IconData iconData, int i) {
    return IconButton(
        icon: Icon(iconData),
        iconSize: SizeConfig.font_size * 4.5,
        color: Colors.orange,
        onPressed: () async {
          changed = true;
          changedAny = true;
          if (i == 0) {
            revertChanges();
          } else if (i == 1) {
            final ImageEditorOption editOption = ImageEditorOption();
            editOption.addOption(RotateOption(-90));
            doEditing(editOption);
          } else if (i == 2) {
            final ImageEditorOption editOption = ImageEditorOption();
            editOption.addOption(RotateOption(90));
            doEditing(editOption);
          } else if (i == 3) {
            final ImageEditorOption editOption = ImageEditorOption();
            editOption.addOption(FlipOption(horizontal: true, vertical: false));
            doEditing(editOption);
          } else if (i == 4) {
            final ImageEditorOption editOption = ImageEditorOption();
            editOption.addOption(FlipOption(horizontal: false, vertical: true));
            doEditing(editOption);
          } else if (i == 5) {
            File croppedImage = await ImageCropper.cropImage(
                sourcePath: imageList[idx].path,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ],
                androidUiSettings: AndroidUiSettings(
                    toolbarTitle: 'Crop',
                    toolbarColor: Colors.deepOrange,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.original,
                    lockAspectRatio: false),
                iosUiSettings: IOSUiSettings(
                  minimumAspectRatio: 1.0,
                ));
            if (croppedImage != null)
              imageData = croppedImage.readAsBytesSync();
          }
        });
  }

  List<Widget> pageChildren() {
    List<Widget> child = [];
    for (int i = 0; i < imageList.length; i++) {
      child.add(i == idx ? Image.memory(imageData) : Image.file(imageList[i]));
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Center(
        child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) {
            print(value);
            if (changed) {
              saveImage().then((file) {
                imageList.replaceRange(idx, idx + 1, [file]);
                idx = value;
                revertChanges();
              });
            } else {
              idx = value;
              revertChanges();
            }
          },
          children: pageChildren(),
        ),
      ),
      // bottomSheet: _bottomBar(),
      bottomNavigationBar: _bottomBar(),
    );
  }

  void doEditing(ImageEditorOption editOption) async {
    final result = await ImageEditor.editImage(
        image: imageData, imageEditorOption: editOption);
    setState(() {
      imageData = result;
    });
  }

  void revertChanges() {
    setState(() {
      imageData = imageList[idx].readAsBytesSync();
      changed = false;
    });
  }

  Future<File> saveImage() async {
    File imageFile = _fileHandling.getTempFile(
        name: DateTime.now().millisecondsSinceEpoch.toString() + '.png');
    imageFile.writeAsBytesSync(imageData);
    return imageFile;
  }
}
