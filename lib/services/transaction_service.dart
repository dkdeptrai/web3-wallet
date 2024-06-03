import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

abstract class TransactionService {
  Future<void> init();
  Future<String> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required String amountToSend,
  });
}

class SepoliaTransactionService extends TransactionService {
  final String _apiUrl = dotenv.env['ALCHEMY_API_KEY']!;
  late Web3Client _client;

  SepoliaTransactionService();

  @override
  Future<void> init() async {
    _client = await Web3Client(_apiUrl, Client());
  }

  @override
  Future<String> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required String amountToSend,
  }) async {
    try {
      final amountInWei = BigInt.from(double.parse(amountToSend) * pow(10, 18));

      final Credentials credentials = EthPrivateKey.fromHex(privateKey);

      final gasPrice = await _client.getGasPrice();

      final Transaction transaction = Transaction(
        from: await credentials.address,
        to: EthereumAddress.fromHex(recipientAddress),
        value: EtherAmount.inWei(amountInWei),
        gasPrice: gasPrice,
        maxGas: 20000000,
      );

      final signedTx = await _client.signTransaction(credentials, transaction,
          chainId: 11155111);
      final txHash = await _client.sendRawTransaction(signedTx);
      TransactionReceipt? receipt;
      while (receipt == null) {
        await Future.delayed(
            const Duration(seconds: 5)); // Poll every 5 seconds
        receipt = await _client.getTransactionReceipt(txHash);
      }

      return txHash;
    } catch (e) {
      print('Transaction failed: $e');
      throw ('Transaction failed: $e');
    }
  }
}
