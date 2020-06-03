import 'package:flutterdoctor/base/base_view.dart';
import 'package:flutterdoctor/socket/websocket_helper.dart';

abstract class IMethodTimeView extends IView {
  ///socket状态更新
  void updateSocketStatus(SocketStatus status);
}

class MethodTimePresenter {
  IMethodTimeView _view;
  WebSocketHelper _socketHelper;

  MethodTimePresenter(this._view) {
    _socketHelper = WebSocketHelper();
  }

  ///开始socket连接
  void startSocket() {
    _socketHelper.listen((data) {}, (status) {
      _view.updateSocketStatus(status);
    });
  }
}
