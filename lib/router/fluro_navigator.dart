import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterdoctor/utils/strings.dart';

import 'global_router.dart';
import 'routers.dart';

/// fluro的路由跳转工具类
class NavigatorUtils {
  static push(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      Map<String, String> params}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    String paramsStr = _parseParams(params);
    if (isNotEmpty(paramsStr)) {
      //有参数传递
      path += paramsStr;
    }
    GlobalRouter.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.inFromRight);
  }

  static pushResult(
      BuildContext context, String path, Function(Object) function,
      {bool replace = false,
      bool clearStack = false,
      Map<String, String> params}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    String paramsStr = _parseParams(params);
    if (isNotEmpty(paramsStr)) {
      //有参数传递
      path += paramsStr;
    }
    GlobalRouter.router
        .navigateTo(context, path,
            replace: replace,
            clearStack: clearStack,
            transition: TransitionType.inFromRight)
        .then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print("$error");
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context, result);
  }

  /// 跳到WebView页
  static goWebViewPage(BuildContext context, String title, String url) {
    //fluro 不支持传中文,需转换
    push(context,
        '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  }

  /// 跳到带返回按钮的WebView页
  static goWebViewPageCanGoBack(
      BuildContext context, String title, String url) {
//    Navigator.of(context)
//    .push(MaterialPageRoute(builder: (_) {
//    return Browser(
//      url: url,
//      title: title,
//    );
//    }));
  }

  ///
  /// 解析并且编码参数
  ///
  static _parseParams(Map<String, String> params) {
    if (params == null || params.isEmpty) {
      return null;
    }
    String paramsStr = "?";
    params.forEach((key, value) {
      if (paramsStr.length > 1) {
        paramsStr += "&";
      }
      if (isNotEmpty(key)) {
        paramsStr += (key + "=" + Uri.encodeComponent(value ?? ''));
      }
    });
    return paramsStr;
  }

  static SlideTransition createTransition(
      Animation<double> animation, Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0), //这里设置开始从那边出来。这个右边到左。
        end: const Offset(0.0, 0.0),
      ).animate(animation),
      child: child,
    );
  }

  static pushWithAnimation(BuildContext context, Widget newPage) {
    Navigator.push<String>(
        context,
        new PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation<double> animation, Animation<double> secondaryAnimation) {
          // 跳转的路由对象
          return newPage;
        }, transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return createTransition(animation, child);
        }));
  }
}
