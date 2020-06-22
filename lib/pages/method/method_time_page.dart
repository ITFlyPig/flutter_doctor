import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdoctor/base/base_provider.dart';
import 'package:flutterdoctor/base/base_state.dart';
import 'package:flutterdoctor/ext/widget_chain.dart';
import 'package:flutterdoctor/pages/method/bean/method_call_bean.dart';
import 'package:flutterdoctor/pages/method/widgets/method_widget.dart';
import 'package:flutterdoctor/res/colors.dart';
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
  ScrollController _scrollController;
  double _offset = 0;
  Timer _timer;
  bool _stopScroll = false;

  @override
  void initState() {
    super.initState();
    _provider = MethodTimeProvider();
    _presenter = MethodTimePresenter(this);
    _presenter.startSocket();
    _scrollController = ScrollController();
  }

  ///停止计时
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  bool _shouldScroll() {
    int len = _provider.getCalls()?.length ?? 0;
    if (len <= 0) return false;
    MethodCallBean last = _provider.getCalls()[len - 1];
    if (len > 0) {
      if (
          //最后一个太远还未测量
          last.h == 0 ||
              //最后一个视图还在在窗口外面
              (_scrollController.offset + ScreenUtil.screenHeight / 2) <
                  (last.offset + last.h)) {
        return true;
      }
    }
    return false;
  }

  ///开始计时
  void _startTimer() {
    if (_shouldScroll() && _timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        if (_stopScroll) return;
        if (_shouldScroll()) {
          _offset = _scrollController.offset + 200;
          _scrollController.animateTo(_offset,
              duration: Duration(milliseconds: 1000), curve: Curves.linear);
//          print(
//              '当前listview的滚动偏移：${_scrollController.offset} 当前窗口的高度:${ScreenUtil.screenHeight} 宽度：${ScreenUtil.screenWidth} 最后一个项的偏移：${_provider.getCalls()[len - 1].offset}高度:${_provider.getCalls()[len - 1].h}');
        }
      });
    }
  }

  @override
  Widget buildUI(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: GestureDetector(
        onTapDown: (detail) {
          _stopScroll = true;
          _stopTimer();
        },
        onDoubleTap: () {
          _stopScroll = false;
          _startTimer();
        },
        child: Container(
          child: _buildMethodChart(),
        ),
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
    return MethodWidget(bean, null);
  }

  ///方法图表
  Widget _buildMethodChart() {
    return AccurateConsumer<MethodTimeProvider>(
      builder: (context, methodTimeProvider) {
        methodTimeProvider.subscribeCalls(context);
        print(
            '_buildMethodChart build数量${methodTimeProvider.getCalls()?.length ?? 0}');
        return ListView.builder(
          itemBuilder: (context, index) {
            return Row(
              children: [
                Container(
                  child: MethodWidget(methodTimeProvider.getCalls()[index], () {
                    MethodCallBean cur = methodTimeProvider.getCalls()[index];
                    if (index == 0) {
                      cur.offset = 0;
                    } else {
                      MethodCallBean pre =
                          methodTimeProvider.getCalls()[index - 1];
                      cur.offset = pre.offset + pre.padding.vertical + pre.h;
                    }
                    print('第${index}项的偏移量：${cur.offset}');
                  }),
                  color: Colours.white,
                )
              ],
            );
          },
          itemCount: methodTimeProvider.getCalls()?.length ?? 0,
          controller: _scrollController,
        );
      },
    );
  }

  @override
  void onNewCall(MethodCallBean bean) {
    if (mounted) {
      _provider.addCall(bean);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _startTimer();
      });
    }
  }
}
