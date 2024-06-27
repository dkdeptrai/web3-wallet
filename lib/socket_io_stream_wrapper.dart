import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIoStreamWrapper {
  final _streamController = StreamController<List<dynamic>>.broadcast(sync: true); // Changed to List<dynamic>
  Stream<List<dynamic>> get stream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }

  void listenToEvent(IO.Socket socket, String eventName) {
    socket.on(eventName, (data) {
      // print("received: $data");
      List<dynamic> dataList = data;
      _streamController.add(dataList); // Now handles List<dynamic>
    });
  }
}
