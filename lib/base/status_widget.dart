import 'package:flutter/material.dart';
import 'package:flutterdoctor/res/colors.dart';

typedef ClickCallback = void Function(int type);

///
/// 状态页面
///
class StatusWidget extends StatefulWidget {
  final int statusType;
  final double width;
  final double height;
  final ClickCallback clickCallback;

  StatusWidget(this.statusType,
      {this.width = double.infinity,
      this.height = double.infinity,
      this.clickCallback});

  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: widget.width,
        height: widget.height,
        child: _statusWidget(widget.statusType),
      ),
      onTap: () {
        if (widget.clickCallback != null) {
          widget.clickCallback.call(widget.statusType);
        }
      },
    );
  }

  Widget _statusWidget(int type) {
    Widget statusWidget;
    switch (type) {
      case StatusType.EMPTY:
        statusWidget = Center(
          child: Text(
            "数据为空",
            style: TextStyle(color: Colours.text_gray_6),
          ),
        );
        break;
      case StatusType.NET_NO:
        statusWidget = Center(
          child: Text(
            "无网络",
            style: TextStyle(color: Colours.text_gray_6),
          ),
        );
        break;
      case StatusType.NET_ERROR:
        statusWidget = Center(
          child: Text(
            "网络请求错误",
            style: TextStyle(color: Colours.text_gray_6),
          ),
        );
        break;
      case StatusType.NONE:
        statusWidget = SizedBox();
        break;
      default:
        statusWidget = SizedBox();
        break;
    }
    return statusWidget;
  }
}

class StatusType {
  static const int NONE = 0; //什么都不要展示
  static const int EMPTY = 1; //数据为空页面
  static const int NET_NO = 2; //无网页面
  static const int NET_ERROR = 3; //网络错误
}
