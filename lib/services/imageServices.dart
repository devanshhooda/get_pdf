import 'package:multi_image_picker/multi_image_picker.dart';

class ImageServices {
  Future<List<Asset>> pickImages() async {
    List<Asset> imagesList = List<Asset>();

    try {
      imagesList = await MultiImagePicker.pickImages(
          maxImages: 100,
          selectedAssets: imagesList,
          enableCamera: true,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: 'chat'),
          materialOptions: MaterialOptions(
              actionBarTitle: 'GetPDF', allViewTitle: 'All photos'));
      
      return imagesList;
    } catch (e) {
      print(e);
    }
  }
}
