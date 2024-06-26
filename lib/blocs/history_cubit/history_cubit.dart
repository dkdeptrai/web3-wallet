import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/model/models.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3dart/web3dart.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final WalletService _walletService = GetIt.I<WalletService>();
  final HistoryService _historyService = GetIt.I<HistoryService>();
  final ETHWalletService _walletAddressService = GetIt.I<ETHWalletService>();

  HistoryCubit() : super(HistoryInitial());

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    try {
      final privateKey = await _getPrivateKey();
      if (privateKey == null) {
        emit(const HistoryError('No wallet found'));
        return;
      }
      final walletAddress = await _getWalletAddress(privateKey);

      List<String> contractAddresses = await _walletService.getStoredTokenAddresses() ?? [];

      final transactions = await _historyService.fetchHistory(
        walletAddress: walletAddress,
        contractAddresses: contractAddresses,
      );
      emit(HistoryLoaded(
        transactions: transactions,
        page: 1,
        pageSize: transactions.length,
      ));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      final privateKey = await _getPrivateKey();
      if (privateKey == null) {
        emit(const HistoryError('No wallet found'));
        return;
      }
      final walletAddress = await _getWalletAddress(privateKey);

      List<String> contractAddresses = await _walletService.getStoredTokenAddresses() ?? [];

      final transactions = await _historyService.fetchHistory(
        walletAddress: walletAddress,
        contractAddresses: contractAddresses,
        page: currentState.page + 1,
      );
      emit(HistoryLoadingMore(
        transactions: [...currentState.transactions, ...transactions],
        page: currentState.page + 1,
        pageSize: transactions.length,
      ));
    }
  }

  Future<String> _getWalletAddress(String privateKey) async {
    EthereumAddress address = await _walletAddressService.getPublicKey(privateKey);
    return address.hex;
  }

  Future<String?> _getPrivateKey() async {
    return await _walletService.getPrivateKey();
  }
}
