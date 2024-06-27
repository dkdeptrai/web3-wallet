import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletService _walletService = GetIt.I<WalletService>();
  final ETHWalletService _walletAddressService = GetIt.I<ETHWalletService>();
  late SepoliaTransactionService _transactionService = GetIt.I<SepoliaTransactionService>();

  WalletCubit() : super(WalletInitial());

  Future<void> loadWallet() async {
    emit(WalletLoading());

    try {
      if (!_transactionService.isInitialized()) {
        _transactionService.init();
      }

      String? privateKey = await _walletService.getPrivateKey();
      print("Private key: $privateKey");
      if (privateKey != null) {
        EthereumAddress address = await _walletAddressService.getPublicKey(privateKey);
        print("Address: ${address.hex}");
        String walletAddress = address.hex;
        String pvKey = privateKey;
        EtherAmount latestBalance = await _transactionService.getBalance(address.hex);
        double latestBalanceInEther = latestBalance.getValueInUnit(EtherUnit.ether);

        double balance = latestBalanceInEther;
        emit(WalletLoaded(
          balance: balance,
          walletAddress: walletAddress,
          privateKey: pvKey,
        ));
      } else {
        emit(const WalletError('No wallet found'));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> saveWalletInfo(List<String> mnemonicWords) async {
    String privateKey = await _walletAddressService.getPrivateKeyFromMnemonic(mnemonicWords.join(" "));
    _walletService.setPrivateKey(privateKey);
  }
}
