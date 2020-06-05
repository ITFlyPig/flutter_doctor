import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdoctor/pages/method/bean/method_call_bean.dart';
import 'package:flutterdoctor/pages/method/helper/method_draw_helper.dart';

///
///
/// 绘制显示一个代码块
///
///

class MethodWidget extends SingleChildRenderObjectWidget {
  final MethodCallBean callBean;

  MethodWidget(this.callBean);

  @override
  MethodRenderObject createRenderObject(BuildContext context) {
    return MethodRenderObject(callBean);
  }

  @override
  void updateRenderObject(
      BuildContext context, MethodRenderObject renderObject) {
    renderObject.callBean = callBean;
  }
}

class MethodRenderObject extends RenderProxyBox {
  MethodCallBean callBean;
  Paint _paint;

  MethodRenderObject(this.callBean) {
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
      MethodDrawHelper().layout(callBean);
    }
    print('测量得到的size${callBean.w}--${callBean.h}');
    size = Size(callBean.w, callBean.h); //将自身的大小设置为将要绘制的图的大小
  }

  //绘制child
  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    MethodDrawHelper().draw(context.canvas, _paint, callBean);
  }
}
