import 'dart:io';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

abstract class TransactionService {
  Future<void> init();
  Future<EtherAmount> getBalance(String address);
  Future<void> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required String amountToSend,
  });
}

String hexEncode(Uint8List input) {
  return hex.encode(input).padLeft((input.length + 1) * 2, "0");
}

class SepoliaTransactionService extends TransactionService {
  final String _apiUrl = dotenv.env['ALCHEMY_API_KEY']!;
  late Web3Client _client;

  SepoliaTransactionService();

  @override
  Future<void> init() async {
    _client = Web3Client(_apiUrl, Client());
  }

  @override
  Future<EtherAmount> getBalance(String address) async {
    final EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    final balance = await _client.getBalance(ethAddress);
    return balance;
  }

  @override
  Future<void> sendTransaction({
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
        maxGas: 5000000,
      );

      final signedTx = await _client.signTransaction(credentials, transaction, chainId: 11155111);
      final signedTxBytes = signedTx; // signedTx is already a Uint8List
      final signedTxHex = hexEncode(signedTxBytes); // Convert the byte array to a hexadecimal string
      print('Signed transaction: $signedTxHex');
      // final txHash = await _client.sendRawTransaction(signedTx);
      // TransactionReceipt? receipt;
      // while (receipt == null) {
      //   await Future.delayed(
      //       const Duration(seconds: 5)); // Poll every 5 seconds
      //   receipt = await _client.getTransactionReceipt(txHash);
      // }

      // return receipt;
    } catch (e) {
      print('Transaction failed: $e');
      throw ('Transaction failed: $e');
    }
  }
}

class OtherTokenService extends TransactionService {
  late final String _tokenAbi;
  late final String _contractAddress;
  final String _apiUrl = dotenv.env['ALCHEMY_API_KEY']!;
  late Web3Client _client;

  OtherTokenService(String contractAddress) {
    _contractAddress = contractAddress;
    // TODO: Load the ABI from the Local Storage
  }

  @override
  Future<void> init() async {
    _client = await Web3Client(_apiUrl, Client());
  }

  @override
  Future<EtherAmount> getBalance(String address) async {
    final abiCode = await rootBundle.loadString('assets/abi/erc20tokenabi.json');
    final contract = DeployedContract(ContractAbi.fromJson(abiCode, 'ERC20Token'), EthereumAddress.fromHex(_contractAddress));
    final params = [EthereumAddress.fromHex(address)];
    final balanceFunction = contract.function('balanceOf');

    final balance = await _client.call(contract: contract, function: balanceFunction, params: params);

    String balanceStr = balance.first.toString();

    BigInt balanceBigInt = BigInt.parse(balanceStr);

    return EtherAmount.inWei(balanceBigInt);
  }

  @override
  Future<void> sendTransaction({required String privateKey, required String recipientAddress, required String amountToSend}) async {
    try {
      final amountInWei = BigInt.from(double.parse(amountToSend) * pow(10, 18));

      final gasPrice = await _client.getGasPrice();

      // TODO: Repace with loading abi from local storage
      final abiCode = await rootBundle.loadString('assets/abi/erc20tokenabi.json');

      final credentials = EthPrivateKey.fromHex(privateKey);

      final contract = DeployedContract(ContractAbi.fromJson(abiCode, 'ERC20Token'), EthereumAddress.fromHex(_contractAddress));

      final transferFunction = contract.function('transfer');
      final data = transferFunction.encodeCall([EthereumAddress.fromHex(recipientAddress), amountInWei]);

      final transaction = Transaction.callContract(
          contract: contract,
          function: transferFunction,
          parameters: [EthereumAddress.fromHex(recipientAddress), amountInWei],
          gasPrice: gasPrice,
          maxGas: 500000,
          nonce: await _client.getTransactionCount(credentials.address));

      final signedTx = await _client.signTransaction(credentials, transaction, chainId: 11155111);
      final signedTxHex = hexEncode(signedTx);
      print('Signed transaction: $signedTxHex');

      // This works
      // final txBlockHash = await _client.sendTransaction(
      //     credentials,
      //     Transaction.callContract(
      //         contract: contract,
      //         function: contract.function('transfer'),
      //         parameters: [
      //           EthereumAddress.fromHex(recipientAddress),
      //           amountInWei
      //         ]),
      //     chainId: 11155111);

      // final signedTxHex = hexEncode(txBlockHash);
      // print("Signed Tx: $signedTxHex");

      // final transaction = Transaction(
      //     from: await credentials.address,
      //     to: contract.address,
      //     value: EtherAmount.zero(),
      //     gasPrice: gasPrice,
      //     maxGas: 5000000,
      //     data: data);

      // final signedTx = await _client.signTransaction(credentials, transaction);
      // print("Signec Tx: $signedTxHex");
      // final txHash = await _client.sendRawTransaction(signedTx);

      // TransactionReceipt? receipt;
      // while (receipt == null) {
      //   await Future.delayed(const Duration(seconds: 5));
      //   receipt = await _client.getTransactionReceipt(txHash);
      // }

      // return receipt;
    } catch (e) {
      print('Transaction failed: $e');
      throw ('Transaction failed: $e');
    }
  }

  Future<Map<String, dynamic>> getTokenDetails() async {
    try {
      final abiCode = await rootBundle.loadString('assets/abi/erc20tokenabi.json');
      final contract = DeployedContract(ContractAbi.fromJson(abiCode, 'ERC20Token'), EthereumAddress.fromHex(_contractAddress));

      final nameFunction = contract.function('name');
      final symbolFunction = contract.function('symbol');

      final name = await _client.call(contract: contract, function: nameFunction, params: []);

      final symbol = await _client.call(contract: contract, function: symbolFunction, params: []);

      return {
        'name': name,
        'symbol': symbol,
      };
    } catch (e) {
      print('Transaction failed: $e');
      throw ('Transaction failed: $e');
    }
  }
}
