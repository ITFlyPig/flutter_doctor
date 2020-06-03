import 'package:flutter/material.dart';
import 'package:flutterdoctor/base/base_provider.dart';
import 'package:flutterdoctor/socket/websocket_helper.dart';

class MethodTimeProvider extends BaseProvider {
  Property<SocketStatus> _socketStatus = Property();

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
