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

  Future<void> sendTokens({
    required String recipientWalletAddress,
    required double amount,
  }) async {
    emit(SendingTokens());
    String recipient = recipientWalletAddress;
    final privateKey = await walletService.getPrivateKey();
    if (privateKey == null) {
      emit(const SendTokensError('Private key not found'));
      return;
    }
    final res = await sepoliaTransactionService.sendTransaction(
      amountToSend: amount,
      privateKey: privateKey,
      recipientAddress: recipient.trim(),
    );
    print("Transaction receipt: $res ");
    emit(const TokensSent());
  }
}