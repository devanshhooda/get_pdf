import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:image_editor/image_editor.dart';

class EditImage extends StatefulWidget {
  final File image;
  EditImage(this.image);
  EditImageState createState() => EditImageState();
}

class EditImageState extends State<EditImage> {
  FileHandling _fileHandling = FileHandling();
  Uint8List imageData;

  @override
  void initState() {
    //editorOption.addOption(ClipOption(x: 0, y: 0, width: 750, height: 300));
    //editorOption.outputFormat = OutputFormat.png(88);
    _fileHandling.initSystem();
    imageData = widget.image.readAsBytesSync();
    super.initState();
  }

  Widget _bottomBar() {
    return Container(
      height: 46,
      color: Colors.black54,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: revertChanges,
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 16, top: 2, bottom: 2),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.autorenew,
                    color: Colors.white,
                  ),
                  Text(
                    'Revert Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container(height: 1)),
          GestureDetector(
            onTap: () {
              final ImageEditorOption editOption = ImageEditorOption();
              editOption.addOption(RotateOption(-90));
              doEditing(editOption);
            },
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 16, top: 2, bottom: 2),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.rotate_left,
                    color: Colors.white,
                  ),
                  Text(
                    'Rotate Left',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container(height: 1)),
          GestureDetector(
            onTap: () {
              final ImageEditorOption editOption = ImageEditorOption();
              editOption
                  .addOption(FlipOption(horizontal: true, vertical: false));
              doEditing(editOption);
            },
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 16, top: 2, bottom: 2),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.flip,
                    color: Colors.white,
                  ),
                  Text(
                    'Flip',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container(height: 1)),
          GestureDetector(
            onTap: () {
              final ImageEditorOption editOption = ImageEditorOption();
              editOption.addOption(RotateOption(90));
              doEditing(editOption);
            },
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 16, top: 2, bottom: 2),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.rotate_right,
                    color: Colors.white,
                  ),
                  Text(
                    'Rotate Right',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container(height: 1)),
          GestureDetector(
            onTap: () async {
              File imageFile = await saveImage();
              Navigator.of(context).pop(imageFile);
            },
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 16, top: 2, bottom: 2),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.done_all,
                    color: Colors.white,
                  ),
                  Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    });
  }

  Future<File> saveImage() async {
    File imageFile = _fileHandling.getTempFile(
        name: DateTime.now().millisecondsSinceEpoch.toString() + '.png');
    imageFile.writeAsBytesSync(imageData);
    return imageFile;
  }
}
