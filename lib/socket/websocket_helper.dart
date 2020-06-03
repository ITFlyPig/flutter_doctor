import 'package:web_socket_channel/html.dart';

class WebSocketHelper<T> {
  HtmlWebSocketChannel _channel;

  void listen(void onData(T data), void onStatus(SocketStatus status)) {
    if (_channel == null) {
      _channel = HtmlWebSocketChannel.connect("ws://121.40.165.18:8800");
    }
    _channel.stream.listen((data) {
      print('Websocket接收到数据' + (data == null ? ' ' : data.toString()));
      String str = data?.toString();
      if (str == null) {
        onData?.call(null);
        return;
      }
      //解析为json格式
//      Map<String, dynamic> _map = json.decode(str);

      onStatus?.call(SocketStatus.SUCCESS);
    }, onError: (e) {
      onStatus?.call(SocketStatus.ERROR);
    }, onDone: () {
      onStatus?.call(SocketStatus.CLOSE);
    }, cancelOnError: true);
  }
}

//socket连接状态
enum SocketStatus {
  WAIT, //等待连接
  SUCCESS, //连接成功
  ERROR, //连接失败
  CLOSE //关闭
}
