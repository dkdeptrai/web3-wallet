import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/exceptions/exceptions.dart';
import 'package:web3_wallet/model/models.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3_wallet/utils/password_util.dart';
import 'package:web3dart/web3dart.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final WalletService _walletService = GetIt.I<WalletService>();
  final AuthService _authService = GetIt.I<AuthService>();
  final ETHWalletService _walletAddressService = GetIt.I<ETHWalletService>();

  AuthenticationCubit() : super(const Unauthenticated());

  Future<void> verifyPassword({required String password}) async {
    final isValid = await PasswordUtil.verifyPassword(password);
    if (!isValid) {
      emit(const WrongPassword());
      return;
    }
  }

  Future<void> authenticate() async {
    try {
      String? privateKey = await _walletService.getPrivateKey();
      print("Private key: $privateKey");
      if (privateKey != null) {
        EthereumAddress address = await _walletAddressService.getPublicKey(privateKey);
        String walletAddress = address.hex;
        print("walletAddress: $walletAddress");
        final user = await _authService.authenticate(publicAddress: walletAddress);
        print("user: $user");
        emit(Authenticated(user: user));
      } else {
        emit(const AuthenticationError("No wallet found"));
        return;
      }
    } on ApiException catch (e) {
      print("Api ERROR [AuthenticationCubit.authenticate]: ${e.message})}");
      emit(AuthenticationError(e.toString()));
    } catch (e) {
      print("ERROR [AuthenticationCubit.authenticate]: ${e.toString()}");
      emit(AuthenticationError(e.toString()));
    }
  }

  Future<void> register() async {
    try {
      String? privateKey = await _walletService.getPrivateKey();
      if (privateKey != null) {
        EthereumAddress address = await _walletAddressService.getPublicKey(privateKey);
        String walletAddress = address.hex;
        final user = await _authService.register(publicAddress: walletAddress);
        emit(Authenticated(user: user));
      } else {
        emit(const AuthenticationError("No wallet found"));
        return;
      }
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  Future<void> logout() async {
    await PasswordUtil.deletePassword();
    emit(const Unauthenticated());
    print("Logged out!");
  }
}
