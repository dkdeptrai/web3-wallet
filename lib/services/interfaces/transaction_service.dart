import 'package:web3dart/web3dart.dart';

abstract class TransactionService {
  void init();
  void setContractAddress(String address);
  Future<EtherAmount> getBalance(String address);
  Future<TransactionReceipt> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required double amountToSend,
  });
  bool isInitialized();
}
