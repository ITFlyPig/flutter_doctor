import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutterdoctor/utils/strings.dart';

import 'base_view.dart';
import 'loading_widget.dart';
import 'status_widget.dart';

///
/// 封装了一些基本的常用的功能：
/// 1、状态页面，空页面、无网页面等
/// 2、加载中动画的控制
/// 3、Toast提示
abstract class BaseState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin
    implements IView {
  bool _isShowLoading = false; //是否显示加载动画
  Color scaffoldBgColor = Colors.white;
  int statusType = StatusType.NONE;

  BaseState({this.scaffoldBgColor});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ///处理状态
    Widget withStatusWidget = statusType == StatusType.NONE
        ? buildUI(context)
        : StatusWidget(
            statusType,
            width: getStatusSize()?.width,
            height: getStatusSize()?.height,
            clickCallback: (statusType) {
              onStatusClick(statusType);
            },
          );
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Container(
        child: _isShowLoading
            ? LoadingWidget(
                isSHow: true,
                child: withStatusWidget,
              )
            : withStatusWidget,
      ),
    );
  }

  ///返回状态控件的尺寸
  Size getStatusSize() {
    return Size.infinite;
  }

  ///实际返回UI的方法
  Widget buildUI(BuildContext context);

  ///当状态控件被点击
  onStatusClick(int statusType) {}

  @override
  showStatus(int status) {
    if (mounted && status != statusType) {
      setState(() {
        statusType = status;
      });
    }
  }

  @override
  showLoading() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isShowLoading = true;
    });
  }

  ///Toast提示
  @override
  void showToast(String string) {
    if (!mounted) {
      return;
    }
    BotToast.showText(text: isEmpty(string) ? "" : string);
  }

  @override
  closeLoading() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isShowLoading = false;
    });
  }

  ///隐藏键盘
  hideKeyBord(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  ///结束当前页面
  finish([Object result]) {
    Navigator.of(context).pop(result);
  }

  ///开始一个页面
  start(WidgetBuilder builder) {
    if (builder == null) return;
    Navigator.push(context, new MaterialPageRoute(builder: builder));
  }

  @override
  bool get wantKeepAlive => false;
}
