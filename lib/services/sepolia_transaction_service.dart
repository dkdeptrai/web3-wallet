import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/exceptions/api_exception.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class SepoliaTransactionService implements TransactionService {
  final String _apiUrl = dotenv.env['ALCHEMY_API_KEY']!;
  Web3Client? _client;

  final PendingTransactionServiceImpl _pendingTransactionService = GetIt.I<PendingTransactionServiceImpl>();

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
  Future<String?> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required String amountToSend,
  }) async {
    try {
      if (_client == null) throw ('Web3Client is not initialized');

      final amountInWei = BigInt.from(double.parse(amountToSend) * pow(10, 18));

      final Credentials credentials = EthPrivateKey.fromHex(privateKey);
      final nonce = await _client!.getTransactionCount(credentials.address);

      final gasPrice = await _client!.getGasPrice();

      final Transaction transaction = Transaction(
        from: await credentials.address,
        to: EthereumAddress.fromHex(recipientAddress),
        value: EtherAmount.inWei(amountInWei),
        gasPrice: gasPrice,
        maxGas: 30000,
        nonce: nonce,
      );

      final signedTx = await _client!.signTransaction(credentials, transaction, chainId: 11155111);
      String signedTxHex = hexEncode(signedTx); // Convert the byte array to a hexadecimal string
      signedTxHex = signedTxHex.replaceFirst("00", "0x");
      String url = "${ApiConstants.apiBaseUrl}/api/web3-helper/send-raw-transaction";
      String data = jsonEncode({
        "transactionHash": signedTxHex,
        "value": amountToSend,
        "recipientAddress": recipientAddress,
        "symbol": "ETH",
      });
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: data,
      );
      String? txhash = jsonDecode(response.body)["transactionHash"];
      if (txhash == null) throw ApiException(message: "Transaction failed");

      await _pendingTransactionService.createAndAddSocket(txhash);
      return txhash;
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
  void setContractAddress(String address) {}

  String hexEncode(Uint8List input) {
    return hex.encode(input).padLeft((input.length + 1) * 2, "0");
  }
}
