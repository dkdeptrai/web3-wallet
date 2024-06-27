import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/services/interfaces/transaction_service.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

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
  Future<void> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required String amountToSend,
  }) async {
    try {
      if (_client == null) throw ('Web3Client is not initialized');

      final amountInWei = BigInt.from(double.parse(amountToSend) * pow(10, 18));

      final Credentials credentials = EthPrivateKey.fromHex(privateKey);

      final gasPrice = await _client!.getGasPrice();

      final Transaction transaction = Transaction(
        from: await credentials.address,
        to: EthereumAddress.fromHex(recipientAddress),
        value: EtherAmount.inWei(amountInWei),
        gasPrice: gasPrice,
        maxGas: 50000000,
      );

      final signedTx = await _client!.signTransaction(credentials, transaction, chainId: 11155111);
      final signedTxHex = hexEncode(signedTx); // Convert the byte array to a hexadecimal string
      print('Signed transaction: $signedTxHex');
      String url = "${ApiConstants.apiBaseUrl}/api/web3-helper/send-raw-transaction";
      final response = await http.post(Uri.parse(url), body: {
        "transactionHash": signedTxHex,
        "value": amountToSend,
        "recipientAddress": recipientAddress,
        "symbol": "ETH",
      });
      String txhash = jsonDecode(response.body)["transactionHash"];
      // TODO: Create socket with hash returned
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

  String hexEncode(Uint8List input) {
    return hex.encode(input).padLeft((input.length + 1) * 2, "0");
  }
}
