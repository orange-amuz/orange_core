import 'dart:math' as math;

import 'package:flutter/material.dart';

class ScreenUtil {
  static late double pixelRatio;
  static late Size physicalScreenSize;

  /// 디자인 높이 (스크린 전체 높이 - 상태바 높이)
  static late final double designedHeight;

  /// 디자인 너비
  static late final double designedWidth;

  /// 상태바 높이
  static late double paddingTop;

  /// 스크린 아래쪽 SafeArea 높이
  static late double paddingBottom;

  /// 스크린 높이
  static late double screenHeight;

  /// 스크린 너비
  static late double screenWidth;

  /// 앱 높이 (스크린 높이 - 상태바 높이)
  static late double appHeight;

  /// 앱 너비 (스크린 너비)
  static late double appWidth;

  /// 화면에 보여질 최대 너비
  static late final double maxWidth;

  /// Navigation의 화면에 보여질 최대 너비
  static late final double maxNavigationWidth;

  //----------------------------------------------------------------------------

  static bool _isInit = false;

  static void initialize(
    BuildContext context, {
    required double designedHeight,
    required double designedWidth,
    double maxWidth = 500,
    double maxNavigationWidth = 450,
  }) {
    assert(!_isInit, 'call initialize only once.');

    pixelRatio = MediaQuery.of(context).devicePixelRatio;
    physicalScreenSize = MediaQuery.of(context).size;

    ScreenUtil.designedHeight = designedHeight;
    ScreenUtil.designedWidth = designedWidth;

    ScreenUtil.maxWidth = maxWidth;
    ScreenUtil.maxNavigationWidth = maxNavigationWidth;

    _isInit = true;

    updateScreenValues(context);
  }

  static void _checkInit() {
    assert(_isInit, 'Do initialize before call another method');
  }

  static bool isInitialize() {
    return _isInit;
  }

  //----------------------------------------------------------------------------

  static void updateScreenValues(BuildContext context) {
    _checkInit();

    /// update screenHeight
    screenHeight = MediaQuery.of(context).size.height;

    /// update screenWidth
    screenWidth = MediaQuery.of(context).size.width;

    /// update appHeight
    appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    /// update appWidth
    if (MediaQuery.of(context).size.width -
            MediaQuery.of(context).padding.horizontal >
        maxWidth) {
      appWidth = maxWidth;
    } else {
      appWidth = MediaQuery.of(context).size.width -
          MediaQuery.of(context).padding.horizontal;
    }

    /// update padding top
    paddingTop = MediaQuery.of(context).padding.top;

    /// update padding bottom
    paddingBottom = MediaQuery.of(context).padding.bottom;
  }

  //----------------------------------------------------------------------------

  static double getHeightRatio(double height) {
    _checkInit();

    return height / designedHeight;
  }

  static double getWidthRatio(double width) {
    _checkInit();

    return width / designedWidth;
  }

  //----------------------------------------------------------------------------

  static double getHeight(double height) {
    _checkInit();

    return math.max(height / designedHeight * appHeight, height);
  }

  static double getWidth(double width) {
    _checkInit();

    return math.max(width / designedWidth * appWidth, width);
  }
}
