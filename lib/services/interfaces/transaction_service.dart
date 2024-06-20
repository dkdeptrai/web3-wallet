import 'package:web3dart/web3dart.dart';

abstract class TransactionService {
  Future<void> init();
  Future<EtherAmount> getBalance(String address);
  Future<TransactionReceipt> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required String amountToSend,
  });
}
