import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';

part 'send_tokens_state.dart';

class SendTokensCubit extends Cubit<SendTokensState> {
  final SepoliaTransactionService _sepoliaTransactionService = GetIt.I<SepoliaTransactionService>();
  final WalletService _walletService = GetIt.I<WalletService>();
  final OtherTokenService _otherTokenService = GetIt.I<OtherTokenService>();

  SendTokensCubit() : super(SendTokensInitial());

  Future<String?> sendTokens({
    required String recipientWalletAddress,
    required double amount,
    String? contractAddress,
  }) async {
    emit(SendingTokens());
    try {
      String recipient = recipientWalletAddress;
      final privateKey = await _walletService.getPrivateKey();
      if (privateKey == null) {
        emit(const SendTokensError('Private key not found'));
        return null;
      }
      String? txnHash;
      if (contractAddress != null && contractAddress.isNotEmpty) {
        _otherTokenService.setContractAddress(contractAddress);
        txnHash = await _otherTokenService.sendTransaction(
          privateKey: privateKey,
          recipientAddress: recipient.trim(),
          amountToSend: amount.toString(),
        );
      } else {
        txnHash = await _sepoliaTransactionService.sendTransaction(
          privateKey: privateKey,
          recipientAddress: recipient.trim(),
          amountToSend: amount.toString(),
        );
      }
      emit(const TokensSent());
      return txnHash;
    } catch (e) {
      emit(SendTokensError(e.toString()));
      return null;
    }
  }
}
