import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletService _walletService = GetIt.I<WalletService>();
  final ETHWalletService walletAddressService = GetIt.I<ETHWalletService>();
  late SepoliaTransactionService transactionService = GetIt.I<SepoliaTransactionService>();

  WalletCubit() : super(WalletInitial());

  Future<void> loadWallet() async {
    emit(WalletLoading());

    try {
      if (!transactionService.isInitialized()) {
        transactionService.init();
      }

      String? privateKey = await _walletService.getPrivateKey();
      print("Private key: $privateKey");
      if (privateKey != null) {
        EthereumAddress address = await walletAddressService.getPublicKey(privateKey);
        String walletAddress = address.hex;
        String pvKey = privateKey;
        EtherAmount latestBalance = await transactionService.getBalance(address.hex);
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
    String privateKey = await walletAddressService.getPrivateKeyFromMnemonic(mnemonicWords.join(" "));
    _walletService.setPrivateKey(privateKey);
  }
}