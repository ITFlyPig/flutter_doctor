import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 加载本地资源图片
Widget loadAssetImage(String name, {double width, double height, BoxFit fit}) {
  return Image.asset(
    getImgPath(name),
    height: height,
    width: width,
    fit: fit,
  );
}

///// 加载网络图片
//Widget loadNetworkImage(String imageUrl,
//    {String placeholder = "icon_loading",
//    String error = "icon_load_fail",
//    double width,
//    double height,
//    BoxFit fit: BoxFit.fill}) {
//  return CachedNetworkImage(
//    imageUrl: imageUrl == null ? "" : imageUrl,
//    placeholder: (context, url) {
//      return Container(
//        color: Colours.color_eeeeee,
//        child: Center(
//          child: loadAssetImage(placeholder, width: width, height: height),
//        ),
//      );
//    },
//    errorWidget: (context, url, e) {
//      return Container(
//        color: Colours.color_eeeeee,
//        child: Center(
//          child: loadAssetImage(error, width: width, height: height),
//        ),
//      );
//    },
//    width: width,
//    height: height,
//    fit: fit,
//  );
//}
//
/////加载圆形带边框头像
//Widget getCircleAvatar(String imageUrl, double width, double height,
//    {String placeholder = "icon_loading",
//    String error = "icon_load_fail",
//    BoxFit fit: BoxFit.cover,
//    bool isLocal = false}) {
//  return Container(
//    width: width,
//    height: height,
//    decoration: BoxDecoration(
//        color: Colours.border_color,
//        shape: BoxShape.circle,
//        border: Border.all(color: Colours.bg_color, width: 0.5)),
//    child: ClipOval(
//      child: isLocal
//          ? loadAssetImage(imageUrl, width: width, height: height, fit: fit)
//          : loadNetworkImage(imageUrl,
//              width: width,
//              height: height,
//              placeholder: placeholder,
//              error: error,
//              fit: fit),
//    ),
//  );
//}

String getImgPath(String name, {String format: 'png'}) {
  return 'images/$name.$format';
}
