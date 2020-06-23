import 'dart:convert';

import 'package:flutterdoctor/base/base_view.dart';
import 'package:flutterdoctor/pages/method/helper/method_draw_helper.dart';
import 'package:flutterdoctor/socket/websocket_helper.dart';
import 'package:flutterdoctor/utils/strings.dart';

import 'bean/method_call_bean.dart';

abstract class IMethodTimeView extends IView {
  ///socket状态更新
  void updateSocketStatus(SocketStatus status);
  void onNewCall(MethodCallBean bean);
}

class MethodTimePresenter {
  IMethodTimeView _view;
  WebSocketHelper _socketHelper;

  MethodTimePresenter(this._view) {
    _socketHelper = WebSocketHelper();
  }

  ///开始socket连接
  void startSocket() {
    _socketHelper.listen((data) {
      print('接受到数据');
      if (isNotEmpty(data)) {
        MethodCallBean bean = MethodCallBean.fromJson(json.decode(data), null);
        print('将数据转为对象');
        if (bean != null) {
          _view.onNewCall(bean);
        }
      }
    }, (status) {
      _view.updateSocketStatus(status);
    });
  }

  ///添加测试数据
  void addTestData() {
    MethodCallBean bean =
        MethodCallBean.fromJson(json.decode(MethodDrawHelper.testJson), null);
    if (bean != null) {
      _view.onNewCall(bean);
    }
  }
}
