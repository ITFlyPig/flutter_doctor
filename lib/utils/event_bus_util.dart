import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static EventBus _eventBus = EventBus();

  static Stream<T> on<T>() {
    return _eventBus.on<T>();
  }

  static void fire(event) {
    _eventBus.fire(event);
  }
}
