import 'package:flutterdoctor/base/base_view.dart';

abstract class IHomeView extends IView {}

class HomePresenter {
  IHomeView _view;

  HomePresenter(this._view);
}
