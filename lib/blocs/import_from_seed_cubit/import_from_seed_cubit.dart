import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/utils/password_util.dart';

part 'import_from_seed_state.dart';

class ImportFromSeedCubit extends Cubit<ImportFromSeedState> {
  final WalletService _walletService = GetIt.I<WalletService>();
  final _walletAddressService = GetIt.I<WalletAddressService>();

  ImportFromSeedCubit() : super(ImportFromSeedInitial());

  Future<void> importFromSeed(String seedPhrase, String password) async {
    emit(ImportFromSeedLoading());
    try {
      // Save private key to local storage
      await _walletAddressService.importWalletFromSeed(seedPhrase.trim());
      // Save password to local storage
      await PasswordUtil.savePassword(password);
      // Save private key to wallet service
      String privateKey = await _walletAddressService.getPrivateKeyFromMnemonic(seedPhrase);
      _walletService.setPrivateKey(privateKey);
      emit(ImportFromSeedSuccess());
    } catch (e) {
      print("[ImportFromSeedCubit] ERROR: $e");
      emit(ImportFromSeedFailure(e.toString()));
    }
  }
}
