import 'dart:ui';

import 'package:flutterdoctor/utils/color_pool.dart';

class MethodCallBean {
  String classFullName; //所属类全名
  int endTime; //结束时间
  String methodName; //方法名字
  int startTime; //开始时间
  ThreadInfo threadInfo; //所属线程信息
  int type; //类型
  MethodCallBean parent; //父
  List<MethodCallBean> childs; //子集合

  //////////////以下为添加的额外属性////////////////////
  //是否需要测量，用于解决测量过，数据修改还需要重新测量
  bool isNeedMeasure = true;
  //是否需要绘制，用于隐藏部分方法
  bool isNeedDraw = true;
  //宽
  double w = 0;
  //高
  double h = 0;
  //顶部距离
  double top = 0;
  //左边距离
  double left = 0;
  //色块颜色
  Color color;
  //总时间 = endTime - startTime + extraTime + 1；同时更新parent.extraTime = extraTime + 1
  int totalTime = 0;
  //记录在计算所有child过程中，额外添加的时间，因为为了显示执行时间为0的方法
  //对每个方法的时间执行了 +1 操作
  int extraTime = 0;

  MethodCallBean(
      {this.classFullName,
      this.endTime,
      this.methodName,
      this.startTime,
      this.threadInfo,
      this.type});

  MethodCallBean.fromJson(Map<String, dynamic> json, MethodCallBean parent) {
    classFullName = json['classFullName'];
    endTime = json['endTime'];
    methodName = json['methodName'];
    startTime = json['startTime'];
    threadInfo = json['threadInfo'] != null
        ? new ThreadInfo.fromJson(json['threadInfo'])
        : null;
    type = json['type'];
    this.parent = parent;
    if (json['childs'] != null) {
      childs = List();
      json['childs'].forEach((v) {
        childs.add(MethodCallBean.fromJson(v, this));
      });
    }
    this.color = ColorPool.randomColor();
  }
}

class ThreadInfo {
  int id;
  String name;

  ThreadInfo({this.id, this.name});

  ThreadInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
