import 'package:flutter/cupertino.dart';
import 'package:flutterdoctor/pages/method/bean/method_call_bean.dart';
import 'package:flutterdoctor/utils/color_pool.dart';
import 'package:flutterdoctor/utils/strings.dart';

///
///
/// 绘制方法块的逻辑
/// 为了能看清方法块，所有的时间都执行加1的操作，避免时间为0的方法不可见
///

class MethodDrawHelper {
  static const String testJson =
      '{"args":["haha",20],"childs":[{"childs":[{"classFullName":"com.wyl.appdoctor.MainActivity","endTime":1591242261775,"methodName":"test3","parent":{"\$ref":"\$.childs[0]"},"startTime":1591242260774,"threadInfo":{"id":2,"name":"main"},"type":5}],"classFullName":"com.wyl.appdoctor.MainActivity","endTime":1591242263776,"methodName":"test2","parent":{"\$ref":"\$"},"startTime":1591242260773,"threadInfo":{"\$ref":"\$.childs[0].childs[0].threadInfo"},"type":5}],"classFullName":"com.wyl.appdoctor.MainActivity","endTime":1591242263776,"methodName":"test1haha","startTime":1591242257772,"threadInfo":{"\$ref":"\$.childs[0].childs[0].threadInfo"},"type":5}';
  static const double LEAF_METHOD_W = 50; //叶子节点方法的宽度。
  static const double TIME_TO_DISTANCE = 10; //时间到距离的映射

  /////////////单例实现//////////////////

  static MethodDrawHelper _instance;
  MethodDrawHelper._();
  static MethodDrawHelper _getInstance() {
    if (_instance == null) {
      _instance = MethodDrawHelper._();
    }
    return _instance;
  }

  factory MethodDrawHelper() => _getInstance();
  ///////////////////////////////

  ///展示代码块
//  performShow(MethodCallBean bean, Canvas canvas, Paint paint) {
//    if (bean == null || canvas == null || paint == null) return;
//    //测量
//    if (needMeasure(bean)) {
//      measure(bean);
//    }
//    //绘制
//    if (needDraw(bean)) {
//
//    }
//  }

  ///是否需要测量
  bool needMeasure(MethodCallBean bean) {
    return (bean != null && bean.isNeedMeasure && bean.h <= 0 && bean.w <= 0);
  }

  ///是否需要绘制
  bool needDraw(MethodCallBean bean) {
    return bean != null && bean.isNeedDraw;
  }

  ///测量大小
  void measure(MethodCallBean bean) {
    int childSize = bean.childs?.length ?? 0;
    if (childSize == 0) {
      _measureLeaf(bean);
    } else {
      for (int i = 0; i < childSize; i++) {
        measure(bean.childs[i]);
      }
      measure(bean);
    }
  }

  ///布局
  void _layout(MethodCallBean bean) {
    if (bean == null) return;
    if (bean.parent == null) {
      bean.left = 0;
    }
    int childNum = bean.childs?.length ?? 0;
    double totalLeft = 0;
    for (int i = 0; i < childNum; i++) {
      MethodCallBean child = bean.childs[i];
      child.left = totalLeft;
      totalLeft += child.w;
    }
  }

  ///测量叶子节点
  void _measureLeaf(MethodCallBean leafBean) {
    if (leafBean == null) return;
    _calculateTotalTime(leafBean);
    _calculateSize(leafBean);
  }

  ///计算总时间
  void _calculateTotalTime(MethodCallBean bean) {
    if (bean == null) return;
    bean.totalTime = bean.endTime ?? 0 - bean.startTime ?? 0 + bean.extraTime;
    //执行加1操作
    bean.totalTime++;
    //更新父节点的额外时间
    bean.extraTime = bean.extraTime + 1;
  }

  //计算大小
  void _calculateSize(MethodCallBean bean) {
    if (bean == null) return;
    int childSize = bean.childs?.length ?? 0;
    if (childSize == 0) {
      //叶子节点
      bean.w = LEAF_METHOD_W;
      bean.h = bean.totalTime * TIME_TO_DISTANCE;
    } else {
      bean.w = childSize * LEAF_METHOD_W;
      // TODO 这里的高度计算方式有待调整 1、计算得到的totalTime计算；2、按子集合累加得到
      bean.h = bean.totalTime * TIME_TO_DISTANCE;
    }
  }

  ///绘制，其实其中也包含了计算位置的逻辑，一次遍历 计算 + 绘制
  void draw(Canvas canvas, Paint paint, MethodCallBean bean) {
    if (canvas == null || paint == null || bean == null) return;
    //绘制自己
    _drawMethodBlock(canvas, paint, bean);
    //绘制child
    int childNum = bean.childs?.length ?? 0;
    double totalLeft = 0;
    double totalTop = 0;
    for (int i = 0; i < childNum; i++) {
      MethodCallBean child = bean.childs[i];
      child.left = totalLeft;
      child.top = totalTop;
      draw(canvas, paint, child);
      //计算child的位置
      totalLeft += child.w;
      totalTop += child.h;
    }
  }

  ///绘制方法块
  void _drawMethodBlock(Canvas canvas, Paint paint, MethodCallBean bean) {
    if (bean.color == null) {
      bean.color = ColorPool.randomColor();
    }
    paint.color = bean.color;
    //绘制方法颜色块
    canvas.drawRect(Rect.fromLTWH(bean.left, bean.top, bean.w, bean.h), paint);
    //绘制文字
    String text = '${_getClassName(bean.classFullName)}(${bean.totalTime})';
    _drawText(text, canvas, 15.0, bean.color, Offset(bean.left, bean.top));
  }

  ///绘制文字
  void _drawText(
      String text, Canvas canvas, double fontSize, Color color, Offset offset) {
    if (isEmpty(text)) return;
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: fontSize, color: color),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(maxWidth: double.infinity)
      ..paint(canvas, offset);
  }

  ///获取类的名字
  String _getClassName(String fullClassName) {
    if (isEmpty(fullClassName)) return '';
    int start = fullClassName.lastIndexOf('.');
    int end = fullClassName.length;
    if (start < end && start >= 0) {
      return fullClassName.substring(start, end);
    }
    return '';
  }
}
