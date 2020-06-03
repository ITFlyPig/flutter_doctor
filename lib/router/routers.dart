import 'package:fluro/fluro.dart';
import 'package:flutterdoctor/router/router_init.dart';

///
/// 字符串和跳转的页面对应起来
///
class Routes {
  static String home = "/home";
  static String webViewPage = "/webview";

  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(Router router) {
    /// 指定路由跳转错误返回页
//    router.notFoundHandler = Handler(
//        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//      debugPrint("未找到目标页");
//      return WidgetNotFound();
//    });
//
//    //跳转到home页面
//    router.define(home,
//        handler: Handler(
//            handlerFunc:
//                (BuildContext context, Map<String, List<String>> params) =>
//                    MyApp()));
//
//    //跳转到webview页面
//    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
//      String title = params['title']?.first;
//      String url = params['url']?.first;
//      return WebViewPage(title: title, url: url);
//    }));

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化
//    _listRouter.add(SettingRouter());

    /// 初始化路由
    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}
