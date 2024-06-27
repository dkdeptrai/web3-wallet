import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIoStreamWrapper<T> {
  final _streamController = StreamController<T>.broadcast(sync: true); // Changed to List<dynamic>
  Stream<T> get stream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }

  void listenToEvent(IO.Socket socket, String eventName, {Function(T)? onData}) {
    socket.on(eventName, (data) {
      print("$eventName data: $data");
      T dataList = data;
      _streamController.add(dataList); // Now handles List<dynamic>
      if (onData != null) {
        onData(data);
      }
    });
  }
}
