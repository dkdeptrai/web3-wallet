part of 'news_cubit.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsLoaded extends NewsState {
  final List<Article> articles;
  final int page;
  final int pageSize;

  const NewsLoaded({required this.articles, required this.page, required this.pageSize});

  @override
  List<Object> get props => [articles, page, pageSize];
}

final class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object> get props => [message];
}

final class NewsLoadingMore extends NewsLoaded {
  const NewsLoadingMore({required super.articles, required super.page, required super.pageSize});
}
