import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/socket_io_stream_wrapper.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// class MarketServiceImpl implements MarketService {
//   late final IOWebSocketChannel channel;

//   MarketServiceImpl() {
//     init();
//   }

//   Future<void> init() async {
//     Uri uri = Uri.parse(ApiConstants.webSocketUrl);
//     channel = IOWebSocketChannel.connect(uri);
//     await channel.ready;
//     channel.stream.listen(
//       (message) {
//         print('Received: $message');
//       },
//       onError: (error) {
//         print('Error: $error');
//       },
//       onDone: () {
//         print('WebSocket closed');
//       },
//     );
//   }

//   @override
//   Stream getStream() {
//     return channel.stream;
//   }
// }

class MarketServiceImpl implements MarketService {
  late IO.Socket socket;
  late SocketIoStreamWrapper _streamWrapper;

  MarketServiceImpl() {
    init();
  }

  void init() {
    socket = IO.io(ApiConstants.webSocketUrl, <String, dynamic>{
      "transports": ["websocket"],
    });

    _streamWrapper = SocketIoStreamWrapper();
    _streamWrapper.listenToEvent(socket, 'newPrice');

    socket.onConnect((_) {
      print('Connected to Socket.IO Server');
      socket.emit('startCoinsPricePolling');
    });

    socket.onError((error) {
      print('Error: $error');
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO Server');
      socket.emit('stopCoinsPricePolling');
    });
  }

  @override
  void subscribeToMarketUpdates(dynamic Function(dynamic) onData) {
    socket.on('market_update', onData);
  }

  @override
  Stream getStream() {
    return _streamWrapper.stream;
  }
}
