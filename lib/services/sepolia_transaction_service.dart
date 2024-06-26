import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3_wallet/services/interfaces/transaction_service.dart';
import 'package:web3dart/web3dart.dart';

class SepoliaTransactionService extends TransactionService {
  final String _apiUrl = dotenv.env['ALCHEMY_API_KEY']!;
  Web3Client? _client;

  SepoliaTransactionService() {
    init();
  }

  @override
  void init() {
    _client = Web3Client(_apiUrl, Client());
  }

  @override
  Future<EtherAmount> getBalance(String address) async {
    final EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    if (_client == null) throw ('Web3Client is not initialized');
    final balance = await _client!.getBalance(ethAddress);
    return balance;
  }

  @override
  Future<TransactionReceipt> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required double amountToSend,
  }) async {
    try {
      final amountInWei = BigInt.from(amountToSend * pow(10, 18));

      final Credentials credentials = EthPrivateKey.fromHex(privateKey);

      if (_client == null) throw ('Web3Client is not initialized');

      final gasPrice = await _client!.getGasPrice();

      final Transaction transaction = Transaction(
        from: credentials.address,
        to: EthereumAddress.fromHex(recipientAddress),
        value: EtherAmount.inWei(amountInWei),
        gasPrice: gasPrice,
        maxGas: 20000000,
      );

      final signedTx = await _client!
          .signTransaction(credentials, transaction, chainId: 11155111);
      final txHash = await _client!.sendRawTransaction(signedTx);
      TransactionReceipt? receipt;
      while (receipt == null) {
        await Future.delayed(
            const Duration(seconds: 5)); // Poll every 5 seconds
        receipt = await _client!.getTransactionReceipt(txHash);
      }
      print("Send success: $receipt");
      return receipt;
    } catch (e) {
      print('Transaction failed: $e');
      throw ('Transaction failed: $e');
    }
  }

  @override
  bool isInitialized() {
    return _client != null;
  }

  @override
  void setContractAddress(String address) {
    // TODO: implement setContractAddress
  }
}
