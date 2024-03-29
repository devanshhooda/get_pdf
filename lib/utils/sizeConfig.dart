import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static double cardRatio = 0.6;
  static double cardWidth;
  static double cardHeight;
  static double remainingWidth;
  static int x, y;

  static double font_size;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    font_size = (safeBlockVertical + safeBlockHorizontal) / 2;

    cardWidth = screenWidth * 0.9;
    cardHeight = cardWidth * cardRatio;
    remainingWidth = (screenWidth - cardWidth) / 2;
    x = remainingWidth.floor();
    y = ((screenHeight - cardHeight) / 2).floor();
  }
}
