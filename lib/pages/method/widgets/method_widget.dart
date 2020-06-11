import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdoctor/pages/method/bean/method_call_bean.dart';
import 'package:flutterdoctor/pages/method/helper/method_draw_helper.dart';

///
///
/// 绘制显示一个代码块
///
///

typedef OnMeasureCallBack = void Function();

class MethodWidget extends SingleChildRenderObjectWidget {
  final MethodCallBean callBean;
  final OnMeasureCallBack measureCallBack;

  MethodWidget(this.callBean, this.measureCallBack);

  @override
  MethodRenderObject createRenderObject(BuildContext context) {
    return MethodRenderObject(callBean, this.measureCallBack);
  }

  @override
  void updateRenderObject(
      BuildContext context, MethodRenderObject renderObject) {
    renderObject.callBean = callBean;
    renderObject.measureCallBack = measureCallBack;
  }
}

class MethodRenderObject extends RenderProxyBox {
  MethodCallBean callBean;
  Paint _paint;
  OnMeasureCallBack measureCallBack;

  MethodRenderObject(this.callBean, this.measureCallBack) {
    _paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
  }

  //据child计算自己的大小
  @override
  void performResize() {
    if (callBean == null) {
      size = Size.zero;
    }
    if (MethodDrawHelper().needMeasure(callBean)) {
      MethodDrawHelper().measure(callBean);
      MethodDrawHelper().layout(callBean, null);
    }
    print('测量得到的size${callBean.w}--${callBean.h}');
    size = Size(callBean.w + (callBean.padding.horizontal ?? 0),
        callBean.h + (callBean.padding.vertical ?? 0)); //将自身的大小设置为将要绘制的图的大小

    measureCallBack?.call();
  }

  //绘制child
  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    MethodDrawHelper().draw(context.canvas, _paint, callBean);
  }
}
