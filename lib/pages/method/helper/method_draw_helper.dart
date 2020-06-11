import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdoctor/pages/method/bean/method_call_bean.dart';
import 'package:flutterdoctor/res/colors.dart';
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
  static const double LEAF_METHOD_H = 100; //叶子节点方法的高度。
  static const double TIME_TO_DISTANCE = 20; //时间到距离的映射
  static const int EXTRA_W = 3; //额外的宽度
  static const double DIVIDER_H = 10; //模块之间分割线的高度

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

  List<Rect> textRects = []; //记录本次绘制的文本的位置

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
      //叶子节点
      _calculate(bean);
    } else {
      //拥有child的节点
      for (int i = 0; i < childSize; i++) {
        measure(bean.childs[i]);
      }
      _calculate(bean);
//      _addExtraW(bean);
    }
    //增加分割线的高度
    if (bean.parent == null) {
      bean.padding = EdgeInsets.only(top: DIVIDER_H);
    }
  }

  ///布局
  void layout(MethodCallBean bean, MethodCallBean leftBrother) {
    if (bean == null) return;
    if (bean.parent == null) {
      bean.left = 0;
      bean.top = DIVIDER_H;
    } else if (leftBrother == null) {
      //表示没有左兄弟
      bean.left = bean.parent.left;
      bean.top = bean.parent.top;
    } else {
      //表示有左兄弟
      bean.left = leftBrother.left + leftBrother.w;
      bean.top = leftBrother.top + leftBrother.h;
    }
    print('方法${bean.methodName}计算得到的left:${bean.left} top: ${bean.top}');

    int childNum = bean.childs?.length ?? 0;
    MethodCallBean left;
    print('开始计算child，child数量：${childNum}');
    for (int i = 0; i < childNum; i++) {
      MethodCallBean cur = bean.childs[i];
      layout(cur, left);
      left = cur;
    }
  }

  ///每个拥有child的代码块增加额外的宽度
  void _addExtraW(MethodCallBean bean) {
    bean.h += EXTRA_W;
  }

  ///据总时间计算大小
  void _calculate(MethodCallBean leafBean) {
    if (leafBean == null) return;
    //计算bean自己的宽高
    _calculateTotalTime(leafBean);
    _calculateSize(leafBean);
  }

  ///计算总时间
  void _calculateTotalTime(MethodCallBean bean) {
    if (bean == null) return;
    bean.totalTime =
        (bean.endTime ?? 0) - (bean.startTime ?? 0) + bean.extraTime;
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
      bean.h = LEAF_METHOD_H;
      bean.w = bean.totalTime * TIME_TO_DISTANCE;
    } else {
//      bean.w = childSize * LEAF_METHOD_W;
      bean.childs?.forEach((element) {
        bean.h += element.h;
      });
      // TODO 这里的高度计算方式有待调整 1、依据得到的totalTime计算；2、按子集合累加得到
      bean.w = bean.totalTime * TIME_TO_DISTANCE;
    }
    print('_calculateSize 总时间${bean.totalTime},计算得到的高度：${bean.h}');
  }

  ///绘制，其实其中也包含了计算位置的逻辑，一次遍历 计算 + 绘制
  void draw(Canvas canvas, Paint paint, MethodCallBean bean) {
    if (canvas == null || paint == null || bean == null) return;
    //开始绘制一个新的代码块
    if (bean.parent == null) {
      //重置文本绘制位置
      textRects = [];
    }
    //绘制自己
    _drawMethodBlock(canvas, paint, bean);
    //绘制child
    int childNum = bean.childs?.length ?? 0;
    for (int i = 0; i < childNum; i++) {
      MethodCallBean child = bean.childs[i];
      draw(canvas, paint, child);
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
    String text =
        '${_getClassName(bean.classFullName)}.${bean.methodName}(${bean.totalTime})';
    double fontSize = 1.0;
    //测量文字
    Size textSize = _measureText(text, fontSize);
    //文字未调整时绘制的位置
    Offset offset = Offset(bean.left + bean.w + 1, bean.top);
    //调整后绘制的位置
//    Offset adjustedOffset = _adjustTextPos(text, fontSize,
//        Rect.fromLTWH(offset.dx, offset.dy, textSize.width, textSize.height));
    //绘制文字背景
    paint.color = Colours.half_trans_white;
    canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, textSize.width, textSize.height),
        paint);
    _drawText(text, canvas, fontSize, bean.color, offset);
  }

  ///调整文字的绘制，使整个代码块的文字都能不重叠绘制
  Offset _adjustTextPos(String text, double fontSize, Rect textRect) {
    if (isEmpty(text) || textRect == null) return Offset.zero;
    int len = textRects.length;
    if (len == 0) {
      textRects.add(textRect);
    } else {
      for (int i = 0; i < len; i++) {
        Rect pre = textRects[i];
        if (_isHit(pre, textRect)) {
          Rect newRect = Rect.fromLTWH(
              textRect.left, pre.bottom, textRect.width, textRect.height);
          textRects.add(newRect);
          return Offset(newRect.left, newRect.top);
        }
      }
    }
    return Offset(textRect.left, textRect.top);
  }

  ///两个矩形是否相交
  bool _isHit(Rect rect1, Rect rect2) {
    if (rect1 == null || rect2 == null) return false;
    if (rect1.bottomRight.dy < rect2.topLeft.dy ||
        rect1.topLeft.dy > rect2.bottomLeft.dy ||
        rect1.topRight.dx < rect2.topLeft.dx ||
        rect1.topLeft.dx > rect2.topRight.dx) {
      return false;
    } else {
      return true;
    }
  }

  ///测量文字的宽高
  Size _measureText(String text, double fontSize) {
    if (isEmpty(text)) return Size.zero;
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(maxWidth: double.infinity);
    return textPainter.size;
  }

  ///绘制文字
  Size _drawText(
      String text, Canvas canvas, double fontSize, Color color, Offset offset) {
    if (isEmpty(text)) return Size.zero;
    print('绘制文字的坐标：${offset}');
    //绘制文字
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: fontSize, color: color, fontWeight: FontWeight.w500),
        ),
        textScaleFactor: 1.0,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(maxWidth: double.infinity)
      ..paint(canvas, offset);
    return textPainter.size;
  }

  ///获取类的名字
  String _getClassName(String fullClassName) {
    if (isEmpty(fullClassName)) return '';
    fullClassName = fullClassName.replaceAll("/", ".");
    int start = fullClassName.lastIndexOf('.');
    int end = fullClassName.length;
    if ((start + 1) < end && start >= 0) {
      return fullClassName.substring(start + 1, end);
    }
    return '';
  }
}
