import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdoctor/base/base_provider.dart';
import 'package:flutterdoctor/base/base_state.dart';
import 'package:flutterdoctor/ext/widget_chain.dart';
import 'package:flutterdoctor/pages/method/bean/method_call_bean.dart';
import 'package:flutterdoctor/pages/method/widgets/method_widget.dart';
import 'package:flutterdoctor/socket/websocket_helper.dart';
import 'package:flutterdoctor/utils/adapt_ui.dart';
import 'package:provider/provider.dart';

import 'helper/method_draw_helper.dart';
import 'method_time_presenter.dart';
import 'method_time_provider.dart';

///
/// 方法耗时显示页面
class MethodTimePage extends StatefulWidget {
  @override
  _MethodTimePageState createState() => _MethodTimePageState();
}

class _MethodTimePageState extends BaseState<MethodTimePage>
    implements IMethodTimeView {
  MethodTimeProvider _provider;
  MethodTimePresenter _presenter;

  @override
  void initState() {
    super.initState();
    _provider = MethodTimeProvider();
    _presenter = MethodTimePresenter(this);
    _presenter.startSocket();
  }

  @override
  Widget buildUI(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Container(
        child: _buildMethodTimeWidget(),
      ),
    );
  }

  ///页面的布局
  Widget _buildLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildSocketStatus()],
    ).intoContainer(width: double.infinity, height: double.infinity);
  }

  ///socket状态显示
  Widget _buildSocketStatus() {
    return AccurateConsumer<MethodTimeProvider>(
      builder: (context, methodTimeProvider) {
        methodTimeProvider.subscribeSocketStatus(context);
        return Text(
                'socket状态：${_getSocketStatus(methodTimeProvider.getSocketStatus())}')
            .intoContainer(
                padding: EdgeInsets.only(
                    top: UIAdaptor.h(20), bottom: UIAdaptor.h(20)));
      },
    );
  }

  @override
  void updateSocketStatus(SocketStatus status) {
    //更新socket的连接状态
    if (status != null && status != _provider.getSocketStatus()) {
      _provider.setSocketStatus(status);
    }
  }

  ///获得socket状态提示语
  String _getSocketStatus(SocketStatus status) {
    String statusStr = '';
    switch (status) {
      case SocketStatus.SUCCESS:
        statusStr = '连接成功';
        break;
      case SocketStatus.WAIT:
        statusStr = '等待连接';
        break;
      case SocketStatus.ERROR:
        statusStr = '连接错误';
        break;
      case SocketStatus.CLOSE:
        statusStr = '连接关闭';
        break;
    }
    return statusStr;
  }

  ///方法时间图表
  Widget _buildMethodTimeWidget() {
    MethodCallBean bean =
        MethodCallBean.fromJson(json.decode(MethodDrawHelper.testJson), null);
    return MethodWidget(bean);
  }
}
