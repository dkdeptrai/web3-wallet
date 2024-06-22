part of 'tokens_cubit.dart';

sealed class TokensState extends Equatable {
  const TokensState();

  @override
  List<Object> get props => [];
}

final class TokensInitial extends TokensState {}

final class TokensLoading extends TokensState {}

final class TokensLoaded extends TokensState {
  final List<Token> tokens;

  const TokensLoaded(this.tokens);

  @override
  List<Object> get props => [tokens];
}

final class TokensError extends TokensState {
  final String message;

  const TokensError(this.message);

  @override
  List<Object> get props => [message];
}
