import 'package:flutterdoctor/base/base_view.dart';

abstract class ISettingView extends IView {}

class SettingPresenter {
  ISettingView _view;

  SettingPresenter(this._view);
}
