import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterdoctor/res/colors.dart';

///
/// 加载动画
///
class LoadingWidget extends StatefulWidget {
  final bool isSHow;
  final Widget child;

  LoadingWidget({Key key, this.isSHow, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoadingWidgetState();
  }
}

class LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(widget.child);
    if (widget.isSHow != null && widget.isSHow) {
      widgets.add(_getLoadingWidget());
    }

    return Container(
      child: Stack(
        children: widgets,
      ),
    );
  }

  ///加载中样式
  Widget _getLoadingWidget() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colours.half_trans),
        child: SpinKitCircle(
          size: 40.0,
          color: Colours.white,
        ),
      ),
    );
  }
}
