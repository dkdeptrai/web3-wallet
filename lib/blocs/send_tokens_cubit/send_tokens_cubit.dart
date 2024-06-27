import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';

part 'send_tokens_state.dart';

class SendTokensCubit extends Cubit<SendTokensState> {
  final SepoliaTransactionService sepoliaTransactionService = GetIt.I<SepoliaTransactionService>();
  final WalletService walletService = GetIt.I<WalletService>();

  SendTokensCubit() : super(SendTokensInitial());

  Future<String?> sendTokens({
    required String recipientWalletAddress,
    required double amount,
  }) async {
    emit(SendingTokens());
    try {
      String recipient = recipientWalletAddress;
      final privateKey = await walletService.getPrivateKey();
      if (privateKey == null) {
        emit(const SendTokensError('Private key not found'));
        return null;
      }
      final txnHash = await sepoliaTransactionService.sendTransaction(
        privateKey: privateKey,
        recipientAddress: recipient.trim(),
        amountToSend: amount.toString(),
      );
      emit(const TokensSent());
      return txnHash;
    } catch (e) {
      emit(SendTokensError(e.toString()));
    }
  }
}
