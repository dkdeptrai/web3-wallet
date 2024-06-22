import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MarketServiceImpl implements MarketService {
  late final IOWebSocketChannel channel;

  MarketServiceImpl() {
    init();
  }

  Future<void> init() async {
    Uri uri = Uri.parse(ApiConstants.webSocketUrl);
    channel = IOWebSocketChannel.connect(uri);
    await channel.ready;
    channel.stream.listen(
      (message) {
        print('Received: $message');
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
  }

  @override
  Stream getStream() {
    return channel.stream;
  }
}
