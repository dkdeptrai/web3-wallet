part of 'history_cubit.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistoryLoaded extends HistoryState {
  final List<TransactionModel> transactions;
  final int page;
  final int pageSize;

  const HistoryLoaded({
    required this.transactions,
    required this.page,
    required this.pageSize,
  });

  @override
  List<Object> get props => [transactions, page, pageSize];
}

final class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}

final class HistoryLoadingMore extends HistoryLoaded {
  const HistoryLoadingMore({required super.transactions, required super.page, required super.pageSize});
}
