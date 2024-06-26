import 'dart:async';

import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web3_wallet/socket_io_stream_wrapper.dart';

class PendingTransactionServiceImpl implements PendingTransactionsService {
  final Map<String, IO.Socket> _pendingTransactionsSockets = {};
  final Map<String, SocketIoStreamWrapper> _pendingTransactionsStreams = {};

  Future<void> createAndAddSocket(String transactionHash) async {
    final IO.Socket socket = IO.io(ApiConstants.webSocketUrl, <String, dynamic>{
      "transports": ["websocket"],
    });
    // Handle connection
    socket.on('connect', (_) {
      print('Connected to the socket with transaction hash: $transactionHash');
    });
    // Handle disconnection
    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });

    // Handle error
    socket.on('error', (data) {
      print('Error: $data');
    });
    _pendingTransactionsSockets[transactionHash] = socket;
    final streamWrapper = SocketIoStreamWrapper<Map<String, dynamic>>();
    streamWrapper.listenToEvent(socket, transactionHash, onData: (data) {
      if (data['status']['status'] == "mined") {
        disconnectSocket(transactionHash);
      }
    });
    _pendingTransactionsStreams[transactionHash] = streamWrapper;
    print("Hash: ${transactionHash}");
    print("Stream: ${_pendingTransactionsStreams[transactionHash]}");
  }

  SocketIoStreamWrapper? getStream(String transactionHash) {
    print("Transaction hash: $transactionHash ");
    final stream = _pendingTransactionsStreams[transactionHash];
    print("Transaction stream: ${_pendingTransactionsStreams.entries} ");
    return stream;
  }

  void disconnectSocket(String transactionHash) {
    final socket = _pendingTransactionsSockets[transactionHash];
    socket?.disconnect();
    _pendingTransactionsSockets.remove(transactionHash);
    final stream = _pendingTransactionsStreams[transactionHash];
    stream?.dispose();
    _pendingTransactionsStreams.remove(transactionHash);
  }
}
