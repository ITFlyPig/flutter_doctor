import 'package:flutter/material.dart';
import 'package:flutterdoctor/base/base_state.dart';
import 'package:flutterdoctor/ext/widget_chain.dart';
import 'package:flutterdoctor/pages/home/home_presenter.dart';
import 'package:flutterdoctor/res/colors.dart';
import 'package:flutterdoctor/utils/adapt_ui.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> implements IHomeView {
  @override
  Widget buildUI(BuildContext context) {
    return _buildLayout();
  }

  ///首页的布局
  Widget _buildLayout() {
    return Wrap(
      spacing: UIAdaptor.w(8),
      runSpacing: UIAdaptor.w(8),
      children: [_buildFuncItem("方法耗时查看", 0), _buildFuncItem('日志捞取', 1)],
    );
  }

  ///
  /// 构建item
  Widget _buildFuncItem(String name, int index) {
    return Text(
      name ?? '',
      textAlign: TextAlign.center,
    ).intoCenter().intoContainer(
        width: UIAdaptor.w(50),
        height: UIAdaptor.w(50),
        color: Colours.color_1B86FC);
  }
}
