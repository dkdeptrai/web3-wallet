part of 'import_from_seed_cubit.dart';

sealed class ImportFromSeedState extends Equatable {
  const ImportFromSeedState();

  @override
  List<Object> get props => [];
}

final class ImportFromSeedInitial extends ImportFromSeedState {}

final class ImportFromSeedLoading extends ImportFromSeedState {}

final class ImportFromSeedSuccess extends ImportFromSeedState {}

final class ImportFromSeedFailure extends ImportFromSeedState {
  final String message;

  const ImportFromSeedFailure(this.message);

  @override
  List<Object> get props => [message];
}
