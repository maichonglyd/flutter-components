import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';

double rpx(double size) {
  return size * PageSize.sizeRatio;
}

class PageSize {
  static final MediaQueryData mediaQueryData =
      MediaQueryData.fromWindow(window);
  static final baseScreenWidth = 750;
  static final sizeRatio = mediaQueryData.size.width / baseScreenWidth;
  static final double statusBarHeight = mediaQueryData.padding.top;
  static final double titleBarHeight = kToolbarHeight;
  static final double width = mediaQueryData.size.width;
  static final double height = mediaQueryData.size.height;
}

/// 显示一个给定宽高的图片
///
/// 可以是网络图片 也可以是本地图片，网络图片需要以http开头
Image image(dynamic img, double width, double height,
    {Color color, BoxFit fit}) {
  if (img is File) {
    return Image.file(img,
        fit: fit ?? BoxFit.fill, width: width, height: height, color: color);
  }

  if (img is String) {
    if (img.startsWith('http')) {
      return Image.network(img,
          fit: fit ?? BoxFit.fill, width: width, height: height, color: color);
    }
    if (img.length > 0) {
      return Image.asset(img,
          fit: fit ?? BoxFit.fill, width: width, height: height, color: color);
    }
  }
  if (img is Uint8List) {
    return Image.memory(img,
        fit: fit ?? BoxFit.fill, width: width, height: height, color: color);
  }
  return Image.asset('images/pic_default.png',
      fit: fit ?? BoxFit.fill, width: width, height: height, color: color);
}

/// 显示一个给定宽高-四个圆角的图片
///
/// 可以是网络图片 也可以是本地图片，网络图片需要以http开头
ClipRRect imageCirc(dynamic img, double width, double height, double radius,
    {Color color, BoxFit fit}) {
  var r = Radius.circular(radius);
  return new ClipRRect(
      child: image(img, width, height, color: color, fit: fit),
      borderRadius: new BorderRadius.all(r));
}

/// 边线宽度和颜色 默认宽度为1，颜色为BorderColor.light
BorderSide borderSide([double width, Color color]) {
  return new BorderSide(width: width ?? rpx(1), color: color ?? Colors.white24);
}

/// 给AppBar加上底边框
PreferredSize appBarBorder(AppBar child, {Color borderColor}) {
  return PreferredSize(
    child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: borderColor ?? Colors.white12))),
        child: child),
    preferredSize: Size.fromHeight(PageSize.titleBarHeight),
  );
}

/// 文本
///
/// * [String] v 内容
/// * [double] fontSize 字号 默认为 Style.fontMedium
/// * [Color] color 颜色 默认为 Style.textDefault
/// * [double] height 行高 默认为 1.0
/// * [bool] blod 粗体 默认为 false
/// * [TextAlign] align 文本对齐方式
/// * [TextOverflow] overflow 溢出；只能决定文字最后是否显示省略号 配合maxLines使用
/// * [int] maxLines 显示最大行数
/// * [bool] deleteline 显示删除线 与underline同时存在时显示删除线
/// * [bool] underline 显示下划线 与deleteline同时存在时显示删除线
Text text(String v,
    {double fontSize,
    Color color,
    double height,
    bool blod = false,
    TextAlign align,
    TextOverflow overflow,
    int maxLines,
    bool deleteline = false,
    bool underline = false}) {
  TextAlign textAlign = align ?? TextAlign.start;

  TextOverflow of = overflow ?? TextOverflow.visible;

  TextDecoration td;
  if (underline) td = TextDecoration.underline;
  if (deleteline) td = TextDecoration.lineThrough;

  return new Text(
    v ?? '',
    textAlign: textAlign,
    overflow: of,
    maxLines: maxLines ?? 100,
    softWrap: true,
    style: new TextStyle(
        height: height,
        decoration: td,
        color: color ?? Colors.black,
        fontSize: fontSize ?? rpx(28),
        fontWeight: blod ? FontWeight.w500 : null),
  );
}
