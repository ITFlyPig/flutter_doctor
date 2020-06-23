import 'package:flutter/material.dart';
import 'package:flutterdoctor/res/colors.dart';
import 'package:flutterdoctor/res/dimens.dart';

import 'adapt_ui.dart';
import 'image_utils.dart';

typedef ClickCallback = void Function();

class PageUtil {
  ///打开页面
  static void openPage(Widget widget, BuildContext context) {
    if (widget == null) {
      return;
    }

    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  ///创建标题栏中间的文字组件
  static Widget getMiddleTitle(String title, {Color textColor = Colors.black}) {
    return Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 17,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  ///创建返回Widget
  static Widget getBackWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Icon(
          Icons.arrow_back,
          color: Colours.text_gray_6,
          size: FontSize.title,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  ///titlebar
  static Widget buildTitleBar(String title,
      {Widget left, ClickCallback leftCallback, Widget middle, Widget right}) {
    return Container(
      padding: EdgeInsets.only(top: UIAdaptor.h(6), bottom: UIAdaptor.h(6)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    leftCallback?.call();
                  },
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: UIAdaptor.w(5)),
                        child: loadAssetImage('ic_back',
                            width: Dimens.icBackSize,
                            height: Dimens.icBackSize),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                        color: Colours.text_normal, fontSize: FontSize.title),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Offstage(
                  offstage: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(right: UIAdaptor.w(30)),
                          decoration: BoxDecoration(
                              color: Colours.color_3390FF,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          padding: EdgeInsets.all(UIAdaptor.w(10)),
                          child: Center(
                            child: Text(
                              '提交',
                              style: TextStyle(
                                  color: Colours.white,
                                  fontSize: FontSize.normal),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          buildDivider()
        ],
      ),
    );
  }

  ///背景
  static Widget buildBg() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: loadAssetImage('ic_login_bg', fit: BoxFit.cover),
    );
  }

  ///分割线
  static Widget buildDivider() {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: Colours.color_CDCDCD,
    );
  }
}
