import 'package:flutter/material.dart';
import 'package:flutterdoctor/base/base_provider.dart';
import 'package:flutterdoctor/socket/websocket_helper.dart';

import 'bean/method_call_bean.dart';

class MethodTimeProvider extends BaseProvider {
  Property<SocketStatus> _socketStatus = Property();

  ///全部线程的方法调用
  Property<List<MethodCallBean>> _calls = Property();

  List<MethodCallBean> getCalls() {
    return _calls.get();
  }

  void setCalls(List<MethodCallBean> calls) {
    _calls.set(calls);
  }

  ///添加一个回调
  void addCall(MethodCallBean callBean) {
    List<MethodCallBean> calls = getCalls();
    if (calls == null) {
      calls = [];
    }
    calls.add(callBean);
    setCalls(calls);
  }

  void subscribeCalls(BuildContext context) {
    _calls.subscribe(context);
  }

  SocketStatus getSocketStatus() {
    return _socketStatus.get() ?? SocketStatus.WAIT;
  }

  void setSocketStatus(SocketStatus socketStatus) {
    _socketStatus.set(socketStatus);
  }

  void subscribeSocketStatus(BuildContext context) {
    _socketStatus.subscribe(context);
  }
}
