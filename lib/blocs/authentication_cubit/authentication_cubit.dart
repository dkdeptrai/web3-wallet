import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web3_wallet/utils/password_util.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const Unauthenticated());

  Future<void> authenticate({required String password}) async {
    final isValid = await PasswordUtil.verifyPassword(password);
    if (!isValid) {
      emit(const WrongPassword());
      return;
    }
    emit(const Authenticated());
    print("Authenticated!");
  }
}
