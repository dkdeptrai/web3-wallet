part of 'authentication_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  const Authenticated();

  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthenticationState {
  const Unauthenticated();

  @override
  List<Object> get props => [];
}

class WrongPassword extends AuthenticationState {
  const WrongPassword();

  @override
  List<Object> get props => [];
}
