import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
///
/// 轻量级的实现属性级别的刷新，和Provider框架兼容
///
///

typedef OnUpdate = void Function(dynamic tag);
typedef DisposeProvider = void Function(dynamic tag);

abstract class BaseProvider extends ChangeNotifier {
  void disposeProvider(BuildContext context){
    dispose();
  }
}

///封装字段
class Property<T> {
  T _value;
  Map<BuildContext, OnUpdate> subscribeMap;

  ///获取值
  T get() {
    return _value;
  }

  ///设置值（通知所有订阅开始刷新）
  set(T newValue) {
    _value = newValue;
    subscribeMap?.forEach((k, v) {
      v?.call(newValue);
    });
  }

  ///通知订阅者，数据改变了
  notifyValueChanged() {
    subscribeMap?.forEach((k, v) {
      v?.call(null);
    });
  }

  ///订阅（表示值改变了，需要通知刷新）
  subscribe(BuildContext context) {
    subscribeMap ??= Map();
    if (!subscribeMap.containsKey(context)) {
      subscribeMap[context] = (data) {
        Element element = context;
        //为什么使用延迟，解决setState() or markNeedsBuild() called during build.
        Future.delayed(Duration(milliseconds: 0)).then((e){
          if (context.findRenderObject().attached) {//避免RenderObject已经无效了还回调刷新（即Widget已经dispose了）
            element.markNeedsBuild();
          }

        });
      };
    }
  }

  ///释放资源
  dispose(BuildContext context) {
    subscribeMap?.clear();
  }
}


///将BaseProvider封装到Widget中
class AccurateConsumer<T extends BaseProvider> extends StatefulWidget {
  final Widget Function(BuildContext context, T provider) builder;

  const AccurateConsumer({Key key, this.builder}) : super(key: key);

  @override
  State<AccurateConsumer<T>> createState() {
    print('builder:' + builder?.toString());
    return _AccurateConsumerState<T>();
  }
}

class _AccurateConsumerState<T extends BaseProvider>
    extends State<AccurateConsumer<T>> {
  T provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<T>(context, listen: false);
    return widget?.builder(context, provider);
  }

  @override
  void dispose() {
    super.dispose();
//    provider?.disposeProvider(context);
  }
}
