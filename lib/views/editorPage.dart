import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_editor/image_editor.dart';

class EditImage extends StatefulWidget {
  final File image;
  EditImage(this.image);
  EditImageState createState() => EditImageState();
}

class EditImageState extends State<EditImage> {
  FileHandling _fileHandling = FileHandling();
  Uint8List imageData;
  bool changed = false;

  @override
  void initState() {
    //editorOption.addOption(ClipOption(x: 0, y: 0, width: 750, height: 300));
    //editorOption.outputFormat = OutputFormat.png(88);
    _fileHandling.initSystem();
    imageData = widget.image.readAsBytesSync();
    super.initState();
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      title: Text('Edit image'),
      actions: <Widget>[
        // editButton(Icons.crop_rotate, 5),
        MaterialButton(
            child: Text('Done'),
            onPressed: () {
              if (changed) {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text('Save changes ?'),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () async {
                              File imageFile = await saveImage();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop(imageFile);
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
      height: 50,
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          editButton(Icons.settings_backup_restore, 0),
          editButton(Icons.flip, 3),
          editButton(Icons.swap_vert, 4),
          editButton(Icons.crop_rotate, 5),
          editButton(Icons.rotate_left, 1),
          editButton(Icons.rotate_right, 2),
        ],
      ),
    );
  }

  Widget editButton(IconData iconData, int i) {
    return IconButton(
        icon: Icon(iconData),
        iconSize: 30,
        color: Colors.orange,
        onPressed: () async {
          changed = true;
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
                sourcePath: widget.image.path,
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
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Center(
          child: imageData == null ? Container() : Image.memory(imageData)),
      bottomSheet: _bottomBar(),
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
      imageData = widget.image.readAsBytesSync();
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
