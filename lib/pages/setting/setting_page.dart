import 'package:flutter/material.dart';
import 'package:flutterdoctor/base/base_state.dart';
import 'package:flutterdoctor/event/change_scale_event.dart';
import 'package:flutterdoctor/pages/method/helper/method_draw_helper.dart';
import 'package:flutterdoctor/utils/adapt_ui.dart';
import 'package:flutterdoctor/utils/event_bus_util.dart';
import 'package:flutterdoctor/utils/page_util.dart';
import 'package:flutterdoctor/utils/strings.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends BaseState<SettingPage> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget buildUI(BuildContext context) {
    return Column(
      children: [
        PageUtil.buildTitleBar('设置', leftCallback: () {
          finish();
        }),
        _buildTime2Distance()
      ],
    );
  }

  Widget _buildTime2Distance() {
    return Container(
      margin: EdgeInsets.all(UIAdaptor.w(8)),
      child: Row(
        children: [
          Text('请输入时间和绘制宽度的映射值：'),
          Container(
            width: UIAdaptor.w(20),
            child: TextField(
              controller: _controller,
            ),
          )
        ],
      ),
    );
  }

  @override
  finish([Object result]) {
    //保存数据
    _save();
    return super.finish(result);
  }

  _save() {
    if (isEmpty(_controller.text)) {
      return;
    }
    double scale = double.parse(_controller.text);
    if ((scale ?? 0) > 0) {
      //更新数据
      MethodDrawHelper.TIME_TO_DISTANCE = scale;
      EventBusUtil.fire(ChangeScaleEvent());
    }
  }
}
